import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_intent.dart';
import 'settings_state.dart';

part 'settings_view_model.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel with ViewModelMixin<SettingsState, SettingsIntent> {
  @override
  SettingsState build() {
    return SettingsState(
      currentLanguage: settingManager.language,
      currentEnv: AppEnv.currentEnv,
      notificationsEnabled: true,
      isLogOverlayShowing: LogOverlayManager.isShowing,
    );
  }

  @override
  void onInit() {
    handleIntent(const SettingsIntent.init());
  }

  @override
  FutureOr<void> onIntent(SettingsIntent intent) {
    return intent.when<FutureOr<void>>(
      init: _onInit,
      toggleNotifications: _onToggleNotifications,
      clearCache: _onClearCache,
      resetSettings: _onResetSettings,
      switchLanguage: _onSwitchLanguage,
      switchEnv: _onSwitchEnv,
      toggleLogOverlay: _onToggleLogOverlay,
    );
  }

  Future<void> _onInit() async {
    await _updateCacheSize();
  }

  Future<void> _updateCacheSize() async {
    final size = await CacheManager.getCacheSize();
    updateState(state.copyWith(cacheSize: size));
  }

  void _onToggleNotifications(bool enabled) {
    updateState(state.copyWith(notificationsEnabled: enabled));
  }

  Future<void> _onClearCache() async {
    // todo effect
    emitEffect(LoadingEffect(true));
    await CacheManager.clearAllCache();
    await _updateCacheSize();
    emitEffect(LoadingEffect(false));
    emitEffect(MessageEffect.info(I18nKeys.cacheCleared.tr));
  }

  Future<void> _onResetSettings() async {
    // todo exception
    emitEffect(LoadingEffect(true));
    try {
      await settingManager.resetSettings();
      await _updateCacheSize();
      // Even if disposed, this will now be handled globally and logged.
      emitEffect(MessageEffect.info(I18nKeys.settingsResetSuccess.tr));
    } finally {
      emitEffect(LoadingEffect(false));
    }
  }

  Future<void> _onSwitchLanguage(AppLanguage language) async {
    await settingManager.setLanguage(language);
    updateState(state.copyWith(currentLanguage: language));
  }

  Future<void> _onSwitchEnv(AppEnvironment env) async {
    await AppEnv.setEnvironment(env);
    updateState(state.copyWith(currentEnv: env));
  }

  void _onToggleLogOverlay(bool enabled) {
    updateState(state.copyWith(isLogOverlayShowing: enabled));
  }
}
