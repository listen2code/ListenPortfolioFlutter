import 'dart:async';

import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/shared.dart';
import '../../data/models/version_model.dart';
import '../provider/settings_provider.dart';
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
      checkUpdates: _onCheckUpdates,
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

  Future<void> _onCheckUpdates() async {
    await call(
      ref.execute<VersionModel, BaseParam>(checkUpdatesUseCaseProvider),
      showLoading: true,
      loadingMessage: I18nKeys.checkingUpdates.tr,
      onSuccess: (versionModel) async {
        await _handleVersionCheckResult(versionModel);
      },
      onFailure: (failure) {
        emitEffect(MessageEffect.error(I18nKeys.updateCheckFailed.tr));
      },
    );
  }

  Future<void> _handleVersionCheckResult(VersionModel versionModel) async {
    final currentVersion = Core.packageInfo.version;
    final hasUpdate = _isNewerVersion(currentVersion, versionModel.version);

    if (hasUpdate) {
      final localeCode = settingManager.language.locale.languageCode;
      final changelogText = versionModel.changelog[localeCode] ?? versionModel.changelog['en'] ?? '';

      final confirmed = await CommonDialog.showConfirm(
        title: I18nKeys.checkUpdates.tr,
        message: '${I18nKeys.updateAvailable.trArgs([versionModel.version])}\n\n$changelogText',
        okText: I18nKeys.update.tr,
      );
      if (confirmed == true) {
        final uri = Uri.parse(versionModel.url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } else {
      await CommonDialog.showMessage(
        title: I18nKeys.checkUpdates.tr,
        message: I18nKeys.latestVersion.tr,
      );
    }
  }

  bool _isNewerVersion(String current, String remote) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final remoteParts = remote.split('.').map(int.parse).toList();

      final length = currentParts.length > remoteParts.length ? currentParts.length : remoteParts.length;
      for (var i = 0; i < length; i++) {
        final currentVal = i < currentParts.length ? currentParts[i] : 0;
        final remoteVal = i < remoteParts.length ? remoteParts[i] : 0;

        if (remoteVal > currentVal) return true;
        if (currentVal > remoteVal) return false;
      }
    } catch (e) {
      return remote.compareTo(current) > 0;
    }
    return false;
  }
}
