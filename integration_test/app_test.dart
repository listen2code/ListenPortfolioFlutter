import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:integration_test/integration_test.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_page.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:listen_portfolio_flutter/main.dart' as app;
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Prevent visibility animations from lagging and blocking pumpAndSettle
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    // Pre-initialize iapService to prevent native channel hangs during tests
    iapService = FakeIapService();

    // Reassign notificationService to prevent native notification permission dialog hangs
    notificationService = FakeNotificationService();

    // Configure LocalMockServer with very low latency for fast, race-free tests
    LocalMockServer.initConfig(const MockServerConfig(networkLatency: Duration(milliseconds: 10)));
  });

  group('E2E App Integration Tests', () {
    testWidgets(
      'Should successfully execute sequential flow: Splash -> Home -> Settings -> Forgot Password -> Sign Up -> Login -> Profile Check -> Logout',
      (WidgetTester tester) async {
        // ==========================================
        // FLOW 1: Boot App (Splash -> Home)
        // ==========================================
        app.main();
        await tester.pumpAndSettle();

        // Verify SplashPage is rendering
        expect(find.byType(SplashPage), findsOneWidget);

        // Wait for Splash 2s delay
        await tester.pump(const Duration(milliseconds: 2500));
        await tester.pumpAndSettle();

        // Verify we transitioned to HomePage
        expect(find.byType(HomePage), findsOneWidget);

        // ==========================================
        // FLOW 2: Open Drawer -> Navigate to Login
        // ==========================================
        // Open Navigation Drawer
        final ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        final loginDrawerOption = find.text(I18nKeys.login.tr);
        expect(loginDrawerOption, findsOneWidget);

        await tester.tap(loginDrawerOption);
        await tester.pumpAndSettle();

        // Verify on LoginPage
        expect(find.byType(LoginPage), findsOneWidget);

        // ==========================================
        // FLOW 3: Forgot Password Flow
        // ==========================================
        final forgotPasswordBtn = find.text(I18nKeys.forgotPassword.tr);
        expect(forgotPasswordBtn, findsOneWidget);

        // Tap Forgot Password
        await tester.tap(forgotPasswordBtn);
        await tester.pumpAndSettle();

        // Verify on ForgotPasswordPage
        expect(find.byType(ForgotPasswordPage), findsOneWidget);

        final forgotEmailField = find.byType(CommonTextField);
        expect(forgotEmailField, findsOneWidget);

        final sendResetBtn = find.text(I18nKeys.sendResetLink.tr);
        expect(sendResetBtn, findsOneWidget);

        // ABNORMAL 1: Empty input and submit
        await tester.enterText(forgotEmailField, '');
        await tester.pumpAndSettle();
        await tester.ensureVisible(sendResetBtn);
        await tester.pumpAndSettle();
        await tester.tap(sendResetBtn);
        await tester.pumpAndSettle();
        // Expect "Field required" validation error
        expect(find.text(I18nKeys.fieldRequired.tr), findsOneWidget);

        // ABNORMAL 2: Invalid email format and submit
        await tester.enterText(forgotEmailField, 'invalid-email');
        await tester.pumpAndSettle();
        await tester.tap(sendResetBtn);
        await tester.pumpAndSettle();
        // Expect "Invalid email address" validation error
        expect(find.text(I18nKeys.invalidEmail.tr), findsOneWidget);

        // NORMAL FLOW: Enter valid email and submit successfully
        await tester.enterText(forgotEmailField, 'test_user@gmail.com');
        await tester.pumpAndSettle();

        // Dismiss keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        await tester.tap(sendResetBtn);
        // Wait for real-time local network request and transition to LoginPage
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // Verify redirect back to LoginPage
        expect(find.byType(LoginPage), findsOneWidget);

        // ==========================================
        // FLOW 4: Sign Up / Register Flow
        // ==========================================
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

        // ABNORMAL 1: Submit with all fields empty
        await tester.enterText(signUpFields.at(0), '');
        await tester.enterText(signUpFields.at(1), '');
        await tester.enterText(signUpFields.at(2), '');
        await tester.enterText(signUpFields.at(3), '');
        await tester.pumpAndSettle();

        await tester.ensureVisible(submitSignUpBtn);
        await tester.pumpAndSettle();
        await tester.tap(submitSignUpBtn);
        await tester.pumpAndSettle();
        // Expect multiple "Field required" errors visible
        expect(find.text(I18nKeys.fieldRequired.tr), findsAtLeastNWidgets(2));

        // ABNORMAL 2: Submit with invalid email, too short password, and mismatched confirm password
        await tester.enterText(signUpFields.at(0), 'Listen');
        await tester.enterText(signUpFields.at(1), 'invalid-email');
        await tester.enterText(signUpFields.at(2), '123');
        await tester.enterText(signUpFields.at(3), 'different');
        await tester.pumpAndSettle();

        await tester.tap(submitSignUpBtn);
        await tester.pumpAndSettle();
        // Expect specific validation errors
        expect(find.text(I18nKeys.invalidEmail.tr), findsOneWidget);
        expect(find.text(I18nKeys.minLengthMsg.trArgs(['6'])), findsOneWidget);
        expect(find.text(I18nKeys.passwordsDoNotMatch.tr), findsOneWidget);

        // NORMAL FLOW: Enter valid registration details and submit successfully
        await tester.enterText(signUpFields.at(0), 'Listen');
        await tester.enterText(signUpFields.at(1), 'listen2code@gmail.com');
        await tester.enterText(signUpFields.at(2), 'password123');
        await tester.enterText(signUpFields.at(3), 'password123');
        await tester.pumpAndSettle();

        // Dismiss keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        await tester.tap(submitSignUpBtn);
        // Wait for real-time local network request and transition to LoginPage
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // Verify redirect back to LoginPage
        expect(find.byType(LoginPage), findsOneWidget);

        // ==========================================
        // FLOW 5: Login Flow
        // ==========================================
        final loginFields = find.byType(CommonTextField);
        expect(loginFields, findsNWidgets(2));

        final submitLoginBtn = find.widgetWithText(CommonButton, I18nKeys.login.tr);
        expect(submitLoginBtn, findsOneWidget);

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

        // NORMAL FLOW: Enter valid credentials and login
        await tester.enterText(loginFields.at(0), 'test_user');
        await tester.enterText(loginFields.at(1), 'password123');
        await tester.pumpAndSettle();

        // Dismiss keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        await tester.tap(submitLoginBtn);
        // Wait for real-time local network request and transition to HomePage
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // Verify we returned to HomePage
        expect(find.byType(HomePage), findsOneWidget);

        // ==========================================
        // FLOW 6: Verify Profile & Logout
        // ==========================================
        // Open Navigation Drawer again to verify details
        final ScaffoldState scaffoldStateAfterLogin = tester.firstState(find.byType(Scaffold));
        scaffoldStateAfterLogin.openDrawer();
        await tester.pumpAndSettle();

        // Verify dynamic profile info updated
        expect(find.text('Listen'), findsOneWidget);
        expect(find.text('listen2code@gmail.com'), findsOneWidget);

        // Tap Logout option
        final logoutDrawerOption = find.text(I18nKeys.logout.tr);
        expect(logoutDrawerOption, findsOneWidget);
        await tester.tap(logoutDrawerOption);
        await tester.pumpAndSettle(); // Settle confirmation dialog

        // Tap dialog OK button
        final okButton = find.text(I18nKeys.ok.tr);
        expect(okButton, findsOneWidget);
        await tester.tap(okButton);
        // Wait for real-time local network request and transition back to LoginPage
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // Verify redirect to LoginPage
        expect(find.byType(LoginPage), findsOneWidget);

        // Clean up remaining Toast timers
        await tester.pump(const Duration(seconds: 3));
      },
    );
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
