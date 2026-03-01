import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  final container = ProviderContainer();
  // Use runGuarded to wrap the entire app execution.
  // This ensures that all initialization and the app itself run in the same Zone.
  ZoneManager.runGuarded(
    () async {
      await AppInitializer.init(container);
      runApp(UncontrolledProviderScope(container: container, child: MyApp()));
    },
    traceId: ZoneManager.mainTraceId,
    label: ZoneManager.mainStart,
    onError: AppInitializer.handleGlobalError,
  );
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
