import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

/// A central class to handle all application-wide initializations.
/// This acts as the 'Composition Root' where core interfaces are tied to shared implementations.
class AppInitializer {
  AppInitializer._();

  /// Executes all initialization steps in order.
  static Future<void> init() async {
    await _initServices();
    _setupErrorHandlers();
  }

  /// Initializes infrastructure, core providers, and global managers.
  static Future<void> _initServices() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Infrastructure (Shared Preferences)
    await SpUtil.init(prefix: "${AppConstants.appName}_");

    // 2. Core Architecture Capability Registry
    ProviderRegistry.setup([
      const LoadingProviderImpl(),
      const MessageProviderImpl(),
      const NavigationProviderImpl(),
    ]);

    // 3. Crash Protection (Safe Mode) Configuration
    CrashManager.setup(
      SafeModeConfig(
        onReset: () async {
          await CacheManager.clearAllCache();
          await settingManager.resetSettings();
          AppNav.offAll(Routes.home);
          CommonToast.show(I18nKeys.safetyResetMsg.tr, type: ToastType.error);
        },
      ),
    );

    // 4. Environment Configuration
    await AppEnv.init(EnvConfigs.values);

    // 5. Localization & Translation Engine
    Translations.register(
      data: {AppLanguage.chinese.locale.languageCode: zh, AppLanguage.japanese.locale.languageCode: ja},
      languageCodeProvider: () => settingManager.locale.languageCode,
    );

    // 6. Global Managers Initialization
    QuickActionsManager.init();
    settingManager.loadSettings();

    // 7. UIKit Styling & Internationalization
    UIKitConfig.setup(stringProvider: (key) => key.tr);

    // 8. Registers global navigation interceptors and auth redirects.
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

  /// Configures global error capturing for both Flutter and Platform errors.
  static void _setupErrorHandlers() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      Zone.current.handleUncaughtError(details, details.stack!);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      Zone.current.handleUncaughtError(error, stack);
      return true;
    };
  }

  /// Standardized global error handler for the Zone.
  static Future<void> handleGlobalError(Object error, StackTrace stack) async {
    // 1. PERSIST CRASH DATA LOCALLY
    final filePath = await CrashManager.saveCrashLog(error, stack);

    // 2. Show a singleton global crash alert dialog
    final context = AppNavConfig.context;
    if (context != null && filePath != null) {
      final confirmed = await CommonDialog.showConfirm(
        tag: "globalErrorDialog",
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
}
