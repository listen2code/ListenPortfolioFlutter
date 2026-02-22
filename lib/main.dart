import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/constants/app_env.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/core/utils/crash_manager.dart';
import 'package:listen_portfolio_flutter/core/utils/zone_manager.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:listen_portfolio_flutter/shared/base/base_auth_listenable_page.dart';
import 'package:listen_portfolio_flutter/shared/utils/quick_actions_manager.dart';
import 'package:listen_portfolio_flutter/shared/utils/routes.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_dialog.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_toast.dart';

import 'core/theme/app_theme.dart';

void main() {
  // Use runGuarded to wrap the entire app execution.
  // This ensures that all initialization and the app itself run in the same Zone.
  ZoneManager.runGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await AppEnv.init();
      QuickActionsManager.init();

      // Register auth, navigation, and named routes
      AppNavConfig.register(
        routes: Routes.routes,
        isGuest: () => authManager.state.isGuest,
        onLogin: (context) async {
          final result = await AppNav.to(Routes.login);
          return result == true;
        },
        onLoginSuccess: () {
          CommonToast.show("Login success!");
        },
        onShowLoginDialog: (context) async {
          final result = await CommonDialog.showConfirm(
            title: I18nKeys.loginLink.tr,
            message: I18nKeys.signInToContinue.tr,
          );
          return result == true;
        },
      );

      // Forward Flutter framework errors to the current Zone
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      };

      // Forward platform-level errors (like from binary messengers) to the current Zone
      PlatformDispatcher.instance.onError = (error, stack) {
        Zone.current.handleUncaughtError(error, stack);
        return true;
      };

      runApp(const ProviderScope(child: MyApp()));
    },
    traceId: ZoneManager.mainTraceId,
    onError: (error, stack) async {
      // 1. PERSIST CRASH DATA LOCALLY
      final filePath = await CrashManager.saveCrashLog(error, stack);

      // 2. Show a global crash alert dialog using the navigatorKey context
      final context = AppNavConfig.context;
      if (context != null && filePath != null) {
        CommonDialog.showConfirm(
          title: 'App Crashed',
          message: 'A crash has been detected and logged. Would you like to view the detailed report?',
          okText: 'View Report',
          cancelText: 'Dismiss',
        ).then((confirmed) {
          if (confirmed == true) {
            // 3. Navigate to the crash log list page and pass the file path to open it automatically
            AppNav.to(Routes.crashLogs, arguments: {Routes.argFilePath: filePath});
          }
        });
      }
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
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
          home: const SplashPage(),
        );
      },
    );
  }
}
