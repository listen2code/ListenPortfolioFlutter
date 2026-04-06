import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../shared/shared.dart';

part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState extends BaseState with _$SettingsState {
  const factory SettingsState({
    @Default('0 B') String cacheSize,
    @Default(true) bool notificationsEnabled,
    @Default(AppLanguage.chinese) AppLanguage currentLanguage,
    @Default(AppEnvironment.prod) AppEnvironment currentEnv,
    @Default(false) bool isLogOverlayShowing,
  }) = _SettingsState;
  const SettingsState._();
}
