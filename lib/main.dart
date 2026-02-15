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
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:listen_portfolio_flutter/shared/base/base_auth_listenable_page.dart';
import 'package:listen_portfolio_flutter/shared/utils/snack_bar_util.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_dialog.dart';

import 'core/theme/app_theme.dart';

/// Global RouteObserver to track page visibility changes.
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppEnv.init();

  // Register auth and navigation logic to the core interceptor
  AppNavConfig.register(
    isGuest: () => authManager.state.isGuest,
    // The actual login navigation logic
    onLogin: (context) async {
      final result = await AppNav.to(const LoginPage());
      return result == true;
    },
    // Global feedback after successful authentication
    onLoginSuccess: () {
      SnackBarUtil.show("Login success!");
    },
    // Registration of the "Login Required" confirmation dialog
    onShowLoginDialog: (context) async {
      final result = await CommonDialog.showConfirm(
        title: I18nKeys.loginLink.tr,
        message: I18nKeys.signInToContinue.tr,
      );
      return result == true;
    },
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: AppNavConfig.navigatorKey,
          scaffoldMessengerKey: SnackBarUtil.messengerKey,
          navigatorObservers: [routeObserver],
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
