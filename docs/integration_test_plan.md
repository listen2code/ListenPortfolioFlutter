# ListenPortfolioFlutter UI 界面功能集成测试计划书 (进阶版)

本计划书重点解决以下问题：
1. **最大化覆盖 Intent**：确保测试操作能映射到 ViewModel 定义的所有关键 UI 意图（Intents）。
2. **防中断与独立性**：将庞大的测试拆分为独立的 `testWidgets`。某一个用例失败不会影响其他用例的继续执行（非阻塞式级联）。
3. **单组/连续可执行**：通过抽取**公共 UI 操作助手函数（Helpers）**，使得各用例组即可在一条测试命令中连续运行，也可通过 `--name` 单独指定运行。

---

## 1. 架构设计与防中断策略

### 1.1 独立测试用例组 (Separated testWidgets)
我们将不再把所有测试塞入一个 `testWidgets` 中。通过定义 5 个独立的 `testWidgets`，Flutter 测试运行器能够自动运行完所有测试。如果其中之一失败，只会将该单项标记为 Fail，测试终端将**继续执行下一项**，绝不中断。

### 1.2 公共操作助手函数 (UI Helpers)
为了保证测试的独立性，每个单独运行的用例组如果需要前置登录状态，将不依赖上一个用例的内存残留，而是通过 Helper 函数快速在 UI 上模拟操作或通过 Mock 注入状态：
* `Future<void> bootAppAndGoToLogin(WidgetTester tester)`
* `Future<void> performUiLogin(WidgetTester tester, String username, String password)`
* `Future<void> navigateToSettings(WidgetTester tester)`

---

## 2. 界面功能与 Intent 覆盖规划

每个界面的测试都旨在尽量触发该界面 ViewModel 所持有的所有 MVI `Intent`，验证界面的状态变化和 Effect 响应。

### Case 组 1：登录画面 Intent 覆盖测试
* **覆盖 Intent**：
    - `LoginIntent.login(username, password)` (校验/登录)
    - `LoginIntent.togglePasswordVisibility()` (切换密码明暗文显示)
    - 路由跳转意图 (忘记密码/注册/游客登录)
* **独立运行前置条件**：应用启动

| 用例名称 (Test Name) | 界面操作与触发 Intent | 校验点与断言 |
| :--- | :--- | :--- |
| **`UI Test - Login Form and Validations`** | 1. 触发密码框眼睛图标 ➔ `togglePasswordVisibility`<br>2. 输入空数据并点击登录 ➔ 触发本地格式校验<br>3. 输入无效用户名并点击登录 ➔ `LoginIntent.login` | 1. 密码明文与暗文切换正常，图标改变。<br>2. 校验到空白时显示“字段必填”校验，不发送网络请求。<br>3. 校验到格式错误，显示报错。 |

---

### Case 组 2：忘记密码与注册页面 Intent 覆盖测试
* **覆盖 Intent**：
    - `ForgotPasswordIntent.submit(email)`
    - `SignUpIntent.submit(username, email, password, confirmPassword)`
* **独立运行前置条件**：启动应用并导航至对应界面。

| 用例名称 (Test Name) | 界面操作与触发 Intent | 校验点与断言 |
| :--- | :--- | :--- |
| **`UI Test - Forgot Password Flow`** | 1. 导航至 ForgotPassword 页面。<br>2. 输入邮箱并点击发送 ➔ `ForgotPasswordIntent.submit` | 1. 界面渲染正常。<br>2. 发送成功后显示成功提示，并自动 pop/返回登录页面。 |
| **`UI Test - Sign Up Flow`** | 1. 导航至 SignUp 页面。<br>2. 输入各项注册字段 ➔ `SignUpIntent.submit` | 1. 验证密码二次确认的一致性阻断。<br>2. 注册成功后，自动 pop/返回登录页面。 |

---

### Case 组 3：主页 Tabs 与 Drawer 导航测试
* **覆盖 Intent**：
    - `HomeIntent.changeTab(index)`
    - `OverviewIntent.refresh()` (下拉刷新或拉取数据)
    - `AboutMeIntent.share()` (分享当前应用)
* **独立运行前置条件**：调用 `performUiLogin` 快速登录。

| 用例名称 (Test Name) | 界面操作与触发 Intent | 校验点与断言 |
| :--- | :--- | :--- |
| **`UI Test - Home Navigation and Tabs`** | 1. 执行快速登录。<br>2. 切换底部导航 ➔ `HomeIntent.changeTab`（切换四个 Tab）。<br>3. 在 Overview 触发下拉刷新 ➔ `OverviewIntent.refresh`。<br>4. 在 AboutMe 页面点击右上角分享 ➔ `AboutMeIntent.share`。 | 1. 各个 Tab 切换后内容 Widget 正确刷新。<br>2. 下拉刷新时，列表显示加载圈并成功刷新内容。<br>3. 分享 Effect 被 Fake 拦截并提示成功。 |

---

### Case 组 4：设置中心全功能测试
* **覆盖 Intent**：
    - `SettingsIntent.changeLanguage(locale)` (多语言)
    - `SettingsIntent.changeThemeMode(mode)` (深浅主题)
    - `SettingsIntent.clearCache()` (清除本地物理缓存)
    - `SettingsIntent.checkUpdates()` (检查更新)
* **独立运行前置条件**：调用 `performUiLogin` ➔ 导航至设置页。

| 用例名称 (Test Name) | 界面操作与触发 Intent | 校验点与断言 |
| :--- | :--- | :--- |
| **`UI Test - Settings Adjustments`** | 1. 登录并进入设置页。<br>2. 切换语言为 英文/日文 ➔ `changeLanguage`。<br>3. 切换主题为 深色/浅色 ➔ `changeThemeMode`。<br>4. 点击“清理缓存” ➔ `clearCache`。<br>5. 点击“检查更新” ➔ `checkUpdates`。 | 1. 英文与日文切换后，UI 文本即时翻译。<br>2. 主题色彩实时变化。<br>3. 弹出缓存清理成功 Toast，本地缓存置空。<br>4. 成功拉取 `version.json` 并在 UI 显示更新日志弹窗。 |

---

### Case 组 5：注销与会话清退测试
* **覆盖 Intent**：
    - `SettingsIntent.logout()` / `AuthIntent.logout()`
* **独立运行前置条件**：调用 `performUiLogin`。

| 用例名称 (Test Name) | 界面操作与触发 Intent | 校验点与断言 |
| :--- | :--- | :--- |
| **`UI Test - Logout Flow`** | 1. 登录并进入设置或侧边栏。<br>2. 点击退出登录。<br>3. 弹出确认对话框，点击“取消” ➔ 不动作。<br>4. 重新点击“退出登录”，点击“确认” ➔ 触发注销 Intent。 | 1. 弹出二次确认框。<br>2. 点击确认后，界面安全 pop 并重定向至 `LoginPage`。<br>3. 此时内存中的用户信息 providers 均已被 invalidate 销毁。 |

---

## 3. 测试代码结构骨架设计

通过将每个用例组编写为独立的 `testWidgets`，可以达到“即便中间某项失败，依然继续运行剩余组测试”的效果。

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:listen_portfolio_flutter/main.dart' as app;
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';

// ==========================================
// 抽取公共操作 Helpers
// ==========================================
Future<void> bootAppAndGoToLogin(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();
  // 确保处于 LoginPage。若在 Home，先触发注销导航
  if (find.byType(HomePage).preludeMatches) {
    // 触发注销
  }
}

Future<void> performUiLogin(WidgetTester tester, String username, String password) async {
  app.main();
  await tester.pumpAndSettle();
  if (find.byType(LoginPage).preludeMatches) {
    await tester.enterText(find.byType(CommonTextField).at(0), username);
    await tester.enterText(find.byType(CommonTextField).at(1), password);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CommonButton, I18nKeys.login.tr));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }
}

Future<void> navigateToSettings(WidgetTester tester) async {
  final ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
  scaffoldState.openDrawer();
  await tester.pumpAndSettle();
  await tester.tap(find.text(I18nKeys.settings.tr));
  await tester.pumpAndSettle();
}

// ==========================================
// 独立执行与连续执行的测试用例集
// ==========================================
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // 注入 Fake 服务与低延迟设置
    LocalMockServer.initConfig(const MockServerConfig(networkLatency: Duration(milliseconds: 10)));
    notificationService = FakeNotificationService();
    iapService = FakeIapService();
  });

  group('UI E2E Isolated Groups', () {
    
    // ------------------------------------------
    // CASE GROUP 1
    // ------------------------------------------
    testWidgets('UI Test - Login Form and Validations', (WidgetTester tester) async {
      await bootAppAndGoToLogin(tester);
      
      // 触发 togglePasswordVisibility Intent
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pumpAndSettle();
      
      // 触发空白校验
      await tester.tap(find.widgetWithText(CommonButton, I18nKeys.login.tr));
      await tester.pumpAndSettle();
      expect(find.text(I18nKeys.fieldRequired.tr), findsAtLeastNWidgets(1));
    });

    // ------------------------------------------
    // CASE GROUP 2
    // ------------------------------------------
    testWidgets('UI Test - Forgot Password Flow', (WidgetTester tester) async {
      await bootAppAndGoToLogin(tester);
      await tester.tap(find.text(I18nKeys.forgotPassword.tr));
      await tester.pumpAndSettle();
      
      // 提交 ForgotPasswordIntent
      await tester.enterText(find.byType(CommonTextField), 'test_user@gmail.com');
      await tester.tap(find.text(I18nKeys.sendResetLink.tr));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      
      expect(find.byType(LoginPage), findsOneWidget); // 自动重定向回 Login
    });

    // ------------------------------------------
    // CASE GROUP 3
    // ------------------------------------------
    testWidgets('UI Test - Home Navigation and Tabs', (WidgetTester tester) async {
      await performUiLogin(tester, 'test_user', 'password123');
      
      // 触发 HomeIntent.changeTab
      final aboutMeTab = find.byIcon(Icons.person);
      await tester.tap(aboutMeTab);
      await tester.pumpAndSettle();
      
      // 触发 AboutMeIntent.share
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();
    });

    // ------------------------------------------
    // CASE GROUP 4
    // ------------------------------------------
    testWidgets('UI Test - Settings Adjustments', (WidgetTester tester) async {
      await performUiLogin(tester, 'test_user', 'password123');
      await navigateToSettings(tester);
      
      // 触发 changeLanguage
      await tester.tap(find.text(I18nKeys.language.tr));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      
      // 验证界面已即时汉化/英化
      expect(find.text('Language'), findsOneWidget);
    });

    // ------------------------------------------
    // CASE GROUP 5
    // ------------------------------------------
    testWidgets('UI Test - Logout Flow', (WidgetTester tester) async {
      await performUiLogin(tester, 'test_user', 'password123');
      await navigateToSettings(tester);
      
      // 触发注销
      await tester.tap(find.text(I18nKeys.logout.tr));
      await tester.pumpAndSettle();
      await tester.tap(find.text(I18nKeys.ok.tr));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
```

---

## 4. 运行说明

### 4.1 连续执行（全部自动运行）
```bash
# 这将顺序跑完 group 下的所有独立 testWidgets。中间若有单项报错，会继续执行后续 case。
flutter test integration_test/app_test.dart
```

### 4.2 单独指定某一个分组执行
```bash
# 只执行设置页修改用例
flutter test integration_test/app_test.dart --name="UI Test - Settings Adjustments"

# 只执行忘记密码用例
flutter test integration_test/app_test.dart --name="UI Test - Forgot Password Flow"
```
