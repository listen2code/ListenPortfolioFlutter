import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:integration_test/integration_test.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_page.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:listen_portfolio_flutter/main.dart' as app;
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ==========================================
// Robust Page Transition Wait Helpers
// ==========================================
Future<void> waitForPageTransition(WidgetTester tester) async {
  // Wait up to 10 seconds for SplashPage to disappear
  for (int i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (find.byType(SplashPage).evaluate().isEmpty) {
      break;
    }
  }
  await tester.pumpAndSettle();
}

Future<void> waitForPage(WidgetTester tester, Type pageType) async {
  // Wait up to 5 seconds for page of type to appear
  for (int i = 0; i < 25; i++) {
    await tester.pump(const Duration(milliseconds: 200));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (find.byType(pageType).evaluate().isNotEmpty) {
      break;
    }
  }
  await tester.pumpAndSettle();
}

// ==========================================
// UI Helpers for Isolated & Re-entrant Runs
// ==========================================
Future<void> bootAppAndGoToLogin(WidgetTester tester) async {
  // If already on LoginPage, do nothing
  if (find.byType(LoginPage).evaluate().isNotEmpty) {
    return;
  }

  // If on HomePage, just navigate to LoginPage
  if (find.byType(HomePage).evaluate().isNotEmpty) {
    tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    final loginDrawerOption = find.text(I18nKeys.login.tr);
    if (loginDrawerOption.evaluate().isNotEmpty) {
      await tester.tap(loginDrawerOption);
      await tester.pumpAndSettle();
    }
    return;
  }

  // Otherwise, boot the app from scratch
  app.main();
  await tester.pumpAndSettle();

  // Wait for splash transition to complete
  await waitForPageTransition(tester);

  // If we are on HomePage, navigate to LoginPage
  if (find.byType(HomePage).evaluate().isNotEmpty) {
    tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    final loginDrawerOption = find.text(I18nKeys.login.tr);
    expect(loginDrawerOption, findsOneWidget);

    await tester.tap(loginDrawerOption);
    await tester.pumpAndSettle();
  }
}

Future<void> performUiLogin(WidgetTester tester, String username, String password) async {
  await bootAppAndGoToLogin(tester);

  if (find.byType(LoginPage).evaluate().isNotEmpty) {
    final loginFields = find.byType(CommonTextField);
    await tester.enterText(loginFields.at(0), username);
    await tester.enterText(loginFields.at(1), password);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    final submitLoginBtn = find.widgetWithText(CommonButton, I18nKeys.login.tr);
    await tester.tap(submitLoginBtn);
    await waitForPage(tester, HomePage);
  }
}

Future<void> navigateToSettings(WidgetTester tester) async {
  if (find.byType(HomePage).evaluate().isEmpty) {
    await performUiLogin(tester, 'test_user', 'password123');
  }

  if (find.byType(HomePage).evaluate().isNotEmpty) {
    tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    final settingsOption = find.text(I18nKeys.settings.tr);
    await tester.tap(settingsOption);
    await waitForPage(tester, SettingsPage);
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Store original global error handlers to prevent assertion leaks
  FlutterExceptionHandler? originalOnError;
  bool Function(Object, StackTrace)? originalDispatcherOnError;

  setUpAll(() {
    // Prevent visibility animations from lagging and blocking pumpAndSettle
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    // Pre-initialize mock services to prevent native hangs during tests
    iapService = FakeIapService();
    notificationService = FakeNotificationService();

    // Configure LocalMockServer with low latency for fast execution
    LocalMockServer.initConfig(const MockServerConfig(networkLatency: Duration(milliseconds: 10)));
  });

  setUp(() {
    originalOnError = FlutterError.onError;
    originalDispatcherOnError = PlatformDispatcher.instance.onError;
  });

  tearDown(() {
    FlutterError.onError = originalOnError;
    PlatformDispatcher.instance.onError = originalDispatcherOnError;
  });

  group('E2E UI Flow Integration Tests', () {
    // ==========================================
    // CASE GROUP 1: Login Form & Validations
    // ==========================================
    testWidgets('UI Test - Login Form and Validations', (WidgetTester tester) async {
      await bootAppAndGoToLogin(tester);

      expect(find.byType(LoginPage), findsOneWidget);

      final loginFields = find.byType(CommonTextField);
      expect(loginFields, findsNWidgets(2));

      final submitLoginBtn = find.widgetWithText(CommonButton, I18nKeys.login.tr);
      expect(submitLoginBtn, findsOneWidget);

      // Verify and tap Remember Me toggle
      final rememberMeBtn = find.text(I18nKeys.rememberMe.tr);
      expect(rememberMeBtn, findsOneWidget);
      await tester.tap(rememberMeBtn);
      await tester.pumpAndSettle();

      // Test Password visibility toggle locally in CommonTextField
      final passwordVisibilityOff = find.byIcon(Icons.visibility_off);
      expect(passwordVisibilityOff, findsOneWidget);
      await tester.tap(passwordVisibilityOff);
      await tester.pumpAndSettle();

      final passwordVisibilityOn = find.byIcon(Icons.visibility);
      expect(passwordVisibilityOn, findsOneWidget);
      await tester.tap(passwordVisibilityOn);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // ABNORMAL 1: Submit with empty fields
      await tester.enterText(loginFields.at(0), '');
      await tester.enterText(loginFields.at(1), '');
      await tester.pumpAndSettle();

      await tester.ensureVisible(submitLoginBtn);
      await tester.pumpAndSettle();
      await tester.tap(submitLoginBtn);
      await tester.pumpAndSettle();
      // Expect "Field required" errors
      expect(find.text(I18nKeys.fieldRequired.tr), findsNWidgets(2));

      // ABNORMAL 2: Submit with too short username and password
      await tester.enterText(loginFields.at(0), 'ab');
      await tester.enterText(loginFields.at(1), '123');
      await tester.pumpAndSettle();

      await tester.tap(submitLoginBtn);
      await tester.pumpAndSettle();
      // Expect min length validation errors
      expect(find.text(I18nKeys.minLengthMsg.trArgs(['3'])), findsOneWidget);
      expect(find.text(I18nKeys.minLengthMsg.trArgs(['6'])), findsOneWidget);
    });

    // ==========================================
    // CASE GROUP 2: Forgot Password Flow
    // ==========================================
    testWidgets('UI Test - Forgot Password Flow', (WidgetTester tester) async {
      await bootAppAndGoToLogin(tester);

      final forgotPasswordBtn = find.text(I18nKeys.forgotPassword.tr);
      expect(forgotPasswordBtn, findsOneWidget);

      // Tap Forgot Password
      await tester.tap(forgotPasswordBtn);
      await tester.pumpAndSettle();

      // Verify page transition
      expect(find.byType(ForgotPasswordPage), findsOneWidget);

      final forgotEmailField = find.byType(CommonTextField);
      expect(forgotEmailField, findsOneWidget);

      final sendResetBtn = find.text(I18nKeys.sendResetLink.tr);
      expect(sendResetBtn, findsOneWidget);

      // Submit invalid email format
      await tester.enterText(forgotEmailField, 'invalid-email');
      await tester.pumpAndSettle();
      await tester.tap(sendResetBtn);
      await tester.pumpAndSettle();
      expect(find.text(I18nKeys.invalidEmail.tr), findsOneWidget);

      // Submit valid email
      await tester.enterText(forgotEmailField, 'test_user@gmail.com');
      await tester.pumpAndSettle();

      // Dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      await tester.tap(sendResetBtn);
      await waitForPage(tester, LoginPage);

      // Verify redirect back to LoginPage
      expect(find.byType(LoginPage), findsOneWidget);
    });

    // ==========================================
    // CASE GROUP 3: Sign Up Flow
    // ==========================================
    testWidgets('UI Test - Sign Up Flow', (WidgetTester tester) async {
      await bootAppAndGoToLogin(tester);

      final signUpBtn = find.text(I18nKeys.signUp.tr);
      expect(signUpBtn, findsOneWidget);

      // Tap Sign Up
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();

      // Verify on SignUpPage
      expect(find.byType(SignUpPage), findsOneWidget);

      final signUpFields = find.byType(CommonTextField);
      expect(signUpFields, findsNWidgets(4));

      final submitSignUpBtn = find.widgetWithText(CommonButton, I18nKeys.signUp.tr);
      expect(submitSignUpBtn, findsOneWidget);

      // Submit with mismatching confirm password
      await tester.enterText(signUpFields.at(0), 'Listen');
      await tester.enterText(signUpFields.at(1), 'listen2code@gmail.com');
      await tester.enterText(signUpFields.at(2), 'password123');
      await tester.enterText(signUpFields.at(3), 'different');
      await tester.pumpAndSettle();

      await tester.ensureVisible(submitSignUpBtn);
      await tester.pumpAndSettle();
      await tester.tap(submitSignUpBtn);
      await tester.pumpAndSettle();
      expect(find.text(I18nKeys.passwordsDoNotMatch.tr), findsOneWidget);

      // Submit valid registration details
      await tester.enterText(signUpFields.at(3), 'password123');
      await tester.pumpAndSettle();

      // Dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      await tester.tap(submitSignUpBtn);
      await waitForPage(tester, LoginPage);

      // Verify redirect back to LoginPage
      expect(find.byType(LoginPage), findsOneWidget);
    });

    // ==========================================
    // CASE GROUP 4: Login & Home Navigation
    // ==========================================
    testWidgets('UI Test - Login and Home Navigation', (WidgetTester tester) async {
      await performUiLogin(tester, 'test_user', 'password123');

      // Verify we returned to HomePage
      expect(find.byType(HomePage), findsOneWidget);

      // Open Navigation Drawer to verify profile details
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Listen'), findsOneWidget);
      expect(find.text('listen2code@gmail.com'), findsOneWidget);

      // Close Drawer (tap outside)
      await tester.tapAt(const Offset(350, 300));
      await tester.pumpAndSettle();

      // Switch bottom tabs
      final aboutMeTab = find.byIcon(Icons.person);
      expect(aboutMeTab, findsOneWidget);
      await tester.tap(aboutMeTab);
      await tester.pumpAndSettle();

      // Verify AboutMe page & check Share action button
      final shareIcon = find.byIcon(Icons.share_outlined);
      expect(shareIcon, findsOneWidget);
      await tester.tap(shareIcon);
      await tester.pumpAndSettle();
    });

    // ==========================================
    // CASE GROUP 5: Settings Adjustments & Logout
    // ==========================================
    testWidgets('UI Test - Settings Adjustments and Logout', (WidgetTester tester) async {
      await navigateToSettings(tester);

      expect(find.byType(SettingsPage), findsOneWidget);

      // 1. Language switcher UI verification
      final languageTile = find.text(I18nKeys.language.tr);
      expect(languageTile, findsOneWidget);
      await tester.tap(languageTile);
      await tester.pumpAndSettle();

      // Select english language and confirm
      final englishOption = find.text('English');
      expect(englishOption, findsOneWidget);
      await tester.tap(englishOption);
      await tester.pumpAndSettle();

      // 2. Notifications switch toggle UI check
      final notificationTile = find.byIcon(Icons.notifications_none_rounded);
      expect(notificationTile, findsOneWidget);
      await tester.tap(notificationTile);
      await tester.pumpAndSettle();

      // 3. Clear cache UI check
      final clearCacheTile = find.text(I18nKeys.clearCache.tr);
      expect(clearCacheTile, findsOneWidget);
      await tester.tap(clearCacheTile);
      await tester.pumpAndSettle();

      // 4. Logout trigger via Drawer (since Logout button is in drawer footer)
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();

      final logoutBtn = find.text(I18nKeys.logout.tr);
      expect(logoutBtn, findsOneWidget);
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      // Tap Dialog OK button
      final okBtn = find.text(I18nKeys.ok.tr);
      expect(okBtn, findsOneWidget);
      await tester.tap(okBtn);
      await waitForPage(tester, LoginPage);

      // Verify redirected back to LoginPage
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}

class FakeIapService implements IIapService {
  @override
  Future<void> initialize() async {}

  @override
  Future<List<ProductDetails>> queryProducts(Set<String> productIds) async => [];

  @override
  Future<void> buyProduct(ProductDetails product) async {}

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => const Stream.empty();

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}
}

class FakeNotificationService implements INotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<String?> getToken() async => 'fake_fcm_token';

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Stream<NotificationPayload> get onMessageReceived => const Stream.empty();

  @override
  Stream<NotificationPayload> get onMessageOpenedApp => const Stream.empty();

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}
}
