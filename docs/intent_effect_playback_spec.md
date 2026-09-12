# Intent & Effect 录制与回放系统 - 规格定义与工程落地规范

> [!NOTE]
> 本系统已在本项目中全面实现并投入生产验证。关于底层状态沙箱隔离细节、路由 didPop 拦截算法、确认对话框旁路机制与单元测试执行，请同时参阅 [Intent & Effect 录制与回放系统 - 架构设计与工程实现指南](intent_effect_playback_design.md)。

本文档正式定义了 **ListenPortfolio** 客户端中 **MVI Intent & Effect 本地录制与回放系统**（即“本地操作录像机”）的功能规格、数据契约、Clean Architecture 分层架构、核心技术难点与演进路线。

---

## 1. 规格背景与设计定位 (Specification Background & Positioning)

在现代跨平台应用开发中，面对复杂的业务流转与偶发缺陷，传统的端到端测试框架（如 Appium、Flutter Driver）存在环境依赖重、外部网络不可控、执行时耗长以及跨平台维护成本极高的弊端。

本项目立足于 **Clean Architecture + MVI (Model-View-Intent)** 单向数据流架构，确立了“**确定性输入必得确定性状态流转**”的工程基石：
1. **纯本地化运行 (Zero Cloud Dependency)**：录制与回放完全基于端侧本地持久化（`SpUtil` / `FlutterSecureStorage`），不需要任何远程云端服务或测试代理，彻底规避数据合规与网络波动风险；
2. **业务逻辑无侵入 (Zero-Boilerplate)**：不需要在各个 Widget 按钮或手势探测器上手工埋点，直接在 `ListenCore` 的 `BaseViewModel` 分发管道与 `Navigator` 路由栈统一收口拦截；
3. **缺陷路径高保真固化 (Tape as Defect Asset)**：用户或 QA 操作产生的所有事件被序列化为结构化“磁带 (Tape)”文本，包含操作时刻的底层环境快照（SP & 凭证）与时序行为，可在任意研发设备上一键秒级复现。

```mermaid
flowchart TD
    subgraph 录制规格 (Recording Specification)
        User[用户交互 / QA 探索] -->|派发| Intent[BaseIntent]
        Intent -->|AOP 架构拦截| Observer[MviPlaybackObserver]
        Nav[Navigator didPop] -->|路由返回拦截| AppNavHook[AppNav.onRoutePopped]
        Observer -->|收集时序步骤| Recorder[MviPlaybackRecorder]
        AppNavHook -->|收集返回动作| Recorder
        Recorder -->|首帧环境快照| Snapshot[SP & SecureStorage Snapshot]
        Recorder -->|saveTapeDelegate 控制反转| RepoImpl[PlaybackTapeRepositoryImpl]
        RepoImpl -->|两级索引落盘| SP[(SharedPreferences)]
    end

    subgraph 磁带管理规格 (Catalog & Clean Architecture)
        SP -->|只读轻量元数据索引| Repo[PlaybackTapeRepository]
        Repo -->|注入| UseCases[Domain UseCases]
        UseCases -->|驱动| VM[PlaybackTapeListViewModel]
        VM -->|展示 / 交互| UI[PlaybackTapeListPage]
    end

    subgraph 回放规格 (Replay Specification)
        UI -->|点击播放| Player[MviPlaybackPlayer]
        Player -->|1. 隔离缓存真实环境| Sandbox[State Sandbox]
        Player -->|2. 注入磁带初始快照| Sandbox
        Player -->|3. 对齐路由栈| AppNav[AppNav.offAll]
        Player -->|4. 动态解析| Registry[MviPlaybackRegistry]
        Player -->|5. 调度执行| ActiveVM[ActiveViewModels.get]
        ActiveVM -->|handleIntent| BizVM[Target BaseViewModel]
        BizVM -->|自动旁路放行| Confirm[ConfirmProviderImpl]
        Player -->|finally 强制还原| Sandbox
    end
```

---

## 2. 核心应用场景与产品价值 (Core Business Scenarios)

### 2.1 零网络依赖的密封自动化回归 (Hermetic Automated Regression)
* **业务痛点**：传统自动化集成测试在验证“登录 ➡️ 修改个人资料 ➡️ 切换多语言 ➡️ 退出登录”长链路时，若依赖真实测试服 API，极易受网络超时、Token 失效或后端脏数据干扰，产生大量偶发假阳性报错（Flaky Tests）。
* **规格方案**：在开发或测试环境录制一次真实操作，系统将其固化为标准 JSON 磁带。在本地回归或 CI 流水线中，回放器在纯内存沙箱中以毫秒级节奏（默认步延时 1200ms）自动回放，所有接口请求被本地 `MockClient` 拦截，实现 100% 稳定且可重复的密封测试。

### 2.2 线上/线下崩溃与偶发缺陷精准复现 (Crash & Defect Reproduction)
* **业务痛点**：QA 报告“注销账号时偶尔闪退”，但研发仅能获得一条脱敏堆栈，无法得知用户在崩溃前进行了何种复杂的手势跳跃与组合操作，沟通成本极高。
* **规格方案**：测试人员或灰度用户直接在 App 内开启录制，操作复现崩溃后，系统自动在本地生成磁带。研发人员进入设置页的 **录像磁带列表 (`PlaybackTapeListPage`)**，点击该磁带即可全自动重演整个操作现场，彻底根除“在我机器上没问题”的推诿现象。

### 2.3 架构透明化与面试教学演示 (Architectural Transparency & Demo)
* **展示价值**：在设置页提供直观的可视化操作入口，支持一键点击“执行回放”。界面将如同播放电影一般，自动模拟输入文本、弹出对话框并自动确认、自动平滑跳转路由，同时在顶部广播进度（`PlaybackProgress`），并在 APM `LogOverlay` 悬浮窗中同步滚动每一步 Intent 与 Trace ID，展现工业级 Clean Architecture + MVI 架构的深厚掌控力。

---

## 3. 系统功能规格定义 (Functional Specifications)

系统被划分为三大核心功能子系统：**录制引擎 (`MviPlaybackRecorder`)**、**回放引擎 (`MviPlaybackPlayer`)** 与 **磁带管理仓储层 (`PlaybackTapeRepository`)**。

### 3.1 录制引擎规格 (`MviPlaybackRecorder`)

| 规格项 | 规格定义与行为约束 |
| :--- | :--- |
| **单例模式** | 全局唯一实例 `MviPlaybackRecorder.instance`，私有构造器禁止外部随意实例化。 |
| **观察者绑定** | 调用 `startRecording()` 时，**同步立即**将 `_onIntent`、`_onEffect` 与 `_onRoutePopped` 挂接至 `MviPlaybackObserver` 与 `AppNav`，严防异步挂载导致漏记前置动作。 |
| **基线环境快照** | 录制启动瞬间自动捕获 `SpUtil` 全量键值与 `SecureStorageUtil` 敏感凭证（`auth_token`、`refresh_token`、`login_password`），并存储为类型为 `INITIAL_STATE` 的步骤。 |
| **防递归污染** | 在快照提取循环中，强制过滤包含 `AppConstants.playbackTapeKey` 与 `playbackTapesListKey` 的键名，防止磁带自身数据呈指数级递归膨胀。 |
| **动态标题推导** | 若停止录制时未提供自定义名称，系统自动提取录制到的首个 `INTENT` 步骤，按照 `[ViewModelTag] -> [ActionName]` 规则推导默认标题（如 `LoginViewModel -> submit`）。 |
| **控制反转存储** | 录制器自身不硬编码依赖数据库或 SP，而是暴露静态委托 `saveTapeDelegate`，由宿主在应用初始化阶段注入 Clean Architecture 仓储实现。 |

### 3.2 回放引擎规格 (`MviPlaybackPlayer`)

| 规格项 | 规格定义与行为约束 |
| :--- | :--- |
| **并发保护** | 严格单会话执行。若检测到 `progress.isPlaying == true`，再次调用 `play()` 直接静默丢弃，防止多重回放交织竞争。 |
| **步延时节拍** | 统一步间延时 `stepDelay = const Duration(milliseconds: 1200)`，为 Flutter 页面路由转场、Hero 动画与软键盘收起提供充分的渲染就绪时间。 |
| **路由初态重置** | 回放启动后，首先执行 `AppNav.offAll(Routes.home)` 将路由栈彻底清空回退至首页，随后若首个 Intent 属于特定子页面，则自动导航至目标起始页。 |
| **动态意图分发** | 针对 `INTENT` 步骤，通过 `ActiveViewModels.get(tag)` 查询活跃 ViewModel 实例；若存在则通过 `MviPlaybackRegistry` 反序列化为强类型对象并调用 `vm.handleIntent(intent)`；若不存在则记录警告日志并安全跳过，防止死锁。 |
| **路由出栈防重** | 针对 `POP` 步骤，使用 `navigatorKey.currentState.popUntil` 作为只读探针检查当前栈顶。若为尚未关闭的弹窗或匹配的目标页面，调用 `AppNav.back()`；若已被业务逻辑自动关闭，则智能跳过，杜绝多退页面。 |
| **确认弹窗旁路** | 在回放期间触发 `ConfirmEffect` 时，`ConfirmProviderImpl` 识别回放态并自动执行 `effect.onResult(true)`，实现自动化放行。 |
| **环境强制还原** | 回放整体处于 `try ... finally` 保护中，无论成功、失败还是中途异常中断，必定在 `finally` 中将执行前备份的会话与持久化全量还原，并同步调用 `authManager.login/logout`。 |
| **单向进度广播** | 通过不可变模型 `PlaybackProgress` 封装 `isPlaying`、`status`、`currentStepIndex`、`totalSteps`，并在每步更新时触发 `onProgressChanged` 回调。 |

### 3.3 磁带管理仓储层规格 (`PlaybackTapeListPage` & Domain Layer)

在设置模块中落地了符合 Clean Architecture 严格单向依赖规范的磁带管理功能：
* **数据目录轻量呈现**：页面加载时调用 `GetPlaybackTapesUseCase` 读取磁带元数据列表，按时间倒序展示；
* **时序步骤检查 (Inspect)**：点击列表项触发 `PlaybackTapeListIntent.showTapeDetails`，调起详情对话框查看全部步骤的时序索引与类型标签；
* **一键回放 (Play)**：点击卡片右侧播放图标触发 `PlaybackTapeListIntent.startPlayback`，加载完整步骤并通过 `PlayTapeEffect` 唤起回放器；
* **安全删除 (Delete)**：点击删除图标发射 `ConfirmEffect`，用户二次确认后通过 `DeletePlaybackTapeUseCase` 彻底清除存储。

---

## 4. 数据契约与存储架构规格 (Data Contract & Storage Specifications)

### 4.1 两级索引存储架构 (Two-Tier Storage Architecture)

为了在本地保存数十个甚至上百个磁带而不拖慢应用冷启动与列表加载，系统设计了**两级解耦的持久化键值模型**：

```
SharedPreferences
├── [Index Key] "playback_tapes_list"
│     └── JSON Array: [ PlaybackTapeMetadata, PlaybackTapeMetadata, ... ]
│           (轻量目录，仅包含 key, name, timestamp, steps)
│
├── [Payload Key] "playback_tape_1726100000000"
│     └── JSON Array: [ PlaybackStep, PlaybackStep, PlaybackStep, ... ]
│           (包含全量快照与完整时序步骤)
│
└── [Payload Key] "playback_tape_1726100005000"
      └── JSON Array: [ PlaybackStep, PlaybackStep, ... ]
```

### 4.2 Freezed 强类型数据模型规格

#### 1. 磁带元数据 (`PlaybackTapeMetadata`)
位于 [playback_tape_metadata.dart](../lib/features/settings/data/models/playback_tape_metadata.dart)：

```dart
@freezed
abstract class PlaybackTapeMetadata with _$PlaybackTapeMetadata {
  const factory PlaybackTapeMetadata({
    required String key,       // 对应底层步骤数组的唯一存储键
    required String name,      // 磁带标题 (默认或自定义)
    required int timestamp,    // 录制起始毫秒时间戳
    required int steps,        // 包含的总步骤数
  }) = _PlaybackTapeMetadata;

  factory PlaybackTapeMetadata.fromJson(Map<String, dynamic> json) =>
      _$PlaybackTapeMetadataFromJson(json);
}
```

#### 2. 单步时序动作 (`PlaybackStep`)
位于 [playback_step.dart](../lib/features/settings/data/models/playback_step.dart)：

```dart
@freezed
abstract class PlaybackStep with _$PlaybackStep {
  static const String initState = 'INITIAL_STATE';
  static const String intent = 'INTENT';
  static const String effect = 'EFFECT';
  static const String pop = 'POP';
  static const String system = 'system';
  static const String sp = 'sp';
  static const String secure = 'secure';

  const factory PlaybackStep({
    required String type,          // 步骤类别: INITIAL_STATE / INTENT / EFFECT / POP
    required String viewModelTag,  // 目标 ViewModel 标签 (或 system)
    required String name,          // 意图/副作用序列化字符串或环境快照 JSON
    String? route,                 // 触发该步骤时的页面路由路径
    required int timestamp,        // 发生时间戳
  }) = _PlaybackStep;

  factory PlaybackStep.fromJson(Map<String, dynamic> json) => _$PlaybackStepFromJson(json);
}
```

### 4.3 磁带 Payload 实例规范 (JSON Schema)

```json
[
  {
    "type": "INITIAL_STATE",
    "viewModelTag": "system",
    "name": "{\"sp\":{\"user_data\":\"{\\\"id\\\":101,\\\"username\\\":\\\"tester\\\"}\",\"current_language\":\"zh\"},\"secure\":{\"auth_token\":\"bearer_jwt_token_sample\",\"refresh_token\":\"refresh_sample\"}}",
    "timestamp": 1726100000000
  },
  {
    "type": "INTENT",
    "viewModelTag": "SettingsViewModel",
    "name": "SettingsIntent.switchThemeMode(isDark: true)",
    "route": "/settings",
    "timestamp": 1726100002000
  },
  {
    "type": "INTENT",
    "viewModelTag": "DeleteAccountViewModel",
    "name": "DeleteAccountIntent.submitDelete()",
    "route": "/delete_account",
    "timestamp": 1726100005000
  },
  {
    "type": "POP",
    "viewModelTag": "system",
    "name": "POP:DialogRoute",
    "timestamp": 1726100006200
  },
  {
    "type": "POP",
    "viewModelTag": "system",
    "name": "/delete_account",
    "timestamp": 1726100008000
  }
]
```

---

## 5. Clean Architecture 分层架构与核心技术难点实现 (Technical Deep Dives)

### 5.1 难点 1：Clean Architecture 领域与数据层解耦及 `saveTapeDelegate` 控制反转 (IoC)

#### 痛点与架构挑战
`MviPlaybackRecorder` 位于核心底层工具包（`shared/utils/playback/`），如果它直接导入 settings 模块的 `PlaybackTapeRepositoryImpl`，将直接违反 Clean Architecture 的依赖原则（底层核心工具倒置依赖高层业务模块）。

#### 解决方案：控制反转 (IoC) 委托注入
在 `MviPlaybackRecorder` 中定义通用的持久化委托函数，在应用启动入口 [main.dart](../lib/main.dart) 中完成依赖装配：

```dart
// lib/shared/utils/playback/playback_recorder.dart
static Future<void> Function(String tapeKey, List<PlaybackStep> steps, String name, int timestamp)?
saveTapeDelegate;

// 在 lib/main.dart 中集中注入业务仓储：
MviPlaybackRecorder.saveTapeDelegate = (tapeKey, steps, name, timestamp) async {
  final repository = container.read(playbackTapeRepositoryProvider);
  final result = await repository.saveTape(
    tapeKey,
    steps,
    PlaybackTapeMetadata(key: tapeKey, name: name, timestamp: timestamp, steps: steps.length),
  );
  result.fold(
    (failure) => appLogger.e('Failed to save tape from delegate: ${failure.message}'),
    (_) => null,
  );
};
```
该设计确保了底层工具包的极致纯粹与可复用性，同时完全遵从架构依赖规则门禁。

---

### 5.2 难点 2：两级反序列化注册中心（`MviPlaybackRegistry`）与参数解析

在禁用 `dart:mirrors` 的 Flutter AOT 环境下，系统基于正则表达式 `^([a-zA-Z0-9_]+)\.([a-zA-Z0-9_]+)\((.*)\)$` 对序列化字符串进行类名、方法名与参数提取，并分发至各业务模块的静态注册工厂：

```dart
// lib/shared/utils/playback_registry_init.dart
static BaseIntent? parseAndDeserialize(String intentStr) {
  final regex = RegExp(r'^([a-zA-Z0-9_]+)\.([a-zA-Z0-9_]+)\((.*)\)$');
  final match = regex.firstMatch(intentStr.trim());
  if (match == null) return null;

  final className = match.group(1)!;
  final constructorName = match.group(2)!;
  final body = match.group(3)!;

  final args = <String, String>{};
  if (body.isNotEmpty) {
    final pairs = body.split(', ');
    for (var pair in pairs) {
      final parts = pair.split(': ');
      if (parts.length >= 2) {
        args[parts[0].trim()] = parts.sublist(1).join(': ').trim();
      }
    }
  }
  return deserialize(className, constructorName, args);
}
```

---

### 5.3 难点 3：高密封环境状态沙箱（`_cachePreState` / `_applyState`）与 AuthManager 同步

在回放期间，既要使用录制时的用户快照，又绝不能污染宿主真实的会话与存储。系统通过 `try ... finally` 闭包与 `AuthManager` 内存态同步达成完全密封：

```dart
// lib/shared/utils/playback/playback_player.dart
final Map<String, Map<String, dynamic>> prePlaybackState = await _cachePreState();
try {
  // 1. 应用磁带初始状态
  if (initialStateStep != null) {
    await _applyState(jsonDecode(initialStateStep.name) as Map<String, dynamic>);
  }
  // 2. 依次遍历并分发意图与 Pop 动作...
} finally {
  // 3. 无论成功或异常退出，强制 100% 恢复原宿主环境
  await _applyState(prePlaybackState);
  _updateProgress(isPlaying: false);
}
```

其中 `_applySecureAndAuthState` 核心保障了内存中 `authManager` 单例的状态同步：

```dart
if (authToken != null && userData != null) {
  final user = UserModel.fromJson(jsonDecode(userData));
  authManager.login(user); // 关键：通知内存状态机，确保路由守卫不发生拦截
} else {
  authManager.logout();
}
```

---

### 5.4 难点 4：非 ViewModel 路由 Pop 拦截与 `popUntil` 只读探针

针对手势返回、物理返回与关闭弹窗等绕过 ViewModel 的操作，回放端采用只读探针避免二次出栈导致的路由栈撕裂：

```dart
// lib/shared/utils/playback/playback_player.dart
Route<dynamic>? currentTopRoute;
AppNavConfig.navigatorKey.currentState?.popUntil((r) {
  currentTopRoute = r;
  return true; // 返回 true 不执行任何 pop，仅提取栈顶 Route 实例
});

if (isRecordedPopup) {
  // 仅在当前栈顶确实存在未关闭的 PopupRoute 时才执行关闭
  if (currentTopRoute != null && currentTopRoute is! PageRoute) {
    AppNav.back();
  }
} else {
  // 仅在当前栈顶名称与磁带匹配时才退栈
  if (currentTopRoute?.settings.name == name) {
    AppNav.back();
  }
}
```

---

### 5.5 难点 5：模态阻断式对话框（`ConfirmEffect`）在回放态下的自动放行

在 UI 提供者 [confirm_provider_impl.dart](../lib/shared/base/confirm_provider_impl.dart) 中识别当前播放状态：

```dart
class ConfirmProviderImpl extends BaseProvider<ConfirmEffect> {
  @override
  void handleEffect(ConfirmEffect effect) {
    if (MviPlaybackPlayer.instance.progress.isPlaying) {
      // 回放态下直接自动触发“确认”，消除阻塞
      effect.onResult(true);
      return;
    }
    // 正常生产态展示 CommonDialog...
  }
}
```

---

## 6. 典型架构反模式与避坑指南 (Anti-Patterns & Pitfalls)

### 🚫 反模式 1：单一大 Key 存储全量磁带导致冷启动卡顿 (Single Giant Key)
* **错误做法**：将所有磁带的元数据与数百步详细时序数据全部塞入单个 SharedPreferences 键（如 `all_tapes_blob`）。
* **潜在灾难**：随着录制磁带增多，该 JSON 字符串体积可达数兆字节，每次 App 冷启动或进入设置页时反序列化导致严重掉帧卡顿。
* **正确规范**：严格执行两级索引规范（`playback_tapes_list` 仅存目录元数据，单盘磁带独立存放在 `playback_tape_<id>` 中，按需懒加载）。

### 🚫 反模式 2：UI 业务层直接侵入底层存储 (Leaky Abstraction)
* **错误做法**：在 `PlaybackTapeListPage` 或 `PlaybackTapeListViewModel` 中直接调用 `SpUtil.putString` 或 `SpUtil.remove` 增删磁带。
* **潜在灾难**：破坏 Clean Architecture 架构边界，使 ViewModel 产生数据介质强耦合，无法进行无依赖的单元测试与 Mock 验证。
* **正确规范**：通过 `PlaybackTapeRepository` 抽象契约并经由 Domain Use Cases（`GetPlaybackTapesUseCase` 等）进行调度。

### 🚫 反模式 3：回放缺乏容错与超时机制导致死锁 (Unbounded Wait)
* **错误做法**：回放时如果发现目标 ViewModel 未挂载，采用 `while(true) { await sleep(); }` 无限循环等待。
* **潜在灾难**：若前序页面因异常未能正常打开，回放引擎永久死锁并耗尽设备 CPU。
* **正确规范**：采用步长延时与容错跳过机制，若未命中则记录警告日志并进入下一步，保证整体执行的韧性。

---

## 7. 不足与后续演进路线 (Shortcomings & Future Roadmap)

结合当前实践，系统已在 [todo.md](todo.md) 中规划了三大核心优化项：

1. **`Opt-41: MviPlaybackRegistry 宏 / 编译期代码生成自动化与类型安全 AST 校验`**：
   - 摆脱手工维护 `registerPlayback()` 容易遗漏和正则切分的局限，引入 `@MviPlaybackIntent()` 与 Dart Macro 编译期生成机制。
2. **`Opt-42: 跨设备高保真手势坐标注入与多分辨率响应式回放适配`**：
   - 为复杂 Canvas 自绘交互（`SkillsRadarChart` 顶点拖拽、图片缩放）补充归一化相对坐标 $(\frac{x}{W}, \frac{y}{H})$ 与虚拟 `PointerEvent` 注入管道。
3. **`Opt-43: 磁带持久化跨端导出/导入协议与 WebRTC / QR 码免线联调传输`**：
   - 支持将磁带导出为 `.tape.json` 文件并通过系统原生分享面板（`share_plus`）发送给研发；支持局域网 P2P / 动态二维码扫码快速克隆磁带。

---

## 8. 校验策略与测试矩阵 (Verification & Testing Matrix)

本项目针对 MVI 录制与回放功能构建了严密的单元与 Widget 测试防护网：

```bash
# 执行底层引擎核心单元测试
flutter test test/shared/utils/playback_test.dart

# 执行仓储层持久化单元测试
flutter test test/features/settings/data/repositories/playback_tape_repository_impl_test.dart

# 执行展示层 ViewModel 与 UI 交互测试
flutter test test/features/settings/presentation/pages/playback_tape_list/
```

### 测试用例矩阵

| 测试文件 | 覆盖的核心场景 | 期望断言 |
| :--- | :--- | :--- |
| **`playback_test.dart`** | Intent 派发与录制拦截、零反射反序列化、状态沙箱深度隔离与 100% 还原、Route Pop 捕获与防多退。 | 磁带记录精确、SP 彻底恢复、所有核心 Intent 均已注册。 |
| **`playback_tape_repository_impl_test.dart`** | `getTapes` 空列表防御、`saveTape` 步骤与索引双写、`getTapeSteps` 懒加载、`deleteTape` 双向级联清理。 | 返回 `Right`，数据与元数据完全匹配。 |
| **`playback_tape_list_view_model_test.dart`** | `loadTapes` 倒序排列、`deleteTape` 发射 `ConfirmEffect`、确认删除后自愈刷新、`startPlayback` 发射 `PlayTapeEffect`。 | 状态机流转正确，Effect 依次发射且参数无畸变。 |
| **`playback_tape_list_page_test.dart`** | 磁带卡片渲染、时间与步数格式化、点击播放按钮、点击删除按钮、点击卡片查看步骤详情。 | 控件正确命中并触发对应的 Intent 派发。 |

---

## 9. 全量源码索引 (Source Code Directory)

本规范所涉及的全部源码与文档均采用严格的相对路径链接：

* **核心回放与录制引擎**：
  * 录制器：[playback_recorder.dart](../lib/shared/utils/playback/playback_recorder.dart)
  * 回放器：[playback_player.dart](../lib/shared/utils/playback/playback_player.dart)
  * 不可变进度模型：[playback_progress.dart](../lib/shared/utils/playback/playback_progress.dart)
  * 全局统一导出：[playback_manager.dart](../lib/shared/utils/playback_manager.dart)
  * 反序列化注册：[playback_registry_init.dart](../lib/shared/utils/playback_registry_init.dart)
* **Clean Architecture 仓储与展示层 (Settings 模块)**：
  * 领域仓储契约：[playback_tape_repository.dart](../lib/features/settings/domain/repositories/playback_tape_repository.dart)
  * 数据仓储实现：[playback_tape_repository_impl.dart](../lib/features/settings/data/repositories/playback_tape_repository_impl.dart)
  * 步骤数据模型：[playback_step.dart](../lib/features/settings/data/models/playback_step.dart)
  * 元数据模型：[playback_tape_metadata.dart](../lib/features/settings/data/models/playback_tape_metadata.dart)
  * 视图模型：[playback_tape_list_view_model.dart](../lib/features/settings/presentation/pages/playback_tape_list/playback_tape_list_view_model.dart)
  * 磁带列表界面：[playback_tape_list_page.dart](../lib/features/settings/presentation/pages/playback_tape_list/playback_tape_list_page.dart)
  * Riverpod 依赖注塑：[playback_provider.dart](../lib/features/settings/presentation/provider/playback_provider.dart)
* **关联技术与规划文档**：
  * 底层架构与难点设计：[intent_effect_playback_design.md](intent_effect_playback_design.md)
  * 演进任务路线图：[todo.md](todo.md)
