import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

void main() {
  // Use Core.run to manage the app lifecycle, automatic crash logging, and global error handling.
  Core.run(
    () async {
      ProviderContainer container = ProviderContainer();
      await AppInitializer.init(container);
      runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
    },
    onAppError: (logPath, error, stack) async {
      if (logPath != null) {
        // CommonDialog now automatically retrieves context via AppNavConfig.
        final confirmed = await CommonDialog.showConfirm(
          tag: "globalErrorDialog",
          title: I18nKeys.appCrashed.tr,
          message: I18nKeys.crashDetectedMsg.tr,
          okText: I18nKeys.viewReport.tr,
          cancelText: I18nKeys.dismiss.tr,
        );
        if (confirmed == true) {
          AppNav.to(Routes.crashLogs, arguments: {Routes.argFilePath: logPath});
        }
      }
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingPage(
      builder: (context, child) {
        return BaseMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: kDebugMode,
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
        );
      },
    );
  }
}
