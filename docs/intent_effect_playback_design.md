# Intent & Effect 录制与回放系统 - 详细设计与实现文档

本文档详细阐述了 **ListenPortfolio** 项目中 **Intent & Effect 本地录制与回放系统** 的架构设计、核心技术实现方案、沙箱机制、返回拦截逻辑以及自动化测试验证策略。

---

## 1. 核心概念与系统架构

在 MVI (Model-View-Intent) 架构中，UI 的更新和跳转完全由 `Intent`（用户意图）和 `Effect`（副作用）所驱动。本系统通过拦截和分发 these 事件，在不需要任何外部网络和数据库依赖的条件下，实现了用户操作的“录制”与“高保真回放”。

### 1.1 核心组件交互图

下面展示了录制和回放期间，各个组件与状态存储、路由、ViewModel 之间的协作关系：

```mermaid
flowchart TD
    subgraph 录制阶段 (Recording Phase)
        UI[Widget View] -->|1. 发送 Intent| VM[BaseViewModel]
        VM -->|2. 拦截并分发| Observer[MviPlaybackObserver]
        Observer -->|3. 记录步骤| Recorder[MviPlaybackRecorder]
        Nav[AppNav / NavigatorObserver] -->|4. 拦截返回 (Pop) 路由| Recorder
        Recorder -->|5. 快照并存储| SP[(SpUtil / SharedPreferences)]
    end

    subgraph 回放阶段 (Playback Phase)
        SP -->|1. 加载磁带 JSON| Player[MviPlaybackPlayer]
        Player -->|2. 应用初始快照| Sandbox[State Sandbox]
        Player -->|3. 循环遍历步骤| Steps[Playback Steps]
        Steps -->|4. 隐式等待挂载| VMActive{ViewModel 活跃?}
        VMActive -->|是| VMReplay[ViewModel.handleIntent]
        VMActive -->|否 (轮询等待)| VMActive
        Steps -->|5. 重现返回 (Pop) 动作| AppNavBack[AppNav.back]
    end
```

---

## 2. 录像磁带格式设计 (JSON Schema)

每个录像文件（又称“磁带”）在持久化介质中均以单个 JSON 数组保存，包含了完整的环境快照以及时序步骤。

### 2.1 步骤类型定义 (`PlaybackStep`)
* **`initState`**：表示环境初始状态快照。在数组第一项，包含 Shared Preferences 和 Secure Storage 的初始键值对。
* **`intent`**：用户交互产生的具体意图（如输入文字、点击按钮）。
* **`effect`**：ViewModel 内部触发的 UI 副作用（如弹出通知，仅用于日志追踪，不驱动行为）。
* **`pop`**：用户执行了返回导航操作（包括物理返回键、手势侧滑、AppBar 返回按钮、关闭弹窗）。

### 2.2 JSON 磁带实例

```json
[
  {
    "type": "initState",
    "viewModelTag": "system",
    "name": "{\"sp\":{\"userData\":\"{\\\"name\\\":\\\"Test User\\\"}\"},\"secure\":{\"auth_token\":\"mock_token\"}}",
    "timestamp": 1719485000000
  },
  {
    "type": "intent",
    "viewModelTag": "LoginViewModel",
    "name": "LoginIntent.inputAccount(account: test@example.com)",
    "route": "/login_view",
    "timestamp": 1719485002000
  },
  {
    "type": "pop",
    "viewModelTag": "system",
    "name": "/signup_view",
    "timestamp": 1719485005000
  }
]
```

---

## 3. 核心机制与关键技术实现

### 3.1 状态沙箱隔离与还原 (State Sandboxing)

为了使回放能够在**零残留、不污染日常使用数据**的干净沙箱环境中运行，系统实现了完美的数据备份与恢复机制：

1. **缓存当前态**：在 `MviPlaybackPlayer.play` 启动时，调用 `_cachePreState()` 从 `SpUtil` 和 `SecureStorageUtil` 提取当前用户的所有凭证与应用配置并存于内存中。
2. **应用初始态**：将磁带中的 `initState` 提取出来，清空非磁带外的本地存储，并写入录像初始值。
3. **内存登录态同步 (AuthManager)**：
   * 很多受保护页面受到路由守卫拦截。若快照内存在 `authToken` 和 `userData`，系统在应用本地存储后，必须同步调用 `authManager.login(user)`，实时通知内存状态，否则随后的初始化路由重置会被拦截跳转至 `/login` 导致回放失败。
   * 若快照中未登录，则必须执行 `authManager.logout()`。
4. **强制回滚还原**：整个回放用 `try-catch-finally` 保证，无论回放是成功结束还是异常中断，均在 `finally` 块中将第一步缓存的 `prePlaybackState` 重新应用，无缝恢复用户的日常会话。

### 3.2 路由返回拦截 (Pop Interception)

传统的路由跳转由 `Effect`（如 `NavigationEffect`）发出并能够被拦截，然而**页面返回（物理返回键、滑动手势、AppBar Back）直接绕过了 ViewModel 层**。

为了拦截并重现“返回”动作，我们引入了以下机制：
1. **录制捕获**：在 `_AppNavObserver.didPop` 中绑定 `AppNav.onRoutePopped` 钩子。录制中一旦检测到 `PageRoute` 或 `PopupRoute` 被 Pop，立刻向磁带追加一条类型为 `PlaybackStep.pop` 的步骤。
2. **分类型回放**：
   * **普通页面返回**：回放时，若磁带为 Page 的 Pop，调用 `AppNav.back()` 执行真实的返回动画。
   * **弹窗/对话框返回**：若记录格式为 `POP:DialogRoute`，回放时先利用 `navigatorKey` 检查当前最顶层的 Route 是否为非 PageRoute（表示弹窗尚未关闭）。若是，则调用 `AppNav.back()` 将其关闭；若在回放时该弹窗已被其他操作正常关闭，则自动忽略跳过，避免多退页面。

### 3.3 视图模型匹配与容错机制 (VM Resolution & Fault Tolerance)

在回放意图时，由于路由切换伴随着异步的页面过渡动画，系统在派发前必须确认目标视图模型（ViewModel）是否已经就绪。

目前的实现策略倾向于**直接断言与安全跳过**：
```dart
final vm = ActiveViewModels.get(viewModelTag);
if (vm == null) {
  appLogger.w('[$tag] Active ViewModel not found: $viewModelTag, skipping step...');
} else {
  final intent = MviPlaybackRegistry.parseAndDeserialize(name);
  if (intent != null) {
    vm.handleIntent(intent);
  }
}
```
结合统一的 `stepDelay`（默认 1.2s）延时机制，这既保证了 UI 过渡动画能从容执行完毕，又避免了死锁轮询，遇到脏记录时能自动跳过并执行下一帧。

### 3.4 确认对话框自动确认 (ConfirmEffect Bypass)

在执行删除数据、退出登录等操作时，ViewModel 会发送一个 `ConfirmEffect` 来拉起 `CommonDialog.showConfirm` 对话框，该对话框是**阻塞式**的（必须点击“是/否”触发 `onResult` 异步回调）。

为防止回放卡死在弹窗确认步骤：
```dart
class ConfirmProviderImpl extends BaseProvider<ConfirmEffect> {
  @override
  void handleEffect(ConfirmEffect effect) {
    if (MviPlaybackPlayer.instance.progress.isPlaying) {
      // 回放中直接自动模拟点击“确认”，不再展示 UI 阻塞进程
      effect.onResult(true);
      return;
    }
    // 正常显示确认对话框...
  }
}
```

### 3.5 单向数据流状态拷贝 (`PlaybackProgress.copyWith`)

为确保回放进度监听器的代码整洁度与安全性，`PlaybackProgress` 采用了**不可变状态**设计：
* 类属性均声明为 `final`，且仅暴露一个 `copyWith` 用于局部状态流转。
* `MviPlaybackPlayer` 不再声明散乱的状态变量，而是聚合为单个私有 `_progress` 状态实体，并通过统一的方法触发更新：
```dart
  void _updateProgress({
    bool? isPlaying,
    PlaybackStatus? status,
    int? currentStepIndex,
    int? totalSteps,
    String? currentStepName,
  }) {
    _progress = _progress.copyWith(
      isPlaying: isPlaying,
      status: status,
      currentStepIndex: currentStepIndex,
      totalSteps: totalSteps,
      currentStepName: currentStepName,
    );
    onProgressChanged?.call(_progress);
  }
```

---

## 4. 文件与类职责定义

| 库 / 模块 | 文件路径 | 类 / 成员 | 主要职责 |
| :--- | :--- | :--- | :--- |
| **ListenCore** | [base_view_model.dart](../../ListenCore/lib/base/base_view_model.dart) | `MviPlaybackObserver` <br> `ActiveViewModels` | 注册全局 Hook 钩子；在运行时监听所有挂载的视图模型及其中派发的 Intent 与 Effect。 |
| **ListenCore** | [app_nav.dart](../../ListenCore/lib/route/app_nav.dart) | `_AppNavObserver` | 劫持 Navigator 的 didPop 回调并提供 `onRoutePopped` 静态钩子。 |
| **ListenPortfolio** | [playback_manager.dart](../lib/shared/utils/playback_manager.dart) | `MviPlaybackRecorder` <br> `MviPlaybackPlayer` | **录制器**：捕获初始快照、时序步骤并落盘。<br>**回放器**：管理回放进度、操作沙箱、还原态并依次演播。 |
| **ListenPortfolio** | [playback_registry_init.dart](../lib/shared/utils/playback_registry_init.dart) | `MviPlaybackRegistry` | 因禁用反射，用于手写或自动生成注册表，反序列化意图字符串。 |
| **ListenPortfolio** | [confirm_provider_impl.dart](../lib/shared/base/confirm_provider_impl.dart) | `ConfirmProviderImpl` | 对话框效果的逻辑分发，回放态下负责自动旁路放行确认。 |

---

## 5. 校验与验证机制

### 5.1 自动化单元测试

我们在 [playback_test.dart](../test/shared/utils/playback_test.dart) 中实现了覆盖所有上述关键技术的自动化测试用例，运行命令为：
```bash
flutter test test/shared/utils/playback_test.dart
```

该测试覆盖了以下行为：
1. **基本分发流**：验证 Intent 能被录制并正确反序列化回分发给 ViewModel。
2. **沙箱恢复性**：验证在录制前 mock 初始化状态，回放时状态应用正确，回放结束后本地 Shared Preferences 彻底恢复到回放前的原态。
3. **返回拦截 (Pop)**：使用伪造的 `PageRoute` 与非 Page 的 `PopupRoute` (如 Dialog) 验证录制器能精确记录对应的 Pop 数据且回放器能安全执行。
## 6. 技术难点与解决方案 (Technical Challenges & Solutions)

### 6.1 零反射依赖环境下的反序列化 (Reflection-less Deserialization)
* **难点**：Flutter 禁用了 `dart:mirrors` 以减小 AOT 编译的产物体积，导致在运行期无法通过字符串反射实例化 Intent 对象，这对读取 JSON 字符串进行重现造成了极大障碍。
* **解决方案**：引入了手动（或宏辅助）注册表 `MviPlaybackRegistry`。所有 Intent 在定义时必须静态注册 `parseAndDeserialize` 路由，借助正则匹配参数并显式调用构造器来恢复对象。

### 6.2 脏状态残留引发的回放崩溃
* **难点**：如果回放进行到一半应用崩溃或被强杀，再次打开时可能会残留假用户数据（如处于“录制版”的登录态），导致正常业务不可用。
* **解决方案**：采用沙箱模型（State Sandboxing），在 `play` 启动时首先执行 `_cachePreState()` 深度拷贝全部持久化配置（SpUtil & SecureStorage）。使用 `try-catch-finally` 闭包确保在任何退出路径下都执行 `_applyState(prePlaybackState)`，实现了完全幂等的环境重置。

## 7. 设计亮点 (Implementation Highlights)

1. **统一拦截点**：不需要在每个按钮或交互上埋点录像，而是监听 `BaseViewModel` 处理的所有 `Intent` 和 `Effect`，使得任何新增的业务逻辑（只要符合 MVI）均能自动获得零代码录制能力。
2. **阻断弹窗自动消除**：回放中如果遇到 `ConfirmEffect` 等阻塞式行为，系统在 Provider 层直接识别当前 `isPlaying` 态，并直接派发确认事件 (`effect.onResult(true)`)，实现回放“无缝快进”。

## 8. 设计思路 (Design Rationale)

* **纯本地化无侵入测试**：传统的端到端测试（如 Appium）需要复杂的设备环境配置和跨进程通信。该模块将录制与回放能力完全内置于 Flutter 引擎层之上，在不需要真实服务器的条件下利用 Mock Repository，可以让产品经理和 QA 直接在手机上录制 Bug 路径，并以字符串或 JSON 文件的形式发送给研发一键复现。不仅保障了复现的高保真，还彻底消除了运行环境差异导致的“在我机器上没问题”的扯皮。
