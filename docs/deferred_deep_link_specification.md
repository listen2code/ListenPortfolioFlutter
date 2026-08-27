# Google Play 延迟深度链接 (Deferred Deep Link / Install Referrer) 技术规范与使用文档

## 1. 概述与背景
Deferred Deep Linking（延迟深度链接）允许用户在**尚未安装 App** 的情况下，点击包含推广来源和直达参数的链接，跳转到 Google Play Store 进行安装。当用户首次安装并启动应用时，应用通过 Google Play Install Referrer API 读取安装前携带的来源参数（例如 `refer=ListenCommunity&target=projects`），从而弹出专属欢迎对话框并直达目标模块。

---

## 2. 核心架构与数据流

```mermaid
sequenceDiagram
    autonumber
    actor User as 用户
    participant Link as 推广链接 / Web
    participant Play as Google Play Store
    participant App as lPortfolio Flutter App
    participant MethodChannel as Platform Channel
    participant Service as InstallReferrerService
    participant ViewModel as HomeViewModel
    participant UI as ReferralWelcomeDialog

    User->>Link: 点击推广链接 (带 referrer 参数)
    Link->>Play: 重定向到 Play 商店页面
    User->>Play: 点击安装并打开 App
    Play-->>App: 广播并缓存 Install Referrer 数据
    App->>ViewModel: onReady() -> 触发 checkDeferredDeepLink
    ViewModel->>Service: hasProcessedReferrer() 校验是否首次安装
    alt 首次打开应用
        Service->>MethodChannel: getInstallReferrer
        MethodChannel-->>Service: 返回原始 query 参数 (如 refer=ListenCommunity&target=projects)
        Service->>Service: 解析并保存至 LocalStorage (SpUtil)
        Service-->>ViewModel: 返回 InstallReferrerData 实体
        ViewModel->>UI: 发送 ReferralWelcomeEffect 弹出欢迎弹窗
        UI-->>User: 展示欢庆欢迎卡片与来源信息
        User->>UI: 点击【开启探索】
        UI->>ViewModel: 自动直达对应 targetRoute (如 /home?tab=projects)
    else 非首次启动
        Service-->>ViewModel: 已处理，静默跳过
    end
```

---

## 3. Google Play 推广链接格式规范

### 3.1 链接格式
标准的 Google Play 推广链接格式如下：
```text
https://play.google.com/store/apps/details?id=com.listen.portfolio.listen_portfolio_flutter&referrer=<URL_ENCODED_PARAMS>
```

### 3.2 参数说明
| 参数名 | 类型 | 说明 | 示例 |
| :--- | :--- | :--- | :--- |
| `refer` | String | 推荐人、推广活动或来源渠道标识 | `ListenCommunity` / `DevCamp2026` |
| `target` | String (可选) | 首次启动后推荐直达的目标页面/Tab | `projects` / `aboutMe` / `architecture` / `/settings` |
| `utm_source` | String (可选) | Google Analytics / 营销来源 | `twitter` / `github` / `newsletter` |
| `utm_campaign` | String (可选) | 营销活动名称 | `launch_promo` |
| `utm_medium` | String (可选) | 媒介类型 | `social` / `email` |

### 3.3 示例链接
- **示例 1 (纯推荐人)**:
  `https://play.google.com/store/apps/details?id=com.listen.portfolio.listen_portfolio_flutter&referrer=refer%3DListenCommunity`
- **示例 2 (推荐人 + 自动跳转到 Projects 技能模块)**:
  `https://play.google.com/store/apps/details?id=com.listen.portfolio.listen_portfolio_flutter&referrer=refer%3DJohnDoe%26target%3Dprojects`
- **示例 3 (UTM 广告活动)**:
  `https://play.google.com/store/apps/details?id=com.listen.portfolio.listen_portfolio_flutter&referrer=utm_source%3Dtwitter%26utm_campaign%3Dopen_source_release%26target%3DaboutMe`

---

## 4. 核心代码结构

1. **Android 原生 MethodChannel**:
   - `android/app/src/main/kotlin/com/listen/portfolio/listen_portfolio_flutter/MainActivity.kt`
   - 集成 `com.android.installreferrer:installreferrer:2.2`。
   - 实现 `com.listen.portfolio/install_referrer` channel，异步连接 `InstallReferrerClient` 获取 referrer 字符串。

2. **领域模型与服务层**:
   - `lib/shared/services/referrer/install_referrer_data.dart`:
     - 支持复合 URL 解码、标准 query 解析、来源格式化及 JSON 序列化。
   - `lib/shared/services/referrer/install_referrer_service.dart`:
     - 提供 `fetchInstallReferrer()`、`hasProcessedReferrer()`、`markReferrerProcessed()` 与模拟调试接口 `simulateReferrer()`。

3. **MVI 状态与副作用驱动**:
   - `lib/features/home/presentation/pages/home_intent.dart`:
     - `HomeIntent.checkDeferredDeepLink()` 与 MVI 回放支持。
   - `lib/features/home/presentation/pages/home_view_model.dart`:
     - 首次启动自动检查，仅触发一次，确认后支持 Tab 或指定路由无缝跳转。
   - `lib/shared/base/referral_welcome_provider_impl.dart`:
     - `ReferralWelcomeEffect` 与 `ReferralWelcomeProviderImpl` 解耦全局对话框渲染。

4. **UI 弹窗组件与多语言支持**:
   - `lib/shared/widgets/dialogs/referral_welcome_dialog.dart`:
     - 符合 Material 3 设计规范的欢迎对话框，展示来源卡片与目标直达提示。
   - 多语言支持：中、英、日三语（`zh.dart`, `en.dart`, `ja.dart`）。

---

## 5. 开发者调试与验证方式

### 方法 1: 使用应用内开发者模式 (无需真机连接 Google Play)
1. 打开应用，进入 **设置 (Settings)** 页面。
2. 连续点击版本号 7 次激活 **开发者模式**。
3. 在开发者工具列表中点击 **【模拟 Deferred Deep Link (延迟深度链接)】**。
4. 应用将立即模拟首次安装并在屏幕上弹出专属欢迎对话框，确认后测试相应跳转。

### 方法 2: 使用 Android ADB 模拟 Google Play 广播
连接 Android 真机或模拟器后，在终端执行以下 ADB 命令向应用发送测试广播：
```bash
adb shell am broadcast -a com.android.vending.INSTALL_REFERRER -n com.listen.portfolio.listen_portfolio_flutter/com.listen.portfolio.listen_portfolio_flutter.MainActivity --es "referrer" "refer=ListenCommunity&target=projects"
```

### 方法 3: 自动化测试套件
运行以下单元与组件测试命令：
```bash
flutter test test/shared/services/install_referrer_service_test.dart test/shared/widgets/referral_welcome_dialog_test.dart test/features/home/home_view_model_deferred_deeplink_test.dart
```
