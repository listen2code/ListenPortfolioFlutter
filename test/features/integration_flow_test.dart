import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/main.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../test_helpers/test_setup.dart';

class _MapMockAdapter implements HttpClientAdapter {
  final Map<String, dynamic> _responses = {};

  void register(String path, dynamic data) {
    _responses[path] = data;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.path;
    if (_responses.containsKey(path)) {
      return ResponseBody.fromString(
        jsonEncode(_responses[path]),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    throw DioException(
      requestOptions: options,
      message: 'No mock response for $path',
      type: DioExceptionType.unknown,
    );
  }

  @override
  void close({bool force = false}) {}
}

class DummyDeviceInfo implements IDeviceInfo {
  @override
  String get deviceId => 'dummy_device_id';

  @override
  String get model => 'dummy_model';

  @override
  String get version => '1.0.0';

  @override
  String get platform => 'android';

  @override
  Map<String, String> toHeaderMap() {
    return {
      'X-Device-ID': deviceId,
      'X-Device-Model': model,
      'X-Device-Version': version,
      'X-Platform': platform,
    };
  }
}

class DummyPackageInfo implements IPackageInfo {
  @override
  String get appName => 'dummy_app';

  @override
  String get packageName => 'com.dummy.app';

  @override
  String get version => '1.0.0';

  @override
  String get buildNumber => '1';

  @override
  String get fullVersion => '1.0.0+1';

  @override
  Map<String, String> toHeaderMap() {
    return {'X-App-Version': version, 'X-App-Build': buildNumber, 'X-App-Package': packageName};
  }
}

class _ApiAuthHandlerImpl implements IApiInterceptorDelegate {
  final ProviderContainer container;

  _ApiAuthHandlerImpl(this.container);

  @override
  Future<bool> onRefreshToken() async {
    try {
      final repository = await container.read(authRepositoryProvider.future);
      final result = await repository.refreshToken();
      return result.isRight();
    } catch (e) {
      appLogger.e('AppInitializer: Failed to bridge token refresh: $e');
      return false;
    }
  }

  @override
  Future<void> onInjectAuthHeader(RequestOptions options) async {
    final token = await SecureStorageUtil.get(AppConstants.authTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  @override
  void onInjectTraceHeader(RequestOptions options, String traceId) {
    options.headers['X-Trace-Id'] = traceId;
  }

  @override
  void onInjectCommonHeaders(RequestOptions options) {
    options.headers['Accept-Language'] = 'en';
  }
}

class TestAppInitializer {
  TestAppInitializer._();

  static Future<void> init(ProviderContainer container) async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      Core.deviceInfo = DummyDeviceInfo();
    } catch (_) {}
    try {
      Core.packageInfo = DummyPackageInfo();
    } catch (_) {}

    // 2. Setup Storage
    final String storagePrefix = "${AppConstants.appName}_";
    await SpUtil.init(prefix: storagePrefix);
    await SecureStorageUtil.init(prefix: storagePrefix);

    // 3. Setup Event Bus
    eventBus.init(onEventFired: (event) => appLogger.d('EventBus: [FIRE] -> $event'));

    // 4. Setup Provider Registry
    ProviderRegistry.init([
      const LoadingProviderImpl(),
      const MessageProviderImpl(),
      const NavigationProviderImpl(),
      LogoutProviderImpl(container),
      const ShareProviderImpl(),
      const ConfirmProviderImpl(),
      const ShowTapeDetailsProviderImpl(),
    ]);

    // 5. Setup Network Client
    ApiClient.init(_ApiAuthHandlerImpl(container));
    ApiClient.initNetworkConfig(
      NetworkConfig(
        visitorPaths: [
          '/v1/auth/signUp',
          '/v1/auth/login',
          '/v1/auth/forgot-password',
          '/v1/auth/refresh',
          '/v1/projects',
        ],
      ),
    );
    BaseResponseModel.initConfig(const ResponseConfig());

    // 6. Setup Crash Protection
    CrashManager.init(
      SafeModeConfig(
        onReset: () async {
          await settingManager.resetSettings();
          AppNav.offAll(Routes.home);
        },
      ),
    );
    CrashManager.initStorageConfig(const StorageConfig());

    // 7. Setup Environment
    try {
      await AppEnv.init(EnvConfigs.values);
    } catch (_) {
      // Avoid duplicate initialization error in tests
    }

    // 8. Setup Localization
    Translations.register(
      data: {AppLanguage.chinese.locale.languageCode: zh, AppLanguage.japanese.locale.languageCode: ja},
      languageCodeProvider: () => settingManager.locale.languageCode,
    );

    // 9. Setup Navigation Config
    AppNavConfig.register(
      routes: Routes.routes,
      isGuest: () => authManager.state.isGuest,
      onLogin: (context) async {
        final result = await AppNav.to(Routes.login);
        return result == true;
      },
      onLoginSuccess: () => CommonToast.show(I18nKeys.loginSuccess.tr),
      onShowLoginDialog: (context) async {
        final result = await CommonDialog.showConfirm(
          title: I18nKeys.loginLink.tr,
          message: I18nKeys.signInToContinue.tr,
        );
        return result == true;
      },
    );

    // 10. Shared Layer Services Initialization
    QuickActionsManager.init();
    settingManager.loadSettings();
    UIKitConfig.init(stringProvider: (key) => key.tr);
    shorebirdService = ShorebirdServiceImpl();
  }
}

void main() {
  setUpAll(() async {
    // 1. Initialize global environments (Mock and Test env configs)
    await setupTestEnvironment();
  });

  setUp(() async {
    // 2. Clear and set mock initial values for SharedPreferences (SpUtil wrapper)
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();

    // Mock the plugins.it_nomads.com/flutter_secure_storage channel to prevent secure storage hanging in tests
    final Map<String, String> secureStorageValues = {};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (MethodCall call) async {
            final args = call.arguments as Map?;
            if (call.method == 'write') {
              if (args != null) {
                secureStorageValues[args['key'] as String] = args['value'] as String;
              }
              return null;
            } else if (call.method == 'read') {
              return args != null ? secureStorageValues[args['key'] as String] : null;
            } else if (call.method == 'delete') {
              if (args != null) {
                secureStorageValues.remove(args['key'] as String);
              }
              return null;
            } else if (call.method == 'deleteAll') {
              secureStorageValues.clear();
              return null;
            }
            return null;
          },
        );

    // 3. Prevent visibility animations from lagging and blocking pumpAndSettle
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    // Read projects, user, and aboutMe json files directly from local mock assets
    final userJson = jsonDecode(File('assets/mock/v1/get/user.json').readAsStringSync());
    final projectsJson = jsonDecode(File('assets/mock/v1/get/projects.json').readAsStringSync());
    final aboutMeJson = jsonDecode(File('assets/mock/v1/get/aboutMe.json').readAsStringSync());

    final loginJson = jsonDecode(File('assets/mock/v1/post/auth/login.json').readAsStringSync());
    final logoutJson = jsonDecode(File('assets/mock/v1/post/user/logout.json').readAsStringSync());

    // Intercept network requests via _MapMockAdapter for test stability
    final mockAdapter = _MapMockAdapter()
      ..register('/v1/user', userJson)
      ..register('/v1/projects', projectsJson)
      ..register('/v1/aboutMe', aboutMeJson)
      ..register('/v1/auth/login', loginJson)
      ..register('/v1/user/logout', logoutJson);
    ApiClient.dio.httpClientAdapter = mockAdapter;
  });

  group('Mock E2E Integration Flow Tests', () {
    testWidgets(
      'Should successfully boot into SplashPage, delay 2 seconds, transition to HomePage, open Drawer, navigate to SettingsPage and return',
      (WidgetTester tester) async {
        // 1. Initialize Composition Root dependencies with Riverpod Container
        final container = ProviderContainer();
        await TestAppInitializer.init(container);

        // 2. Boot the entire App widget tree
        await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const MyApp()));

        // 3. First frame must render SplashPage
        await tester.pump();
        expect(find.byType(SplashPage), findsOneWidget);
        expect(find.text(AppConstants.appName), findsOneWidget);

        // 4. Pump simulated delay of 2 seconds (matches SplashViewModel artificial delay)
        await tester.pump(const Duration(seconds: 2));
        // Settle the routing slide transition animations completely
        await tester.pumpAndSettle();

        // 5. Verify transition completed into HomePage
        expect(find.byType(HomePage), findsOneWidget);

        // 6. Open Navigation Drawer using ScaffoldState
        final ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        // 7. Verify core user information is correctly fetched and bound from user.json
        // AppConstants.author holds "Listen", verifying name is rendered.
        expect(find.text(AppConstants.author), findsWidgets);

        // 8. Locate Settings menu option from Drawer via internationalization keys
        final settingsMenuOption = find.text(I18nKeys.settings.tr);
        expect(settingsMenuOption, findsOneWidget);

        // 9. Tap on Settings option and wait for navigation transition
        await tester.tap(settingsMenuOption);
        await tester.pumpAndSettle();

        // 10. Verify we are now on the SettingsPage
        expect(find.byType(SettingsPage), findsOneWidget);

        // 11. Tap default Page Back button to return to HomePage
        await tester.pageBack();
        await tester.pumpAndSettle();

        // 12. Verify we returned successfully to the HomePage
        expect(find.byType(HomePage), findsOneWidget);
      },
    );

    testWidgets(
      'Should successfully log in from guest mode, update drawer profile, and log out',
      (WidgetTester tester) async {
        // 1. Initialize Composition Root dependencies with Riverpod Container
        final container = ProviderContainer();
        await TestAppInitializer.init(container);

        // 2. Boot the entire App widget tree
        await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const MyApp()));

        // 3. First frame must render SplashPage
        await tester.pump();
        expect(find.byType(SplashPage), findsOneWidget);

        // 4. Pump simulated delay of 2 seconds (Splash screen delay)
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // 5. Verify transition completed into HomePage
        expect(find.byType(HomePage), findsOneWidget);

        // 6. Open Navigation Drawer using ScaffoldState
        final ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        // 7. Verify we are guest and the login button is visible at the bottom of the drawer
        final loginDrawerOption = find.text(I18nKeys.login.tr);
        expect(loginDrawerOption, findsOneWidget);

        // 8. Click "Login" in drawer and verify navigating to LoginPage
        await tester.tap(loginDrawerOption, warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.byType(LoginPage), findsOneWidget);

        // 9. Input username and password
        final textFields = find.byType(CommonTextField);
        expect(textFields, findsNWidgets(2));
        
        final usernameFinder = textFields.at(0);
        final passwordFinder = textFields.at(1);
        
        await tester.enterText(usernameFinder, 'test_user');
        await tester.enterText(passwordFinder, 'password123');
        await tester.pumpAndSettle();

        // 10. Tap on "Login" button to submit form
        final submitButton = find.text(I18nKeys.login.tr);
        expect(submitButton, findsOneWidget);
        await tester.tap(submitButton);

        // Wait for login request and loader transition
        await tester.pump(); // Start loading
        await tester.pump(const Duration(milliseconds: 100)); // Process network
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));

        // 11. Verify we returned successfully to the HomePage
        expect(find.byType(HomePage), findsOneWidget);

        // Dismiss the login success toast to avoid pumpAndSettle timer timeout
        CommonToast.hide();

        // 12. Open Navigation Drawer again to verify user details updated
        final ScaffoldState scaffoldStateAfterLogin = tester.firstState(find.byType(Scaffold));
        scaffoldStateAfterLogin.openDrawer();
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        // 13. Verify profile info matches name/email from login.json or user.json
        expect(find.text('Listen'), findsOneWidget);
        expect(find.text('listen2code@gmail.com'), findsOneWidget);

        // 14. Verify bottom button in drawer now shows "Logout" instead of "Login"
        final logoutDrawerOption = find.text(I18nKeys.logout.tr);
        expect(logoutDrawerOption, findsOneWidget);

        // 15. Tap "Logout" to initiate logout flow
        await tester.tap(logoutDrawerOption);
        await tester.pumpAndSettle(); // Settle confirm dialog rendering

        // 16. Tap confirmation "OK" button
        final okButton = find.text(I18nKeys.ok.tr);
        expect(okButton, findsOneWidget);
        await tester.tap(okButton);
        
        // Wait for logout request and loader transition
        await tester.pump(); // Start loading
        await tester.pump(const Duration(milliseconds: 100)); // Process network
        await tester.pumpAndSettle(); // Settle logout transition to LoginPage (since logout effect redirects to Login)

        // 17. Verify we are redirected to LoginPage after logout
        expect(find.byType(LoginPage), findsOneWidget);

        // 18. Clean up any remaining Toast timers
        await tester.pump(const Duration(seconds: 3));
      },
    );
  });
}
