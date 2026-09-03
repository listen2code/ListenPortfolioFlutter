# 强类型路由与 Deep Link 架构设计及决策文档

## 1. 业务背景
在 ListenPortfolio 中，应用需要支持通过统一的外部 Deep Link Scheme（如 `listenportfolio://`）直接唤起并下钻到应用内的指定页面（如 `SettingsPage`，并按需执行特定行为，如开启新版本检测）。为了保障类型安全、避免硬编码的字符串参数转换异常，并实现底座 `ListenCore` 与宿主 `ListenPortfolioFlutter` 的解耦，我们设计并落地了此强类型路由与 Deep Link 解析体系。

---

## 2. 核心架构设计

### 2.1 依赖倒置与解耦 (Business-Agnostic Core)
为了保持底座 `ListenCore` 纯粹的业务中立性，我们没有在底座写死任何特定业务的路由参数类或 URI schemes，而是采用了**动态 Scheme 注册**与**转换器委托注册（Converter Delegate）**机制。

* **Scheme 动态注册**：宿主应用在初始化 `CoreConfig` 时，通过 `schemes` 列表指定支持的自定义协议（如 `listenportfolio`、`myapp`）。
* **转换器委托注册**：宿主应用将具体的 `SignUpArguments`、`SettingsArguments`、`CrashLogListArguments` 实体类定义在宿主侧，并向底座注册反序列化工厂函数 `AppNav.registerArgumentConverter`。

### 2.2 流程时序图
当外部唤起链接拉起应用时，完整路径如下：

```mermaid
sequenceDiagram
    participant OS as 操作系统 (Android/iOS)
    participant AppLinks as app_links (插件底层)
    participant Mgr as DeepLinkManager (ListenCore)
    participant Bus as EventBus (ListenCore)
    participant Core as AppNav (ListenCore)
    participant Host as 宿主应用 (AppInitializer)
    participant Home as 首页 (HomeViewModel)
    participant Page as 目标页面 (ViewModel)

    Note over Host: 1. 注册 Scheme、Argument 转换器与初始化时钟
    Host->>Core: AppNavConfig.register(schemes: ['listen'])
    Host->>Core: AppNav.registerArgumentConverter<SettingsArguments>(...)
    Note over Host: 等待异步服务及本地状态载入完毕...
    Host->>Mgr: DeepLinkManager.instance.init()

    Note over OS, Mgr: 2. 外部 Deep Link 唤起 (冷启动)
    OS->>AppLinks: 传入 URI 'listen://settings?check_update=true'
    AppLinks->>Mgr: getInitialLink() 发现冷启动链接
    Mgr->>Bus: fire(CommonEvent<Uri>(deepLinkEventKey, sticky: true, autoClear: true))
    Bus->>Bus: 缓存在 _stickyMap 中

    Note over Host, Home: 3. 正常启动流程运行 (进入首页)
    Host->>Host: 启动渲染 /splash 页，2秒后跳转至 /home 页
    Home->>Home: HomeViewModel 载入就绪并通过 subscribeEvent 订阅
    Home->>Bus: subscribeEvent(sticky: true)
    Bus-->>Home: 立即推送缓存的 deepLinkEvent
    Bus->>Bus: autoClear 自动清除 _stickyMap 中的缓存
    Home->>Core: AppNav.to('listen://settings?check_update=true') (压入栈顶)
    Core->>Core: _stripScheme() -> '/settings?check_update=true'
    Core->>Core: _resolveRoute() -> 提取路径与 Query Map
    Core->>Host: 匹配并渲染加载 SettingsPage
    
    Page->>Core: 4. ViewModel 启动获取强类型参数
    Page->>Core: AppNav.getArgs<SettingsArguments>()
    Core->>Core: 匹配转换器工厂还原为 SettingsArguments 实例
    Core-->>Page: 返回 SettingsArguments(checkUpdate: true)
```

---

## 3. 技术方案设计与实现

### 3.1 协议头裁剪与统一解析 (`AppNav`)
底座 `_stripScheme` 方法不再硬编码任何 Scheme，而是采用循环匹配：
```dart
  static String _stripScheme(String target) {
    var path = target;
    for (final scheme in AppNavConfig.schemes) {
      final prefix = '$scheme://';
      if (path.startsWith(prefix)) {
        path = path.substring(prefix.length);
        if (!path.startsWith('/')) {
          path = '/$path';
        }
        break;
      }
    }
    return path;
  }
```

### 3.2 转换器注册与类型安全获取
宿主应用自定义强类型类，并在初始化时通过工厂方法反序列化：
```dart
class SettingsArguments {
  final bool checkUpdate;
  const SettingsArguments({this.checkUpdate = false});

  factory SettingsArguments.fromMap(Map<String, dynamic> map) {
    final val = map['check_update'] ?? map['checkUpdate'];
    return SettingsArguments(checkUpdate: val == 'true' || val == true);
  }
}
```

---

## 4. 架构决策记录：原生 Deep Link 与 `app_links` 的对比与权衡

在开发过程中，我们对**直接使用原生默认 Deep Link** 和 **集成第三方 `app_links` 进行流分发**进行了深度权衡：

### 4.1 权衡对比
1. **原生默认 Deep Link**：
   * **运行原理**：系统收到 Activity 意图后，直接通过 Flutter 引擎通知 `MaterialApp` 对该 URI 执行 `Navigator.push`。
   * **缺陷（冷启动依赖崩溃漏洞）**：冷启动时，异步初始化流程（如 `SpUtil.init()`）尚未执行完毕，原生层便已经强行 Push 并构建页面。ViewModel 访问尚未就绪的依赖会导致运行时空指针崩溃。
2. **`app_links` 插件**：
   * **运行原理**：禁用 Flutter 原生的自动路由。链接被捕获为 Dart 层 Stream，由我们在初始化彻底完成、第一帧渲染就绪后，手动调起 `AppNav.to` 执行跳转。
   * **优势**：完美控制跳转时钟，规避冷启动依赖加载不同步的问题，并可在跳转前在 Dart 层轻松进行登录态鉴权拦截。

### 4.2 决策演进与最终落地
经过深度评估，为了消除冷启动时异步初始化未就绪导致的安全隐患，我们已于 **2026-07-10** 决定**正式落地 `app_links` 方案**作为生产环境的默认配置。

具体落地细节：
1. **禁用原生路由分发**：在 `AndroidManifest.xml`（Android）与 `Info.plist`（iOS）中配置禁用原生自动拦截。
2. **时序控制（时钟对齐）**：在 `AppInitializer.init()` 方法 of 宿主应用的最后一行开启 `DeepLinkManager.init()`，确保冷启动下依赖 100% 装载完毕后再触发跳转。
3. **底座共通化**：将 `DeepLinkManager` 写入底座 `ListenCore`，通过暴露 `onLinkReceived` 面向切面的 Hook 维持了业务解耦，并且实现了冷热启动逻辑的高度统一。

---

## 5. 路由重用、防冲突与双重弹窗规避设计 (Route Re-entry & Issue Prevention)

在深链接频繁或重复跳转时，应用会面临路由堆叠、Riverpod Provider 被重用及 UI 监听器并发冲突等技术挑战。为此，我们落地了以下底层防护逻辑：

### 5.1 相同路由去重与跳转策略 (`replaceIfExists`)
当用户已经处于目标页面（如 `/settings`）且再次触发相同的跳转命令时，`AppNav.to` 支持两种路由再入策略，可通过参数自主选择：
* **直接返回（默认行为）**：如果 target 路由已是当前路由且未指定额外动作，直接返回不执行任何跳转，保障性能最佳（避免动画抖动与重绘）。
* **替换模式（`replaceIfExists = true`）**：在 `adb` 深链接等需要传参并刷新当前页面内容时，调用 `pushReplacement` 重建路由以保证新的 arguments（如 `check_update=true`）被完全加载。

### 5.2 过渡期双重弹窗与 MVI 单订阅绑定（Single UI Binder）
当使用 `pushReplacement` 替换当前路由时，新页面插入和老页面销毁存在约 300ms 的动画过渡重叠。由于新老页面短时间内共存，Riverpod 会直接复用仍被引用的 ViewModel 实例，老页面若依然监听此 ViewModel 的 `effectStream`，会导致同一个异步副作用（如 `checkUpdates` 成功后派发的 `ConfirmEffect`）同时在两个页面触发，从而弹出两次确认框。

针对这一问题，我们通过双重同步拦截确保单一订阅者模式（Single UI Binder）：
1. **ViewModel 端同步解绑（主要保护）**：在 `BaseViewModel.onBindEffect` 中增加排他性解绑：一旦有新视图（新页面）执行绑定，立即同步取消（`cancel`）前一个 UI 的 `StreamSubscription` 句柄，杜绝 ViewModel 复用期间的老页面残留监听。
2. **View 级防御性 Pop 拦截（辅助保护）**：在 `BaseLifeCyclePage` 层的路由观察代理中注册 `onPop`。当 `pop` 或 `pushReplacement` 动作发出时，老页面通过 Navigator 收到 `didPop` 回调瞬间同步注销对 ViewModel `effectStream` 的所有监听，不依赖动画结束后才执行的 `dispose()`。

通过这套机制，框架成功保证了即使在多路由瞬时重叠、Provider 频繁重用的高压场景下，MVI 副作用也始终遵循单向、单发与高安全的通道分发原则。

---

## 6. 系统返回手势与 PopScope 统一管理设计 (Unified Back Gesture & PopScope Management)

随着 Android 13/14+ 预测性返回手势（Predictive Back）的引入，以及对页面返回生命周期管理的整洁性要求，我们将系统返回手势的拦截与分发逻辑从 UI 布局骨架层（`BaseScaffoldPage`）彻底移出，在生命周期底座层（`BaseLifeCyclePage`）和 `CommonWebView` 中进行了统一封装与演进治理。

### 6.1 核心设计原则

1. **布局与手势控制解耦**：
   * `BaseScaffoldPage` 不再包含任何 `PopScope` 或返回拦截的逻辑，保持其作为布局脚手架的纯粹职责。
   * `BaseLifeCyclePage` 作为包裹每个独立页面的生命周期组件，统一接管 `PopScope` 返回手势监听。
2. **多标签页共存（`IndexedStack`）状态治理**：
   * 在使用多子页共存的 `IndexedStack` 场景下，处于后台的非激活 Tab 仍保留在 Widget 树中，其 `PopScope` 会误拦截全局侧滑返回。
   * 我们引入了 `widget.active` 过滤校验：当页面未被激活时，`PopScope.canPop` 强置为 `true` 予以直接放行；在 `onPopInvokedWithResult` 中，若 `!widget.active` 则直接 return，完全避免了后台刷新页面对全局返回手势的无意劫持。
3. **加载态手势拦截与异步请求注销优先级**：
   * 当激活页面存在内部加载态（`_isInternalLoading.value == true`）时，系统返回键会被直接拦截（`canPop = false`）。
   * 拦截发生后，框架通过精简、零冗余的逻辑优先执行后台异步请求的取消（`_viewModel?.cancelRequests("onBackInvoked")`），并发送副作用重置页面加载状态，实现“首击取消加载并中断请求”。
4. **多标签页回退与双击退出应用（`HomePage`）**：
   * 针对应用的根页面（`HomePage`），系统手势始终被拦截（`canPop = false`）。
   * 当用户从二级标签页返回时，侧滑手势自动导向第一页（`Overview` 标签）。
   * 当处于 `Overview` 页面时，侧滑手势将触发 2 秒内的双击检测：第一击显示国际化 Toast 提示（如“再按一次退出应用”）， 2 秒内再次点击则调用 `SystemNavigator.pop()` 退出，实现流畅的原生回退体验，避免误触退出。

### 6.2 WebView 动态返回手势与自定义 Scheme 拦截

针对内置 H5 页面的拦截交互，`CommonWebView` 设计了更加精细化的手势感知与分发链条：

1. **动态 `canPop` 预测返回**：
   * 为了支持 Android 13+ 系统原生预测性返回动画，WebView 的 `PopScope.canPop` 不再一刀切硬编码为 `false`，而是声明为动态值：`canPop: !widget.enableBackHistory || !_canGoBack`。
   * 页面通过注册 `onUpdateVisitedHistory` 和 `onLoadStop` 监听，实时向 Native 层查询当前 WebView 历史记录中是否还有上一页可退（通过 `controller.canGoBack()`），并动态更新 `_canGoBack` 状态。
   * 当有历史可退时，`canPop` 为 `false`，手势拦截触发并调用 `_webViewController.goBack()`；当回退至首个网页页面时，`canPop` 自动变回 `true`，用户再次侧滑将直接调用 Android 系统原生 Predictive Back 退栈动画关闭 WebView。
2. **生命周期保活（`Offstage` 重构）**：
   * 为了解决页面加载失败后原生 `InAppWebView` 被销毁重建导致 Controller 的 MethodChannel 彻底解绑并诱发重试按钮报 `MissingPluginException` 的问题，我们将 WebView 视口的条件渲染修改为：
     ```dart
     Offstage(
       offstage: _hasError,
       child: _buildWebView(context),
     )
     ```
   * 这保证了即使发生报错，原生视图和底层管道也依然存活，点击“Retry”可无缝重试。
3. **自定义 Scheme Interception (`url_launcher`)**：
   * 通过在 `CommonWebView` 中引入 `webSchemes` 属性（默认包含 `['http', 'https', 'file', 'chrome', 'about']`），支持自定义配置内部网页协议。
   * 任何非此配置中的协议（如 `mailto:`, `tel:`, `sms:` 等），在 `shouldOverrideUrlLoading` 阶段就会被自动侦测，并交由 `url_launcher` 从系统外部唤起相应应用，防止 WebView 直接抛出 Native 网页加载错误而破坏用户体验。

### 6.3 零重复代码的 PopScope 分发实现 (`onPopInvokedWithResult`)

在 `BaseLifeCyclePage` 中，我们以一种优雅、免维护的形式组合了出栈生命周期和拦截逻辑，规避了大量样板代码的复制：

```dart
        return PopScope(
          canPop: !widget.active || ((widget.canPop ?? true) && !_isInternalLoading.value),
          onPopInvokedWithResult: (didPop, resultVal) {
            if (!widget.active) return;
            if (didPop) {
              // Page successfully popped. Cancel pending requests immediately to release network resources.
              _viewModel?.cancelRequests("onBackInvoked");
            } else if (_isInternalLoading.value) {
              // If page is currently loading internally, intercept back gesture to cancel requests and dismiss loading spinner first.
              _viewModel?.cancelRequests("onBackInvoked");
              _viewModel?.emitEffect(LoadingEffect(false));
            } else if (widget.onInterceptBack != null) {
              // Back gesture blocked/intercepted. Trigger custom intercept callback if provided.
              widget.onInterceptBack!();
            }
          },
          child: result,
        );
```
通过该设计，整个架构保障了在返回手势交互下网络请求的即时回收、UI 加载态的智能闭环，以及根级页面返回栈的最佳实践。


---

## 技术难点与解决方案 (Technical Challenges & Solutions)

* **状态与生命周期管理**：在 Flutter 中处理异步回调与 Widget 生命周期的错位是一个普遍难题。解决方案是严格遵循 MVI 架构中的状态下发与副作用分发，结合 `AppNav` 统一管理生命周期拦截与清理，防止内存泄漏或无效的 UI 重绘。
* **跨平台一致性**：不同平台（Android/iOS/Web）的系统级行为（如返回手势、原生组件交互）存在差异。解决方案是使用统一的服务抽象层 (Interfaces)，将平台特有的实现细节隔离在 `_impl` 文件中，保证业务侧调用的跨平台一致性。
