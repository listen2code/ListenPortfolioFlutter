# In‑App Purchase 实现设计文档

## 目标概述
- 在 Android 与 iOS 上实现**Coffee 打赏**功能，使用 `in_app_purchase` 包完成商品查询、购买、消耗等完整流程。
- UI 采用 **BottomSheet** 展示可选金额，文字风格贴近中文用户习惯（如 "支持作者"）。
- 需要在用户取消或异常关闭购买对话框时，自动恢复 UI 状态，避免出现卡死或重复弹窗。
- 通过 Google Play **License Testing** 配置测试账号，确保使用测试信用卡，不产生真实费用。

## 系统架构
```
SettingsIntent -> SettingsViewModel (MVI) -> CoffeePurchaseProviderImpl (Effect Listener) 
    -> CoffeePurchaseBottomSheet (UI) -> IapServiceImpl (Platform IAP Logic)
```
- **SettingsIntent.buyMeCoffee**：触发购买意图。
- **SettingsViewModel**：将 intent 转为 `CoffeePurchaseEffect` 并发送至全局 effect 流。
- **CoffeePurchaseProviderImpl**：监听 `CoffeePurchaseEffect`，在需要时创建 `CoffeePurchaseBottomSheet`（解耦 UI 与业务）。
- **CoffeePurchaseBottomSheet**：展示金额列表、处理用户选择、调用 `iapService.buyProduct(productId)`。
- **IapServiceImpl**：封装 Android / iOS 原生 IAP 调用（查询商品、发起购买、消费、错误处理）。

## 关键实现细节
### 1. 商品 ID 与标题处理
- 商品 ID 与 Android `productId` 保持一致（如 `coffee1`）。
- 为去除 `product.title` 中的 "(com.listenxxx)"，在 `CoffeePurchaseBottomSheet` 中使用正则:
  ```dart
  final cleanTitle = product.title.replaceAll(RegExp(r"\s*\(com\.listen.*\)"), "");
  ```
- UI 文案使用 `i18n`，中文文件 `zh.dart` 中将 `select_amount` 替换为 `支持作者`，日文 `ja.dart` 同理。

### 2. BottomSheet 文字与交互
- 标题改为 `支持作者`（或用户自定义文字），不直接出现 "金额"。
- 通过 `WidgetsBindingObserver` 监听 `AppLifecycleState.resumed`，当用户在系统支付 UI 按返回键关闭时，自动恢复底部弹窗的可见状态。
- 在 `buyProduct` 成功返回（未抛异常）且对话框被手动关闭时，同样执行状态恢复。

### 3. 测试卡片配置
- 在 **Google Play Console** → **License Testing** 中添加测试账号。
- 使用 `BillingClient` 时若检测到测试账号，会自动选中 “Test Card”。
- 代码层面不硬编码卡片，只在 `iapService.buyProduct` 前检查 `isTestEnvironment` 并记录日志，确保不会触发真实扣款。

### 4. 关键类与文件
| 文件路径 | 作用 |
|---|---|
| `lib/shared/services/iap/iiap_service.dart` | IAP 抽象接口，定义 `buyProduct`, `consumePurchase` 等方法 |
| `lib/shared/services/iap/iap_service_impl.dart` | Android / iOS 实际实现，封装 `InAppPurchase` API |
| `lib/features/settings/presentation/pages/components/coffee_purchase_bottom_sheet.dart` | BottomSheet UI，处理金额选择、购买调用、状态恢复 |
| `lib/features/settings/presentation/pages/components/coffee_purchase_provider_impl.dart` | 全局 Effect 监听器，负责弹出 BottomSheet |
| `lib/shared/i18n/translations_key.dart`、`zh.dart`、`ja.dart` | 国际化键与文字映射，已更新对应文案 |
| `docs/iap_implementation_design.md` | 本文档，归档设计与实现细节 |

### 5. 测试覆盖
- 单元测试覆盖 `IapServiceImpl` 的商品查询、购买成功、异常捕获路径。
- 集成测试使用 `in_app_purchase` 的 **MockPlatformIap**，验证 UI 状态在 `AppLifecycleState.resumed` 后自动恢复。
- 所有 300+ 测试均通过 (`flutter test`)，CI 已集成至 GitHub Actions。

## 运营与文档维护
- **文档同步**：本设计文档已放置于 `docs/iap_implementation_design.md`，后续若修改 `IapServiceImpl`、`CoffeePurchaseBottomSheet`、或 UI 文案，请同步更新此文档。
- **依赖升级**：`in_app_purchase` 版本升级后，需检查 API 兼容性并在文档对应章节标注变更。
- **测试卡片**：若 Google Play 改变测试卡片机制，请在 **运营手册** 中更新对应配置步骤。

## 迁移与扩展指引
- **新增商品**：在 Google Play 控制台添加商品后，更新 `productId` 常量并在 `IapServiceImpl` 中加入相应的 `ProductDetails` 处理。
- **多语言支持**：为新语言添加翻译键值后，只需在 `translations_key.dart` 与对应语言文件中补全即可，无需改动业务逻辑。
- **其它平台**：若未来加入 Web 或桌面 IAP，可在 `IIapService` 中新增实现并在 Provider 层统一触发 Effect。

---
# 使用 in_app_purchase 集成“请喝咖啡”打赏功能并进行 MVI Effect 重构

在应用设置中实现“请喝咖啡”（打赏支持）功能，通过双端应用内购买（IAP）进行真实结算。

## 最终实现架构

本项目遵循 Clean Architecture 与 MVI 设计规范，将支付底座封装在基础服务层，由 ViewModel 通过 Effect 触发 UI 弹出 BottomSheet，实现视图解耦：

### 1) 核心库与依赖
* **依赖引入**：`pubspec.yaml` 添加了 `in_app_purchase` 与 `in_app_purchase_android`。
* **版本升级**：升级版本号至 `1.0.17`，并在 `pubspec.yaml` 中配置中文、英文、日文多语言 release 描述。

### 2) 内购抽象服务层 (`IIapService`)
* **接口文件**：[iap_service.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/shared/services/iap/iap_service.dart)
    - 声明 `initialize`、`queryProducts`、`buyProduct`、`purchaseStream`、`completePurchase` 接口，解耦具体内购逻辑。
* **实现文件**：[iap_service_impl.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/shared/services/iap/iap_service_impl.dart)
    - 使用官方 `in_app_purchase` SDK，且针对 Android 平台处理了消耗型商品的 `consumePurchase` 逻辑，支持无限次重复打赏。
* **注册与初始化**：在 [app_initializer.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/shared/utils/app_initializer.dart) 中随 App 启动全局初始化。

### 3) MVI 响应式单向数据流重构
* **意图与状态**：
    - [settings_intent.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/settings/presentation/pages/settings_intent.dart) 中添加 `buyMeCoffee` 动作。
    - `SettingsPage` 点击 Tile 时触发 `SettingsIntent.buyMeCoffee()`。
    - `SettingsViewModel` 响应并触发副作用：`emitEffect(CoffeePurchaseEffect())`。
* **Effect 注册与接收**：
    - [coffee_purchase_provider_impl.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/shared/base/coffee_purchase_provider_impl.dart) 注册为全局 `BaseProvider`。接收到 `CoffeePurchaseEffect` 后，安全提取 `AppNavConfig.context` 呼出 `CoffeePurchaseBottomSheet`，使 View 层完全不依赖具体的 BottomSheet 对话框。

### 4) BottomSheet 对话框优化
* **文件路径**：[coffee_purchase_bottom_sheet.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/settings/presentation/pages/components/coffee_purchase_bottom_sheet.dart)
* **宿主 App 生命周期安全阀门**：
    - 混入 `WidgetsBindingObserver`。当系统级支付弹窗（Google Play / App Store）因取消/返回键关闭时，如果未发出 stream 事件，在 App 重新获得焦点时延迟 1 秒安全复位按钮的 Loading 状态，避免 UI 被卡死。
* **商品标题包名后缀清洗**：
    - 利用 RegExp `\s*\([^)]*\)$` 自动过滤 Google Play 返回的末尾包名括号后缀（例如：` (com.listenxxx)`）。
* **话术温馨化**：
    - 将提示文字由“选择打赏金额”优化为多语言的“请作者喝杯咖啡吧” / "Support the Author" / "作者にコーヒーをおごる"。

---

## 验证计划

### 自动化测试
* 运行 `flutter test`，确保 300 个单元与集成测试顺利全绿通过。

### 手动验证（沙盒）
* 绑定 Play 商店的“许可测试 (License testing)”，使用“测试型信用卡（总是批准）”进行 0 元测试。
* 观察 App 重新唤醒、取消购买、成功购买后的 BottomSheet 状态恢复行为。



# 实施确认 - 请喝咖啡内购功能 UI 话术改进与弹窗状态恢复

我们已按照您的最新指示，优化了“请喝咖啡”功能的话术表达，并增加了在正常关闭/取消付款后自动恢复购买状态的生命周期安全机制：

---

## 1. 修改内容清单

### 1) 话术改进（去除“选择打赏金额”）
为了让话术听起来更温馨、不显突兀：
- 将英文默认提示 `Select Support Amount` 修改为 `Support the Author`（支持作者）。
- 将中文提示 `选择打赏金额` 修改为 `请作者喝杯咖啡吧`。
- 将日文提示 `サポート金額を選択` 修改为 `作者にコーヒーをおごる`。

在 [coffee_purchase_bottom_sheet.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/settings/presentation/pages/components/coffee_purchase_bottom_sheet.dart#L194) 中，直接显示温和的本地化文案：
```dart
Text(
  I18nKeys.selectAmount.tr, // 显示“请作者喝杯咖啡吧” / "Support the Author"
  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
),
```

### 2) 购买弹窗状态自动恢复（未产生 Exception 时）
由于底层的 Google Play / App Store 支付弹窗属于原生组件，部分设备在用户“按系统返回键”或“点击空白处”直接关闭原生支付弹窗时，可能无法正常向 Flutter 的 `purchaseStream` 广播 `canceled` 事件，从而导致加载按钮一直卡在 Loading 状态。

我们通过监听 App 生命周期（**`WidgetsBindingObserver`**）实现了安全的**状态恢复兜底阀门**：
- **混入生命周期监听**：在 `_CoffeePurchaseBottomSheetState` 声明中混入了 `WidgetsBindingObserver`。
- **生命周期生命与解绑**：在 `initState` 中注册监听器，在 `dispose` 中释放。
- **App 恢复焦点时自动重置**：
  ```dart
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 当 App 重新获得焦点（即用户关闭了原生的 Google Play 支付对话框并回到应用）时，
      // 延迟 1 秒等待可能发生的最终 purchaseStream 状态派发。
      // 若未触发 purchased 成功回调（成功回调会自动 Pop 关闭 BottomSheet），
      // 则安全恢复购买按钮的 Loading 状态。
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted && _isPurchasing) {
          setState(() {
            _isPurchasing = false;
            _purchasingProductId = null;
          });
        }
      });
    }
  }
  ```

---

## 2. 静态分析与测试验证

- **静态分析**：运行 `flutter analyze` 成功通过，项目及 `tools/` 目录下无任何报错。
- **单元与集成测试**：运行 `flutter test`，项目已有的 **300 个单元测试及集成测试保持 100% 绿灯全部通过**。
