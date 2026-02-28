import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

void main() {
  // Use runGuarded to wrap the entire app execution.
  // This ensures that all initialization and the app itself run in the same Zone.
  ZoneManager.runGuarded(
    () async {
      await _initServices();
      _setupNavConfig();
      _setupErrorHandlers();

      runApp(const ProviderScope(child: MyApp()));
    },
    traceId: ZoneManager.mainTraceId,
    label: ZoneManager.mainStart,
    onError: _handleGlobalError,
  );
}

Future<void> _initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Infrastructure
  await SpUtil.init(prefix: "${AppConstants.appName}_");

  // 2. Core Architecture DI Injection
  // Registers all global provider implementations at once.
  ProviderRegistry.setup([LoadingProviderImpl(), MessageProviderImpl(), NavigationProviderImpl()]);

  // 3. Environment Configuration
  AppEnv.setup({
    AppEnvironment.mock: BizEnvConfigs.mock,
    AppEnvironment.dev: BizEnvConfigs.dev,
    AppEnvironment.test: BizEnvConfigs.test,
    AppEnvironment.prod: BizEnvConfigs.prod,
  });
  await AppEnv.init();

  // 4. Localization
  Translations.register(
    data: {'en': en, 'zh': zh, 'ja': ja},
    languageCodeProvider: () => settingManager.locale.languageCode,
  );

  // 5. Global Managers & Settings
  QuickActionsManager.init();
  settingManager.loadSettings();

  // 6. UIKit Configuration (Depends on Localization system)
  UIKitConfig.setup(stringProvider: (key) => key.tr);
}

// Register auth, navigation, and named routes
void _setupNavConfig() {
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
}

void _setupErrorHandlers() {
  // Forward Flutter framework errors to the current Zone
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Zone.current.handleUncaughtError(details, details.stack!);
  };

  // Forward platform-level errors (like from binary messengers) to the current Zone
  PlatformDispatcher.instance.onError = (error, stack) {
    Zone.current.handleUncaughtError(error, stack);
    return true;
  };
}

Future<void> _handleGlobalError(Object error, StackTrace stack) async {
  // 1. PERSIST CRASH DATA LOCALLY
  final filePath = await CrashManager.saveCrashLog(error, stack);

  // 2. Show a global crash alert dialog using the navigatorKey context
  final context = AppNavConfig.context;
  if (context != null && filePath != null) {
    final confirmed = await CommonDialog.showConfirm(
      title: I18nKeys.appCrashed.tr,
      message: I18nKeys.crashDetectedMsg.tr,
      okText: I18nKeys.viewReport.tr,
      cancelText: I18nKeys.dismiss.tr,
    );

    if (confirmed == true) {
      AppNav.to(Routes.crashLogs, arguments: {Routes.argFilePath: filePath});
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingPage(
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: AppNavConfig.navigatorKey,
          navigatorObservers: [AppNav.observer],
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getLightTheme(settingManager),
          darkTheme: AppTheme.getDarkTheme(settingManager),
          themeMode: settingManager.themeMode,
          locale: settingManager.locale,
          supportedLocales: [
            AppLanguage.english.locale,
            AppLanguage.chinese.locale,
            AppLanguage.japanese.locale,
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Use initialRoute instead of home to ensure the first page (SplashPage)
          // also passes through AppNav.onGenerateRoute and ZoneManager.runPage.
          initialRoute: Routes.root,
          onGenerateRoute: AppNav.onGenerateRoute,
        );
      },
    );
  }
}
