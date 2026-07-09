# 性能指标面板 — 实现方案说明书

**Status**: `Implemented`

> 本文档描述的是性能面板的原始设计方案与模块拆分。目前该性能面板（APM 性能监控面板）已在 `ListenCore` 与 Flutter App 中完整实现。最终落地的详细技术设计与实现请参考最新的 [APM 性能监控面板设计与实现文档](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/apm_performance_monitoring_design.md)。

## 1. 概述

### 1.1 产品定位

**客户端 APM（Application Performance Monitoring）轻量实现**：在 App 内实时展示 FPS/jank 帧率图表和页面首帧/Intent 执行耗时，供开发者（自己）调试性能问题，同时作为 Portfolio 技术能力展示。

### 1.2 核心决策摘要

| 决策项 | 选择 | 理由 |
|--------|------|------|
| 核心目标 | 补全指标 + 可视化 | 现有 PerfTrace 只输出文本日志，缺 FPS/内存 |
| 指标范围 | 纯 Dart（无 Platform Channel） | Portfolio 场景足够，避免原生代码维护 |
| UI 方案 | Overlay 迷你折线图 + Log Overlay 内 Perf Tab | 实时监控 + 历史详情，两者结合 |
| 架构关系 | FPS 监控 vs PerfTrace 独立模块 | 数据模型和采集方式完全不同 |
| 持久化 | Phase 1 不做（内存）；Phase 2 可选 SP | 实时展示是核心价值，持久化 ROI 低 |
| 受众 | 自己调试 + 面试展示 | 代码架构质量 > 功能完整性 |
| FPS 阈值 | 业界标准 16.67ms/33ms | 无需自定义 |

### 1.3 现有基础设施

```
已有（ListenCore）                         本次新增
─────────────────                         ─────────
ZoneManager                               FrameMonitor（FPS/jank 采集）
  ├── runPage() → 首帧耗时                  ├── addTimingsCallback
  ├── run()     → Intent 耗时              ├── 环形缓冲区
  ├── mark()    → 分段计时                  └── jank 检测
  └── _PerfTrace → 文本日志输出
                                          PerfTraceStore（结构化存储）
LogManager                                  ├── 收集 _PerfTrace 数据
  └── 100 条日志，滚动丢弃                    └── 内存列表，独立于 LogManager

Log Overlay                               UI 扩展
  ├── 浮动按钮（50x50）                      ├── 按钮旁 FPS 迷你折线图
  ├── 窗口：All/Server/App/Perf filter       └── 窗口内新增 Perf Dashboard Tab
  └── Trace ID 过滤
```

---

## 2. 系统架构

> [!NOTE]
> 本章节及后续所描述的系统架构、数据模型、实现细节与 UI 界面已在底座和主工程中完全实现，具体开发细节请看最新的 [设计与实现文档](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/apm_performance_monitoring_design.md)。

### 2.1 模块划分

```
┌──────────────────────────────────────────────────────────┐
│                     ListenCore                            │
│                                                           │
│  ┌─────────────────┐    ┌──────────────────────────────┐ │
│  │  ZoneManager     │    │  FrameMonitor（新增）         │ │
│  │  (已有，不改动)   │    │                              │ │
│  │                  │    │  - addTimingsCallback 监听    │ │
│  │  runPage()       │    │  - 环形缓冲区 (300帧≈5秒)    │ │
│  │  run()           │    │  - FPS 计算 (滑动窗口)       │ │
│  │  mark()          │    │  - Jank 检测                 │ │
│  │  _PerfTrace      │    │  - 内存采样 (ProcessInfo)    │ │
│  │                  │    │  - ValueNotifier 驱动 UI     │ │
│  └────────┬─────────┘    └──────────────┬───────────────┘ │
│           │                             │                  │
│  ┌────────▼─────────┐                   │                  │
│  │ PerfTraceStore    │                   │                  │
│  │ （新增）           │                   │                  │
│  │                   │                   │                  │
│  │ - 收集 runPage    │                   │                  │
│  │   首帧耗时数据     │                   │                  │
│  │ - 收集 Intent     │                   │                  │
│  │   执行耗时数据     │                   │                  │
│  │ - 内存列表        │                   │                  │
│  │   (最近200条)      │                   │                  │
│  │ - ValueNotifier   │                   │                  │
│  └───────────────────┘                   │                  │
│                                          │                  │
└──────────────────────────┼───────────────┼──────────────────┘
                           │               │
┌──────────────────────────▼───────────────▼──────────────────┐
│                  ListenPortfolioFlutter                       │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Log Overlay（扩展）                         │ │
│  │                                                        │ │
│  │  ┌──────────────┐  ┌──────────────────────────────┐   │ │
│  │  │ 浮动按钮      │  │ 展开窗口                      │   │ │
│  │  │              │  │                              │   │ │
│  │  │ [🐛] ──────┐ │  │  Tab Bar:                    │   │ │
│  │  │       FPS   │ │  │  [Logs] [Perf Dashboard]    │   │ │
│  │  │  迷你折线图  │ │  │                              │   │ │
│  │  │  (50x20px)  │ │  │  Perf Dashboard:             │   │ │
│  │  │             │ │  │  ┌── FPS 实时折线图 ────────┐ │   │ │
│  │  └─────────────┘ │  │  │  60|         ╭──╮        │ │   │ │
│  │                   │  │  │  30|    ╭───╯  ╰───╮    │ │   │ │
│  │                   │  │  │   0|───╯            ╰── │ │   │ │
│  │                   │  │  └─────────────────────────┘ │   │ │
│  │                   │  │  ┌── 内存趋势 ──────────────┐ │   │ │
│  │                   │  │  │  156 MB (Dart RSS)       │ │   │ │
│  │                   │  │  └─────────────────────────┘ │   │ │
│  │                   │  │  ┌── Jank 统计 ─────────────┐ │   │ │
│  │                   │  │  │  Janks: 3  Severe: 0     │ │   │ │
│  │                   │  │  │  Worst: 42ms (HomePage)  │ │   │ │
│  │                   │  │  └─────────────────────────┘ │   │ │
│  │                   │  │  ┌── Page Traces ───────────┐ │   │ │
│  │                   │  │  │  HomePage     │ 12ms     │ │   │ │
│  │                   │  │  │  ProjectsPage │ 28ms     │ │   │ │
│  │                   │  │  │  SettingsPage │  8ms     │ │   │ │
│  │                   │  │  └─────────────────────────┘ │   │ │
│  │                   │  │  ┌── Intent Traces ─────────┐ │   │ │
│  │                   │  │  │  LoadProjects │ 450ms    │ │   │ │
│  │                   │  │  │  Login        │ 1200ms   │ │   │ │
│  │                   │  │  └─────────────────────────┘ │   │ │
│  │                   │  └──────────────────────────────┘   │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

### 2.2 数据流

```
===== FrameMonitor（实时帧数据）=====

Flutter Engine
    │  SchedulerBinding.addTimingsCallback(List<FrameTiming>)
    ▼
FrameMonitor
    │  每帧计算:
    │  - buildDuration = vsyncStart → buildEnd
    │  - rasterDuration = rasterStart → rasterEnd
    │  - totalDuration = max(build, raster)
    │  - isJank = totalDuration > 16.67ms
    │  - isSevereJank = totalDuration > 33.33ms
    │
    ├──▶ RingBuffer<FrameMetric> (300帧)
    │     用于 FPS 折线图绘制
    │
    ├──▶ FPS 计算 (最近60帧滑动窗口)
    │     fps = 窗口内帧数 / 窗口时间跨度
    │
    ├──▶ Jank 计数器
    │     jankCount / severeJankCount (可重置)
    │
    └──▶ ValueNotifier<FrameMonitorSnapshot>
          驱动 UI 更新 (节流: 最多 4次/秒)


===== PerfTraceStore（操作追踪数据）=====

ZoneManager._logSummary()
    │  现有: 输出到 LogManager (文本)
    │  新增: 同时写入 PerfTraceStore (结构化)
    ▼
PerfTraceStore
    │  解析 _PerfTrace._summary() 为结构化数据:
    │  - traceId
    │  - label (Page Render / Intent / Task)
    │  - stages: [{name, durationMs}]
    │  - totalMs
    │  - timestamp
    │
    ├──▶ List<PerfTraceEntry> (最近200条)
    │
    └──▶ ValueNotifier<List<PerfTraceEntry>>
          驱动 Perf Dashboard Tab
```

---

## 3. 技术栈

### 3.1 ListenCore 新增

| 组件 | 文件 | 职责 | 依赖 |
|------|------|------|------|
| `FrameMonitor` | `utils/frame_monitor.dart` | 帧率采集 + FPS 计算 + jank 检测 | `dart:ui`（FrameTiming）|
| `FrameMetric` | 同上 | 单帧数据模型 | 无 |
| `FrameMonitorSnapshot` | 同上 | UI 快照（FPS/jank 数/内存） | 无 |
| `RingBuffer<T>` | `utils/ring_buffer.dart` | 通用环形缓冲区 | 无 |
| `PerfTraceStore` | `utils/perf_trace_store.dart` | 结构化 perf 数据存储 | 无 |
| `PerfTraceEntry` | 同上 | 单条 trace 数据模型 | 无 |

> **零新增 pub 依赖**：全部用 Flutter/Dart 内置 API。

### 3.2 ListenPortfolioFlutter 修改

| 组件 | 文件 | 改动 |
|------|------|------|
| `LogOverlayManager` | `log_overlay_manager.dart` | 浮动按钮旁增加 FPS 迷你图 |
| `_LogOverlayWidget` | 同上 | 窗口内增加 Logs/Perf Tab 切换 |
| `_PerfDashboardTab` | 新文件或同文件 | Perf Dashboard 完整 UI |
| `_FpsMiniChart` | 新 Widget | CustomPainter 绘制迷你折线图 |
| `_FpsLineChart` | 新 Widget | CustomPainter 绘制大折线图 |

---

## 4. 核心数据模型

### 4.1 FrameMonitor

```dart
/// 单帧指标
class FrameMetric {
  final DateTime timestamp;
  final int buildDurationUs;    // 微秒
  final int rasterDurationUs;   // 微秒
  final int totalDurationUs;    // max(build, raster)
  final bool isJank;            // > 16670us
  final bool isSevereJank;      // > 33340us
}

/// UI 快照（ValueNotifier 驱动）
class FrameMonitorSnapshot {
  final double fps;             // 当前 FPS (0-60+)
  final int jankCount;          // 累计 jank 帧数
  final int severeJankCount;    // 累计 severe jank 帧数
  final int worstFrameUs;       // 最慢帧（微秒）
  final int memoryMB;           // Dart RSS (MB)
  final List<FrameMetric> recentFrames;  // 环形缓冲区快照
}
```

### 4.2 PerfTraceEntry

```dart
/// 结构化追踪条目
class PerfTraceEntry {
  final String traceId;
  final String label;           // "Page Render" / "Intent" / "Task"
  final String name;            // "HomePage" / "LoadProjectsIntent"
  final List<PerfStage> stages; // 分段明细
  final int totalMs;
  final DateTime timestamp;
}

class PerfStage {
  final String name;            // "First Frame Rendered" / "Intent Started"
  final int durationMs;
}
```

### 4.3 RingBuffer

```dart
/// 固定大小环形缓冲区，满时覆盖最旧元素
class RingBuffer<T> {
  final int capacity;
  final List<T?> _buffer;
  int _head = 0;
  int _count = 0;

  RingBuffer(this.capacity) : _buffer = List.filled(capacity, null);

  void add(T item) { ... }
  List<T> toList() { ... }  // 按时间顺序返回
  int get length => _count;
  void clear() { ... }
}
```

---

## 5. FrameMonitor 实现细节

### 5.1 帧率采集

```dart
class FrameMonitor {
  static final FrameMonitor _instance = FrameMonitor._();
  static FrameMonitor get instance => _instance;
  FrameMonitor._();

  final RingBuffer<FrameMetric> _frames = RingBuffer(300); // ~5秒 @60fps
  int _jankCount = 0;
  int _severeJankCount = 0;
  int _worstFrameUs = 0;
  bool _isRunning = false;

  // 节流: 最多每 250ms 通知一次 UI
  final ValueNotifier<FrameMonitorSnapshot> snapshot = ValueNotifier(...);
  DateTime _lastNotify = DateTime.now();

  /// Jank 阈值
  static const int jankThresholdUs = 16670;       // 1帧 = 16.67ms
  static const int severeJankThresholdUs = 33340;  // 2帧

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  void stop() {
    if (!_isRunning) return;
    _isRunning = false;
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      final buildUs = timing.buildDuration.inMicroseconds;
      final rasterUs = timing.rasterDuration.inMicroseconds;
      final totalUs = buildUs > rasterUs ? buildUs : rasterUs;

      final metric = FrameMetric(
        timestamp: DateTime.now(),
        buildDurationUs: buildUs,
        rasterDurationUs: rasterUs,
        totalDurationUs: totalUs,
        isJank: totalUs > jankThresholdUs,
        isSevereJank: totalUs > severeJankThresholdUs,
      );

      _frames.add(metric);
      if (metric.isJank) _jankCount++;
      if (metric.isSevereJank) _severeJankCount++;
      if (totalUs > _worstFrameUs) _worstFrameUs = totalUs;
    }

    _throttledNotify();
  }

  void _throttledNotify() {
    final now = DateTime.now();
    if (now.difference(_lastNotify).inMilliseconds < 250) return;
    _lastNotify = now;
    snapshot.value = _buildSnapshot();
  }

  double _calculateFps() {
    final frames = _frames.toList();
    if (frames.length < 2) return 0;
    // 最近60帧的时间跨度
    final recent = frames.length > 60 ? frames.sublist(frames.length - 60) : frames;
    final span = recent.last.timestamp.difference(recent.first.timestamp);
    if (span.inMicroseconds == 0) return 60;
    return (recent.length - 1) / (span.inMicroseconds / 1000000);
  }
}
```

### 5.2 内存采样

```dart
import 'dart:io' show ProcessInfo;

/// Dart RSS 内存 (不准确，但无需 Platform Channel)
static int get currentMemoryMB {
  try {
    return ProcessInfo.currentRss ~/ (1024 * 1024);
  } catch (_) {
    return 0; // Web 平台不支持
  }
}
```

> **注意**：`ProcessInfo.currentRss` 只在 iOS/Android 原生运行时可用，Web 上返回 0。这是纯 Dart 方案的已知限制。

### 5.3 FPS 颜色规则

```
FPS >= 55    → 绿色 (Colors.greenAccent)    正常
50 <= FPS < 55 → 黄色 (Colors.yellowAccent)  警告
FPS < 50     → 橙色 (Colors.orangeAccent)    卡顿
FPS < 30     → 红色 (Colors.redAccent)       严重
```

---

## 6. PerfTraceStore 与 ZoneManager 集成

### 6.1 最小化侵入方案

**不修改 `_PerfTrace` 类**。只在 `ZoneManager._logSummary()` 中增加一行调用：

```dart
// zone_manager.dart 修改 (2行)
static void _logSummary(String id, _PerfTrace perf, {String label = _labelPerformance}) {
  final summary = perf._summary();
  if (summary.isNotEmpty) {
    appLogger.d('$label ${LogManager.summaryTag}: $summary');

    // 新增: 同时写入结构化存储
    PerfTraceStore.instance.record(
      traceId: id, label: label, stages: perf._stages, totalMs: perf._stopwatch.elapsedMilliseconds,
    );
  }
}
```

**需要将 `_PerfTrace._stages` 和 `_stopwatch` 可读性开放**给 `PerfTraceStore`：

```dart
// 方案: 在 _PerfTrace 中增加 getter
List<({String name, int duration})> get stages => List.unmodifiable(_stages);
int get elapsedMs => _stopwatch.elapsedMilliseconds;
```

这是对 `zone_manager.dart` 的**唯一改动**，总共增加 ~5 行代码。

---

## 7. UI 设计

### 7.1 浮动按钮 — FPS 迷你折线图

```
现有:                    改为:
┌──────┐                ┌──────┬─────────────────┐
│  🐛  │                │  🐛  │ ▁▃▅▇▅▃▁▃▅▇▅▃▁ │
│      │                │      │      58 fps     │
└──────┘                └──────┴─────────────────┘
 50x50                    50x50 + 80x40 附加区域
```

**实现**：`CustomPainter`，绘制最近 30 帧的帧耗时折线。

```dart
class _FpsMiniChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FrameMonitorSnapshot>(
      valueListenable: FrameMonitor.instance.snapshot,
      builder: (context, snapshot, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(70, 20),
              painter: _MiniChartPainter(
                frames: snapshot.recentFrames,
                color: _fpsColor(snapshot.fps),
              ),
            ),
            Text(
              '${snapshot.fps.round()} fps',
              style: TextStyle(
                color: _fpsColor(snapshot.fps),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}
```

### 7.2 Log Overlay 窗口 — Tab 切换

```
┌──────────────────────────────────────────────────┐
│ 🖥️ App Logs    [filter] [refresh] [copy] [clear] │  ← Header 不变
├──────────────────────────────────────────────────┤
│  ┌──────────┐ ┌─────────────────┐                │  ← 新增 Tab Bar
│  │  📋 Logs  │ │ 📊 Perf Dashboard│               │
│  └──────────┘ └─────────────────┘                │
├──────────────────────────────────────────────────┤
│                                                  │
│  === 选中 Logs Tab ===                            │
│  (现有的日志列表 + filter bar，完全不变)             │
│                                                  │
│  === 选中 Perf Dashboard Tab ===                  │
│                                                  │
│  ┌─ FPS ──────────────────────────────────────┐  │
│  │ 🟢 58 fps    Jank: 3  Severe: 0           │  │
│  │                                            │  │
│  │  60|         ╭──╮      ╭──╮               │  │
│  │  40|    ╭───╯  ╰───╮──╯  ╰──╮            │  │
│  │  20|───╯                      ╰───        │  │
│  │   0|──────────────────────────────         │  │
│  │     -5s         -3s         -1s    now     │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  ┌─ Memory ───────────────────────────────────┐  │
│  │ 📊 Dart RSS: 142 MB                        │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  ┌─ Page Traces (首帧耗时) ───────────────────┐  │
│  │  Page              First Frame    Time     │  │
│  │  ──────────────────────────────────────     │  │
│  │  🟢 HomePage        12ms         14:30:01  │  │
│  │  🟡 ProjectsPage    28ms         14:30:03  │  │
│  │  🟢 SettingsPage     8ms         14:30:05  │  │
│  │  🟢 AboutPage        6ms         14:30:08  │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  ┌─ Intent Traces (操作耗时) ─────────────────┐  │
│  │  Intent              Total   Stages        │  │
│  │  ──────────────────────────────────────     │  │
│  │  LoadProjects        450ms   [▸ 展开]      │  │
│  │    ├ Intent Started     2ms                │  │
│  │    ├ API Call         320ms                │  │
│  │    ├ Parse Response    15ms                │  │
│  │    └ Intent Finished    3ms                │  │
│  │  Login              1200ms   [▸ 展开]      │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 7.3 Page Trace 颜色规则

```
首帧耗时 <= 16ms   → 🟢 绿色
16ms < 耗时 <= 32ms → 🟡 黄色
耗时 > 32ms         → 🔴 红色
```

### 7.4 FPS 折线图 — CustomPainter

```dart
class _FpsChartPainter extends CustomPainter {
  final List<FrameMetric> frames;

  @override
  void paint(Canvas canvas, Size size) {
    // X 轴: 时间 (最近 5 秒)
    // Y 轴: 帧耗时 (0 - 50ms)
    // 绿色区域: 0-16.67ms (安全)
    // 黄色区域: 16.67-33ms (jank)
    // 红色区域: >33ms (severe jank)

    // 1. 绘制背景安全区域 (半透明绿色条带)
    // 2. 绘制 16.67ms 和 33ms 参考线 (虚线)
    // 3. 绘制帧耗时折线 (渐变色)
    // 4. Jank 帧用红点标注
  }
}
```

---

## 8. 分步执行计划

### Phase 1：ListenCore — FrameMonitor（1.5 天）

| 步骤 | 任务 | 文件 |
|------|------|------|
| 1.1 | 创建 `RingBuffer<T>` 通用环形缓冲区 | `utils/ring_buffer.dart` |
| 1.2 | 创建 `FrameMetric` / `FrameMonitorSnapshot` 数据模型 | `utils/frame_monitor.dart` |
| 1.3 | 实现 `FrameMonitor`：`addTimingsCallback` 监听 + FPS 计算 + jank 检测 | 同上 |
| 1.4 | 实现内存采样（`ProcessInfo.currentRss`） | 同上 |
| 1.5 | 节流通知（`ValueNotifier`，250ms 间隔） | 同上 |
| 1.6 | `core.dart` 添加 export | `core.dart` |
| 1.7 | 单测：RingBuffer 增删查 + FPS 计算逻辑 + jank 阈值 | `test/` |

**Phase 1 交付标准**：`FrameMonitor.instance.start()` 后，`snapshot` ValueNotifier 持续输出 FPS/jank 数据。

### Phase 2：ListenCore — PerfTraceStore（1 天）

| 步骤 | 任务 | 文件 |
|------|------|------|
| 2.1 | 创建 `PerfTraceEntry` / `PerfStage` 数据模型 | `utils/perf_trace_store.dart` |
| 2.2 | 实现 `PerfTraceStore`：内存列表 + ValueNotifier | 同上 |
| 2.3 | `_PerfTrace` 添加 `stages` 和 `elapsedMs` getter | `utils/zone_manager.dart` |
| 2.4 | `ZoneManager._logSummary()` 增加 `PerfTraceStore.record()` 调用 | 同上 |
| 2.5 | `core.dart` 添加 export | `core.dart` |
| 2.6 | 单测：record + 容量上限 + 数据结构正确性 | `test/` |

**Phase 2 交付标准**：每次页面导航和 Intent 执行后，`PerfTraceStore` 自动收到结构化 trace 数据。

### Phase 3：Flutter — Overlay FPS 迷你图（1 天）

| 步骤 | 任务 | 文件 |
|------|------|------|
| 3.1 | 创建 `_FpsMiniChart` Widget（CustomPainter 迷你折线图） | `log_overlay_manager.dart` 或新文件 |
| 3.2 | 修改 `_buildFloatingButton()`：按钮旁增加迷你图 | `log_overlay_manager.dart` |
| 3.3 | `AppInitializer` 中调用 `FrameMonitor.instance.start()` | `app_initializer.dart` |
| 3.4 | 视觉微调：大小、间距、透明度 | 同上 |

**Phase 3 交付标准**：浮动按钮旁显示实时 FPS 迷你折线图和数字。

### Phase 4：Flutter — Perf Dashboard Tab（2 天）

| 步骤 | 任务 | 文件 |
|------|------|------|
| 4.1 | 窗口 Header 下方增加 Tab Bar（Logs / Perf Dashboard） | `log_overlay_manager.dart` |
| 4.2 | 创建 `_PerfDashboardTab` 容器 Widget | 同上或新文件 |
| 4.3 | FPS 折线图大图（`_FpsChartPainter`，CustomPainter） | 新 Widget |
| 4.4 | Jank 统计卡片（jank 数 / severe 数 / worst frame） | `_PerfDashboardTab` |
| 4.5 | Memory 卡片（Dart RSS） | `_PerfDashboardTab` |
| 4.6 | Page Traces 列表（首帧耗时，颜色标注） | `_PerfDashboardTab` |
| 4.7 | Intent Traces 列表（可展开分段明细） | `_PerfDashboardTab` |
| 4.8 | 清空/重置按钮 | `_PerfDashboardTab` |

**Phase 4 交付标准**：Log Overlay 窗口中可切换到 Perf Dashboard，展示完整的 FPS 图表 + Trace 列表。

---

## 9. ZoneManager 改动清单（最小侵入）

只需改 `zone_manager.dart` 中的 **3 处**：

```
改动 1: _PerfTrace 添加 2 个 getter (2行)
改动 2: _logSummary() 增加 1 行 PerfTraceStore.record() 调用
改动 3: (可选) _logError() 增加 1 行 PerfTraceStore.record() 调用
```

**总改动量：3-4 行**。不影响任何现有行为。

---

## 10. 启动与生命周期

```dart
// AppInitializer.init() 中添加:
if (kDebugMode || kProfileMode) {
  FrameMonitor.instance.start();
}
```

**只在 Debug/Profile 模式启动**。Release 模式不运行 FrameMonitor，零性能开销。

FrameMonitor 的 `stop()` 不需要手动调用 — App 退出时自动释放。

---

## 11. 风险与限制

| 风险 | 影响 | 缓解 |
|------|------|------|
| Debug 模式 FPS 不准确 | 显示值偏低 | UI 标注 "Debug mode - FPS may be lower" |
| `ProcessInfo.currentRss` 不含原生内存 | 内存值偏低 | 标注 "Dart RSS only" |
| Web 平台无 `ProcessInfo` | 内存显示 0 | 条件判断，Web 上隐藏内存卡片 |
| FrameMonitor 自身开销 | 极小（<0.1ms/帧） | 节流通知，250ms 间隔 |
| Overlay 区域拥挤 | 迷你图遮挡内容 | 可折叠/隐藏迷你图 |

---

## 12. 时间线总览

```
Phase 1: FrameMonitor     ██████                    1.5 天
Phase 2: PerfTraceStore   ████                      1 天
Phase 3: Overlay 迷你图   ████                      1 天
Phase 4: Perf Dashboard   ████████                  2 天
                          ──────────────────────
                          总计：5.5 天
```

**建议执行顺序**：Phase 1 → 2 → 3 → 4（严格串行）

Phase 1 + 2 在 ListenCore 中完成，纯逻辑无 UI，可独立测试。
Phase 3 + 4 在 ListenPortfolioFlutter 中完成，纯 UI。

---

## 13. 后续升级方向（Phase 2 可选）

| 升级项 | 触发条件 | 改动 |
|--------|----------|------|
| 首帧耗时持久化 | 想在面试中展示"回归检测" | SP 存 `Map<String, List<int>>`，半天 |
| Platform Channel 原生指标 | 需要精确 CPU/内存 | 增加 Android/iOS 原生代码 |
| Network Inspector 集成 | todo 中另一项需求 | 复用 Perf Dashboard Tab 架构 |
| CI 性能基准测试 | CI 就绪后 | `flutter test --profile` + benchmark |

---

**文档版本**: v1.0
**决策参与者**: Listen + Cascade
**创建日期**: 2026-04-07
**状态**: 待执行
