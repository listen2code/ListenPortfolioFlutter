import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'features/settings/presentation/provider/playback_provider.dart';
import 'features/settings/data/models/playback_tape_metadata.dart';
import 'shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'features/ai_chat/presentation/pages/global_ai_chat_overlay.dart';

void main() {
  LaunchMonitor.recordMainStart();
  // Use Core.run to manage the app lifecycle, automatic crash logging, and global error handling.
  Core.run(
    () async {
      final ProviderContainer container = ProviderContainer();
      await AppInitializer.init(container);

      // Wire up the delegate to persist recorded tapes using settings repository
      MviPlaybackRecorder.saveTapeDelegate = (tapeKey, steps, name, timestamp) async {
        final repository = container.read(playbackTapeRepositoryProvider);
        final metadata = PlaybackTapeMetadata(
          key: tapeKey,
          name: name,
          timestamp: timestamp,
          steps: steps.length,
        );
        final result = await repository.saveTape(tapeKey, steps, metadata);
        result.fold(
          (failure) => appLogger.e('Failed to save tape from delegate: ${failure.message}'),
          (_) => null,
        );
      };

      runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
    },
    onAppError: (logPath, error, stack) async {
      if (logPath != null) {
        // CommonDialog now automatically retrieves context via AppNavConfig.
        final confirmed = await CommonDialog.showConfirm(
          tag: 'globalErrorDialog',
          title: I18nKeys.appCrashed.tr,
          message: I18nKeys.crashDetectedMsg.tr,
          okText: I18nKeys.viewReport.tr,
          cancelText: I18nKeys.dismiss.tr,
        );
        if (confirmed == true) {
          AppNav.to(Routes.crashLogs, arguments: CrashLogListArguments(filePath: logPath));
        }
      }
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LaunchMonitor.recordFirstFrame();
    });
    return BaseSettingPage(
      builder: (context, child) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            final useDynamic = settingManager.useDynamicColor;
            return BaseMaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: kDebugMode,
              theme: AppTheme.getLightTheme(
                settingManager,
                dynamicColorScheme: useDynamic ? lightDynamic : null,
              ),
              darkTheme: AppTheme.getDarkTheme(
                settingManager,
                dynamicColorScheme: useDynamic ? darkDynamic : null,
              ),
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
              builder: (context, child) {
                return GlobalAiChatOverlay(child: child!);
              },
            );
          },
        );
      },
    );
  }
}
