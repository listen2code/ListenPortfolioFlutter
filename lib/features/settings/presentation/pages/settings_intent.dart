import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../shared/shared.dart';

part 'settings_intent.freezed.dart';

@freezed
class SettingsIntent extends BaseIntent with _$SettingsIntent {
  const factory SettingsIntent.init() = _Init;
  const factory SettingsIntent.toggleNotifications(bool enabled) = _ToggleNotifications;
  const factory SettingsIntent.clearCache() = _ClearCache;
  const factory SettingsIntent.resetSettings() = _ResetSettings;
  const factory SettingsIntent.switchLanguage(AppLanguage language) = _SwitchLanguage;
  const factory SettingsIntent.switchEnv(AppEnvironment env) = _SwitchEnv;
  const factory SettingsIntent.toggleLogOverlay(bool enabled) = _ToggleLogOverlay;
  const factory SettingsIntent.checkUpdates() = _CheckUpdates;
  const factory SettingsIntent.buyMeCoffee() = _BuyMeCoffee;
  const factory SettingsIntent.showEnvDialog() = _ShowEnvDialog;
  const factory SettingsIntent.showLanguageDialog() = _ShowLanguageDialog;
  const SettingsIntent._();
}
