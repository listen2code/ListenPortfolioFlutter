# Intent & Effect 录制与回放系统 - 规格定义与实现方案

> [!NOTE]
> 本系统已完成研发落地。关于具体的架构组件、时序返回劫持、沙箱保护机制、对话框旁路机制及单元测试详情，请阅读 [Intent & Effect 录制与回放系统 - 详细设计与实现文档](intent_effect_playback_design.md)。

本文档详细定义了 **ListenPortfolio** 项目中针对 MVI 架构设计的 **Intent & Effect 本地录制与回放系统**（即本地操作录像机）。本系统专注于在本地（SharedPreferences）记录用户的操作路径与副作用序列，用于**零网络依赖的自动化回归测试**和**线上故障路径还原**，不涉及云端同步。

---

## 1. 核心概念与工作原理

在我们的 MVI 架构中，UI 的变化是由 `Intent`（意图）驱动的，而 UI 的跳转或弹窗反馈是由 `Effect`（副作用）控制的。因此，**记录了 Intent 与 Effect 的时序队列，就等于录制了用户的“操作录像”**。

```mermaid
flowchart TD
    subgraph 录制模式 (Record Mode)
        User[用户操作] -->|发送| Intent[BaseIntent]
        Intent -->|拦截并序列化| Recorder[IntentRecorder]
        Recorder -->|持久化写入| SP[(SharedPreferences)]
        ViewModel[ViewModel] -->|触发| Effect[BaseEffect]
        Effect -->|拦截并序列化| Recorder
    end

    subgraph 回放模式 (Replay Mode / Test)
        SP -->|读取 JSON 序列| Player[IntentPlayer]
        Player -->|依次分发| ViewModel
        ViewModel -->|更新 UI / 触发路由| UI[Widget View]
    end
```

---

## 2. 实用应用场景

### 2.1 零网络依赖的自动化回归测试 (Hermetic Test Playback)
* **痛点**：传统的自动化集成测试需要编写大量繁琐的 `tester.tap()`、`tester.enterText()` 等步骤，且高度依赖真实的后台 API 响应，一旦接口变动或网络延迟，测试就会失败（Flaky Test）。
* **解决方案**：我们在真机上操作一次，系统自动将所有 `Intent`（如 `LoginIntent.submit`、`SignUpIntent.input`）序列化后保存为本地 JSON 磁带。在集成测试中，直接读取该 JSON 并以毫秒级速度重新向 `ViewModel` 分发这些 `Intent`，完成自动化回放，期间所有的网络请求通过 `MockClient` 截获，保证测试的速度与稳定性。

### 2.2 线上崩溃操作路径还原 (Crash Scenario Recovery)
* **痛点**：用户反馈 App 崩溃了，但仅凭一个崩溃堆栈（Stack Trace）很难知道用户是在**进行了什么复杂的前置操作组合**之后才触发的。
* **解决方案**：在 App 内部维护一个滑动窗口队列（如只保留最近 10 次的 `Intent` 和 `Effect`）。一旦发生未捕获异常（Crash），`CrashManager` 在落盘崩溃日志的同时，将这个操作路径队列序列化保存。这样，我们在本地排查时就能一眼看清用户的操作轨迹（例如：*打开侧边栏 ➡️ 点击设置 ➡️ 切换语言 ➡️ 立即点击注销账号 ➡️ 发生崩溃*）。

---

## 3. 方案设计与实现边界

### 3.1 实现边界
1. **纯本地媒介**：使用 `SharedPreferences` 作为持久化载体，记录的“磁带”可导出为 JSON 格式文本，**不进行任何云端同步**，避免隐私泄露与服务端存储开销。
2. **状态与环境隔离**：回放时，只回放 `Intent`（输入、点击等操作），网络层必须强制切换至 `mock` 环境或使用模拟的 Repository，防止回放测试时向真实服务器写入脏数据。

### 3.2 数据结构设计 (JSON Payload)

每一次操作记录包含类型、名称和携带的参数负载：

```json
[
  {
    "timestamp": 1719485000000,
    "step": 1,
    "type": "INTENT",
    "targetPage": "LoginPage",
    "name": "LoginIntent.inputAccount",
    "payload": { "account": "listen2code@gmail.com" }
  },
  {
    "timestamp": 1719485002000,
    "step": 2,
    "type": "INTENT",
    "targetPage": "LoginPage",
    "name": "LoginIntent.submit",
    "payload": {}
  },
  {
    "timestamp": 1719485003000,
    "step": 3,
    "type": "EFFECT",
    "targetPage": "LoginPage",
    "name": "LoginEffect.navigateToHome",
    "payload": {}
  }
]
```

---

## 4. Flutter 客户端技术实现

### 4.1 拦截器与录制器设计

通过在 `BaseViewModel` 层的 `sendIntent` 和 `emitEffect` 中嵌入 AOP（面向切面）或基础基类钩子，实现无侵入录制：

```dart
abstract class BaseViewModel<I extends BaseIntent, S extends BaseState, E extends BaseEffect> extends StateNotifier<S> {
  
  // 意图发送钩子
  void sendIntent(I intent) {
    if (PlaybackConfig.isRecording) {
      IntentRecorder.instance.recordIntent(intent);
    }
    handleIntent(intent); // 执行原本的业务逻辑
  }

  // 副作用发送钩子
  void emitEffect(E effect) {
    if (PlaybackConfig.isRecording) {
      IntentRecorder.instance.recordEffect(effect);
    }
    // 发送给 UI 层监听
  }
}
```

### 4.2 回放驱动器与状态监听器设计 (`MviPlaybackPlayer`)

回放器不仅负责执行录制好的时序步骤，还通过 `PlaybackProgress` 将回放进度、当前步骤名称及整体播放状态通知给外部监听器（如 Log Overlay 面板）。

```dart
/// Progress state details for MVI playback.
class PlaybackProgress {
  final bool isPlaying;
  final PlaybackStatus status;
  final int currentStepIndex;
  final int totalSteps;
  final String currentStepName;

  const PlaybackProgress({
    required this.isPlaying,
    required this.status,
    required this.currentStepIndex,
    required this.totalSteps,
    required this.currentStepName,
  });
}

class MviPlaybackPlayer {
  static final MviPlaybackPlayer instance = MviPlaybackPlayer._();

  /// 进度改变回调函数，携带 progress 参数以供直接消费
  void Function(PlaybackProgress progress)? onProgressChanged;

  Future<void> play(String tapeKey) async {
    // 依次执行录像中的时序步骤，并在每步更新时触发回调：
    // onProgressChanged?.call(progress);
  }
}
```

### 4.3 仓储层设计 (`PlaybackTapeRepository`)

为了解耦 ViewModel、Recorder 与底层的持久化介质（SharedPreferences），所有磁带数据的读取与写入统一抽象为了 `PlaybackTapeRepository` 接口，并引入了强类型模型 `PlaybackTapeMetadata` 取代原本松散的 Map 数据：

```dart
class PlaybackTapeMetadata {
  final String key;
  final String name;
  final int timestamp;
  final int steps;
  
  // 提供了 toJson/fromJson 序列化转换
}

abstract class PlaybackTapeRepository {
  Future<List<PlaybackTapeMetadata>> getTapes();
  Future<void> saveTapes(List<PlaybackTapeMetadata> tapes);
  Future<List<PlaybackStep>> getTapeSteps(String tapeKey);
  Future<void> saveTape(String tapeKey, List<PlaybackStep> steps, PlaybackTapeMetadata metadata);
  Future<void> deleteTape(String tapeKey);
}
```

---

## 5. 校验与验证计划

* **集成测试验证**：
  1. 运行 App 并在本地模拟登录和退出操作，生成 `SharedPreferences` 中的录制数据。
  2. 启动集成测试，测试脚本直接通过 `IntentPlayer` 加载此录像数据。
  3. **验证标准**：App 在测试中能够自主完成页面跳转、文本框填充，且最终停留的页面与录制时一致。
* **面试官演示**：
  在 App 中内置一个“录像机测试”页面，允许一键开启录制、点击几个页面后点击“停止”，然后再点击“回放”，能亲眼看见 App 的 UI 像电影回放一样自动点击并跳转，以此作为直观的架构亮点展示。

---

## 6. 具体实施计划 (Implementation Details)

### 6.1 拟进行的修改文件及明细

#### 模块 1: `ListenCore` (共享核心库)
* **[修改] [base_view_model.dart](../../ListenCore/lib/base/base_view_model.dart)**
  * 定义 `MviPlaybackObserver` 类，提供全局静态的事件派发钩子（`onIntentDispatched` / `onEffectEmitted`）。
  * 定义 `ActiveViewModels` 内存状态管理器，用于在运行时动态查询处于活跃挂载状态的 ViewModel 实例。
  * 在 `BaseViewModel.onInit` 和 `_performRealDispose` 中接入自动注册和注销逻辑。
  * 在 `dispatch`（拦截 Intent 的主方法）以及 `emitEffect` 中触发对应的观察者回调。

#### 模块 2: `ListenPortfolioFlutter` (主应用)
* **[落地] [lib/shared/utils/playback_manager.dart](../lib/shared/utils/playback_manager.dart)**
  * 实现录制器 `MviPlaybackRecorder`：控制录制的起止，处理时序日志格式化并落盘 `SharedPreferences`。自动根据首个动作生成 “页面名 -> 意图名” 默认标题。
  * 实现反序列化映射器 `MviPlaybackRegistry`：由于 Flutter 禁用反射，设计纯静态的 switch-case 反序列化方案支持主要用户页面操作对象。
  * 实现回放器 `MviPlaybackPlayer`：循环遍历 JSON 磁带数据，触发对应 ViewModel 上的 `sendIntent` 实现自动演播。
* **[落地] [lib/shared/utils/playback_registry_init.dart](../lib/shared/utils/playback_registry_init.dart)**
  * 注册各页面意图反序列化器与执行器。
* **[修改] [lib/features/settings/presentation/pages/settings_page.dart](../lib/features/settings/presentation/pages/settings_page.dart)**
  * 在设置列表页中，添加跳转至 `PlaybackTapeListPage` 的入口。
* **[落地] [lib/features/settings/presentation/pages/playback_tape_list/playback_tape_list_page.dart](../lib/features/settings/presentation/pages/playback_tape_list/playback_tape_list_page.dart)**
  * 展示 `SharedPreferences` 中保存的所有录像磁带列表，点击可查看时序步骤详情，并支持“执行回放 (Play)”与“删除 (Delete)”操作。
* **[落地] [test/shared/utils/playback_test.dart](../test/shared/utils/playback_test.dart)**
  * 编写单元测试用例，全链条验证 Intent 的抓取、写入、解析和分发模拟执行。

---

## 7. 架构设计亮点 (Implementation Highlights)

1. **零侵入式的录制钩子**：借助 `ListenCore` 提供的基类底座，我们仅在 `BaseViewModel` 统一收口的分发管道 `dispatch` 与 `emitEffect` 处注入全局监听观察者，即可捕获任意页面的交互，完全无需在业务 UI 层进行繁琐的埋点。
2. **安全隔离的回放沙箱**：由于是脱离真实服务器环境的 Mock 回放，回放器在启动时会将现存用户身份数据和环境快照全部缓存，结束后利用 `finally` 代码块绝对复原，保证了任何故障的回放绝不污染使用者的真实账号与持久层数据。

## 8. 设计思路 (Design Rationale)

* **将“录像”内化于架构中**：之所以设计本系统，是为了论证 MVI（Model-View-Intent）单向数据流最核心的架构红利——“确定性输入，必得确定性输出”。我们避开了依赖复杂 UI 视图树层级查找、坐标模拟点击等高难度端到端自动化测试手段，而是直接下钻至逻辑中枢分发 Intent 指令。这不仅避开了跨平台 UI 解析难题，更把回放与防御验证的成本降低到了极致。
