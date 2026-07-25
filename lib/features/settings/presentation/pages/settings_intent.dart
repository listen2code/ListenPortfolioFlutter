import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/shared.dart';

part 'settings_intent.freezed.dart';

@freezed
class SettingsIntent extends BaseIntent with _$SettingsIntent {
  const factory SettingsIntent.init() = _Init;
  const factory SettingsIntent.toggleNotifications(bool enabled) = _ToggleNotifications;
  const factory SettingsIntent.clearCache() = _ClearCache;
  const factory SettingsIntent.resetSettings() = _ResetSettings;
  const factory SettingsIntent.confirmReset() = _ConfirmReset;
  const factory SettingsIntent.switchLanguage(AppLanguage language) = _SwitchLanguage;
  const factory SettingsIntent.switchEnv(AppEnvironment env) = _SwitchEnv;
  const factory SettingsIntent.toggleLogOverlay(bool enabled) = _ToggleLogOverlay;
  const factory SettingsIntent.checkUpdates() = _CheckUpdates;
  const factory SettingsIntent.buyMeCoffee() = _BuyMeCoffee;
  const factory SettingsIntent.showEnvDialog() = _ShowEnvDialog;
  const factory SettingsIntent.showLanguageDialog() = _ShowLanguageDialog;
  const factory SettingsIntent.shareApp() = _ShareApp;
  const factory SettingsIntent.enableDeveloperMode() = _EnableDeveloperMode;
  const factory SettingsIntent.rateApp() = _RateApp;
  const factory SettingsIntent.showLicenses() = _ShowLicenses;
  const factory SettingsIntent.toAppearance() = _ToAppearance;
  const factory SettingsIntent.toChangePassword() = _ToChangePassword;
  const factory SettingsIntent.toDeleteAccount() = _ToDeleteAccount;
  const factory SettingsIntent.toCrashLogs() = _ToCrashLogs;
  const factory SettingsIntent.toPrivacyPolicy() = _ToPrivacyPolicy;
  const factory SettingsIntent.toTermsOfService() = _ToTermsOfService;
  const factory SettingsIntent.toWebViewTest() = _ToWebViewTest;
  const factory SettingsIntent.confirmOpenSettings() = _ConfirmOpenSettings;
  const factory SettingsIntent.confirmDownloadUpdate(String url) = _ConfirmDownloadUpdate;

  const SettingsIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('SettingsIntent', 'init', (args) => const SettingsIntent.init());
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'toggleNotifications',
      (args) => SettingsIntent.toggleNotifications(args['enabled'] == 'true'),
    );
    MviPlaybackRegistry.register('SettingsIntent', 'clearCache', (args) => const SettingsIntent.clearCache());
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'resetSettings',
      (args) => const SettingsIntent.resetSettings(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'confirmReset',
      (args) => const SettingsIntent.confirmReset(),
    );
    MviPlaybackRegistry.register('SettingsIntent', 'switchLanguage', (args) {
      final langStr = args['language'] ?? '';
      final lang = AppLanguage.values.firstWhere(
        (e) => e.toString().split('.').last == langStr || e.toString() == langStr,
        orElse: () => AppLanguage.english,
      );
      return SettingsIntent.switchLanguage(lang);
    });
    MviPlaybackRegistry.register('SettingsIntent', 'switchEnv', (args) {
      final envStr = args['env'] ?? '';
      final env = AppEnvironment.values.firstWhere(
        (e) => e.toString().split('.').last == envStr || e.toString() == envStr,
        orElse: () => AppEnvironment.mock,
      );
      return SettingsIntent.switchEnv(env);
    });
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'toggleLogOverlay',
      (args) => SettingsIntent.toggleLogOverlay(args['enabled'] == 'true'),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'checkUpdates',
      (args) => const SettingsIntent.checkUpdates(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'buyMeCoffee',
      (args) => const SettingsIntent.buyMeCoffee(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'showEnvDialog',
      (args) => const SettingsIntent.showEnvDialog(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'showLanguageDialog',
      (args) => const SettingsIntent.showLanguageDialog(),
    );
    MviPlaybackRegistry.register('SettingsIntent', 'shareApp', (args) => const SettingsIntent.shareApp());
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'enableDeveloperMode',
      (args) => const SettingsIntent.enableDeveloperMode(),
    );
    MviPlaybackRegistry.register('SettingsIntent', 'rateApp', (args) => const SettingsIntent.rateApp());
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'showLicenses',
      (args) => const SettingsIntent.showLicenses(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'toAppearance',
      (args) => const SettingsIntent.toAppearance(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'toChangePassword',
      (args) => const SettingsIntent.toChangePassword(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'toDeleteAccount',
      (args) => const SettingsIntent.toDeleteAccount(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'toCrashLogs',
      (args) => const SettingsIntent.toCrashLogs(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'toPrivacyPolicy',
      (args) => const SettingsIntent.toPrivacyPolicy(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'toTermsOfService',
      (args) => const SettingsIntent.toTermsOfService(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'toWebViewTest',
      (args) => const SettingsIntent.toWebViewTest(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'confirmOpenSettings',
      (args) => const SettingsIntent.confirmOpenSettings(),
    );
    MviPlaybackRegistry.register(
      'SettingsIntent',
      'confirmDownloadUpdate',
      (args) => SettingsIntent.confirmDownloadUpdate(args['url'] ?? ''),
    );
  }
}
