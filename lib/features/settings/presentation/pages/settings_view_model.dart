import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      notificationsEnabled: SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true),
      isLogOverlayShowing: LogOverlayManager.isShowingNotifier.value,
      isDeveloperMode: SpUtil.getBool(AppConstants.developerModeKey, defaultValue: false),
    );
  }

  @override
  void onInit() {
    super.onInit();
    handleIntent(const SettingsIntent.init());
    LogOverlayManager.isShowingNotifier.addListener(_onLogOverlayShowingChanged);
  }

  @override
  void onDispose() {
    LogOverlayManager.isShowingNotifier.removeListener(_onLogOverlayShowingChanged);
    super.onDispose();
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
      buyMeCoffee: _onBuyMeCoffee,
      showEnvDialog: _onShowEnvDialog,
      showLanguageDialog: _onShowLanguageDialog,
      shareApp: _onShareApp,
      enableDeveloperMode: _onEnableDeveloperMode,
      rateApp: _onRateApp,
      showLicenses: _onShowLicenses,
      toAppearance: () => emitEffect(NavigationEffect(target: Routes.appearance)),
      toChangePassword: () => emitEffect(NavigationEffect(target: Routes.changePassword, needLogin: true)),
      toDeleteAccount: () => emitEffect(NavigationEffect(target: Routes.deleteAccount, needLogin: true)),
      toCrashLogs: () => emitEffect(NavigationEffect(target: Routes.crashLogs)),
      toPrivacyPolicy: () => emitEffect(NavigationEffect(target: Routes.privacyPolicy)),
      toTermsOfService: () => emitEffect(NavigationEffect(target: Routes.termsOfService)),
      toWebViewTest: () => emitEffect(NavigationEffect(target: Routes.webViewTest)),
    );
  }

  Future<void> _onInit() async {
    final SettingsArguments? args = AppNav.getArgs<SettingsArguments>();
    if (args?.checkUpdate == true) {
      handleIntent(const SettingsIntent.checkUpdates());
    }
    await _updateCacheSize();

    // Scheme C: If notifications are enabled in settings (defaulting to true),
    // request/verify system-level permission when user enters the Settings page.
    if (state.notificationsEnabled) {
      final granted = await notificationService.requestPermission();
      if (!granted) {
        updateState(state.copyWith(notificationsEnabled: false));
        await SpUtil.put(AppConstants.notificationsKey, false);
        await notificationService.unsubscribeFromTopic(AppConstants.versionUpdatesTopic);
      } else {
        await notificationService.subscribeToTopic(AppConstants.versionUpdatesTopic);
      }
    }
  }

  Future<void> _updateCacheSize() async {
    final size = await CacheManager.getCacheSize();
    updateState(state.copyWith(cacheSize: size));
  }

  void _onToggleNotifications(bool enabled) async {
    updateState(state.copyWith(notificationsEnabled: enabled));
    // Persist the notifications toggle setting
    await SpUtil.put(AppConstants.notificationsKey, enabled);

    // Sync FCM topic subscription state
    if (enabled) {
      // Request system-level notification permission
      final granted = await notificationService.requestPermission();
      if (!granted) {
        // Permission denied: revert toggle and prompt user to open system settings
        updateState(state.copyWith(notificationsEnabled: false));
        await SpUtil.put(AppConstants.notificationsKey, false);
        _showPermissionDeniedDialog();
        return;
      }
      await notificationService.subscribeToTopic(AppConstants.versionUpdatesTopic);
    } else {
      await notificationService.unsubscribeFromTopic(AppConstants.versionUpdatesTopic);
    }
  }

  /// Shows a dialog prompting the user to enable notification permission in system settings.
  void _showPermissionDeniedDialog() {
    emitEffect(
      ConfirmEffect(
        title: I18nKeys.notificationPermissionTitle.tr,
        message: I18nKeys.notificationPermissionMessage.tr,
        okText: I18nKeys.openSettings.tr,
        onResult: (confirmed) async {
          if (confirmed) {
            await openAppSettings();
          }
        },
      ),
    );
  }

  Future<void> _onClearCache() async {
    emitEffect(LoadingEffect(true));
    await CacheManager.clearAllCache();
    await _updateCacheSize();
    emitEffect(LoadingEffect(false));
    emitEffect(MessageEffect.info(I18nKeys.cacheCleared.tr));
  }

  Future<void> _onResetSettings() async {
    emitEffect(
      ConfirmEffect(
        title: I18nKeys.resetConfirmTitle.tr,
        message: I18nKeys.resetConfirmContent.tr,
        okText: I18nKeys.reset.tr,
        okColor: Colors.red,
        onResult: (confirmed) async {
          if (confirmed) {
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
        },
      ),
    );
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
    emitEffect(LogOverlayEffect(enabled));
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

    emitEffect(LoadingEffect(false));
    if (hasUpdate) {
      final localeCode = settingManager.language.locale.languageCode;
      final changelogText = versionModel.changelog[localeCode] ?? versionModel.changelog['en'] ?? '';

      emitEffect(
        ConfirmEffect(
          title: I18nKeys.checkUpdates.tr,
          message: '${I18nKeys.updateAvailable.trArgs([versionModel.version])}\n\n$changelogText',
          okText: I18nKeys.update.tr,
          onResult: (confirmed) async {
            if (confirmed) {
              emitEffect(LaunchUrlEffect(versionModel.url));
            }
          },
        ),
      );
    } else {
      emitEffect(MessageEffect.dialog(I18nKeys.latestVersion.tr, title: I18nKeys.checkUpdates.tr));
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

  void _onBuyMeCoffee() {
    emitEffect(CoffeePurchaseEffect());
  }

  void _onShowEnvDialog() {
    emitEffect(
      SwitchDialogEffect(
        title: I18nKeys.switchEnv.tr,
        showConfirmButton: false,
        options: EnvConfigs.values.map((config) {
          return SwitchDialogOption(
            label: _getEnvLabel(config.env),
            value: config.env,
            isSelected: state.currentEnv == config.env,
          );
        }).toList(),
        onChanged: (val) {
          if (val is AppEnvironment) {
            handleIntent(SettingsIntent.switchEnv(val));
            emitEffect(NavigationEffect.back());
          }
        },
      ),
    );
  }

  String _getEnvLabel(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.mock:
        return I18nKeys.envMock.tr;
      case AppEnvironment.dev:
        return I18nKeys.envDev.tr;
      case AppEnvironment.test:
        return I18nKeys.envTest.tr;
      case AppEnvironment.prod:
        return I18nKeys.envProd.tr;
    }
  }

  void _onShowLanguageDialog() {
    emitEffect(
      SwitchDialogEffect(
        title: I18nKeys.selectLanguage.tr,
        showConfirmButton: false,
        options: AppLanguage.values.map((lang) {
          return SwitchDialogOption(
            label: lang.label,
            value: lang,
            isSelected: state.currentLanguage == lang,
          );
        }).toList(),
        onChanged: (val) {
          if (val is AppLanguage) {
            handleIntent(SettingsIntent.switchLanguage(val));
            emitEffect(NavigationEffect.back());
          }
        },
      ),
    );
  }

  void _onShareApp() {
    emitEffect(
      ShareEffect(text: '${AppConstants.appName} - ${I18nKeys.shareApp.tr}: ${AppConstants.storeShare}'),
    );
  }

  void _onLogOverlayShowingChanged() {
    handleIntent(SettingsIntent.toggleLogOverlay(LogOverlayManager.isShowingNotifier.value));
  }

  Future<void> _onEnableDeveloperMode() async {
    if (state.isDeveloperMode) return;
    updateState(state.copyWith(isDeveloperMode: true));
    await SpUtil.put(AppConstants.developerModeKey, true);
    emitEffect(MessageEffect.info('开发者模式已开启'));
  }

  void _onRateApp() {
    emitEffect(RateAppEffect());
  }

  void _onShowLicenses() {
    emitEffect(ShowLicensesEffect());
  }
}
