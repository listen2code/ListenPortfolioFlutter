import 'dart:async';

import 'package:flutter/material.dart';
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
      confirmReset: _onConfirmReset,
      switchLanguage: _onSwitchLanguage,
      switchEnv: _onSwitchEnv,
      toggleLogOverlay: _onToggleLogOverlay,
      checkUpdates: _onCheckUpdates,
      showEnvDialog: _onShowEnvDialog,
      showLanguageDialog: _onShowLanguageDialog,
      enableDeveloperMode: _onEnableDeveloperMode,
      buyMeCoffee: () => emitEffect(CoffeePurchaseEffect()),
      shareApp: () => emitEffect(
        ShareEffect(text: '${AppConstants.appName} - ${I18nKeys.shareApp.tr}: ${AppConstants.storeShare}'),
      ),
      rateApp: () => emitEffect(RateAppEffect()),
      showLicenses: () => emitEffect(ShowLicensesEffect()),
      toAppearance: () => emitEffect(NavigationEffect<void>(target: Routes.appearance)),
      toChangePassword: () =>
          emitEffect(NavigationEffect<void>(target: Routes.changePassword, needLogin: true)),
      toDeleteAccount: () =>
          emitEffect(NavigationEffect<void>(target: Routes.deleteAccount, needLogin: true)),
      toCrashLogs: () => emitEffect(NavigationEffect<void>(target: Routes.crashLogs)),
      toPrivacyPolicy: () => emitEffect(NavigationEffect<void>(target: Routes.privacyPolicy)),
      toTermsOfService: () => emitEffect(NavigationEffect<void>(target: Routes.termsOfService)),
      toWebViewTest: () => emitEffect(NavigationEffect<void>(target: Routes.webViewTest)),
      toFaultInjection: () => emitEffect(NavigationEffect<void>(target: Routes.faultInjection)),
      simulateTokenExpired: _onSimulateTokenExpired,
      simulateDeferredDeepLink: _onSimulateDeferredDeepLink,
      confirmOpenSettings: () => emitEffect(OpenAppSettingsEffect()),
      confirmDownloadUpdate: (url) => emitEffect(LaunchUrlEffect(url)),
    );
  }

  Future<void> _onInit() async {
    final SettingsArguments? args = AppNav.getArgs<SettingsArguments>();
    if (args?.checkUpdate == true) {
      _onCheckUpdates();
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
    final size = await DiskCleanupUtil.getCacheSize();
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

        /// Shows a dialog prompting the user to enable notification permission in system settings.
        emitEffect(
          ConfirmEffect(
            title: I18nKeys.notificationPermissionTitle.tr,
            message: I18nKeys.notificationPermissionMessage.tr,
            okText: I18nKeys.openSettings.tr,
            onResult: (confirmed) async {
              if (confirmed) {
                handleIntent(const SettingsIntent.confirmOpenSettings());
              }
            },
          ),
        );
        return;
      }
      await notificationService.subscribeToTopic(AppConstants.versionUpdatesTopic);
    } else {
      await notificationService.unsubscribeFromTopic(AppConstants.versionUpdatesTopic);
    }
  }

  Future<void> _onClearCache() async {
    emitEffect(LoadingEffect(true));
    await DiskCleanupUtil.clearAllCache();
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
        onResult: (confirmed) {
          if (confirmed) {
            handleIntent(const SettingsIntent.confirmReset());
          }
        },
      ),
    );
  }

  Future<void> _onConfirmReset() async {
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
    emitEffect(NavigationEffect<void>.back());
  }

  Future<void> _onSwitchEnv(AppEnvironment env) async {
    if (env == state.currentEnv) return;

    final bool isUserLoggedIn = !authManager.state.isGuest;

    Future<void> performSwitch() async {
      await AppEnv.setEnvironment(env);
      updateState(state.copyWith(currentEnv: env));
      if (isUserLoggedIn) {
        authManager.logout();
        emitEffect(MessageEffect.info(I18nKeys.switchEnvLogoutSuccessTips.trArgs([_getEnvLabel(env)])));
      }
      emitEffect(NavigationEffect<void>.back());
    }

    if (isUserLoggedIn) {
      emitEffect(
        ConfirmEffect(
          title: I18nKeys.switchEnv.tr,
          message: I18nKeys.switchEnvLogoutPrompt.tr,
          onResult: (confirmed) async {
            if (confirmed) {
              await performSwitch();
            } else {
              // Revert the check state on UI by closing the SwitchDialog
              emitEffect(NavigationEffect<void>.back());
            }
          },
        ),
      );
    } else {
      await performSwitch();
    }
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
      onSuccess: (versionModel) {
        _handleVersionCheckResult(versionModel);
      },
      onFailure: (failure) {
        emitEffect(MessageEffect.error(I18nKeys.updateCheckFailed.tr));
      },
    );
  }

  Future<void> _handleVersionCheckResult(VersionModel versionModel) async {
    final currentVer = Core.packageInfo.version;
    final remoteVer = versionModel.version;
    final currentBuild = int.tryParse(Core.packageInfo.buildNumber) ?? 0;
    final remoteBuild = versionModel.buildNumber;

    if (_isNewerVersion(currentVer, currentBuild, remoteVer, remoteBuild)) {
      final localeCode = settingManager.language.locale.languageCode;
      final changelogText = versionModel.changelog[localeCode] ?? versionModel.changelog['en'] ?? '';

      emitEffect(
        ConfirmEffect(
          title: I18nKeys.checkUpdates.tr,
          message: '${I18nKeys.updateAvailable.trArgs([versionModel.version])}\n\n$changelogText',
          okText: I18nKeys.update.tr,
          onResult: (confirmed) async {
            if (confirmed) {
              handleIntent(SettingsIntent.confirmDownloadUpdate(versionModel.url));
            }
          },
        ),
      );
    } else {
      // Primary native version is up to date, check and install Shorebird OTA patch
      final patchInstalled = await shorebirdService.checkAndInstallPatch(
        onPatchDownloaded: () {
          emitEffect(MessageEffect.dialog(I18nKeys.shorebirdPatchReadyMsg.tr, title: I18nKeys.checkUpdates.tr));
        },
      );
      if (!patchInstalled) {
        emitEffect(MessageEffect.dialog(I18nKeys.latestVersion.tr, title: I18nKeys.checkUpdates.tr));
      }
    }
  }

  bool _isNewerVersion(String currentVer, int currentBuild, String remoteVer, int remoteBuild) {
    final currentCode = _calculateVersionCode(currentVer);
    final remoteCode = _calculateVersionCode(remoteVer);
    return remoteCode > currentCode || (remoteCode == currentCode && remoteBuild > currentBuild);
  }

  int _calculateVersionCode(String versionName) {
    try {
      final parts = versionName.trim().split('.');
      final major = parts.isNotEmpty ? (int.tryParse(parts[0]) ?? 0) : 0;
      final minor = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
      final patch = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;
      return major * 10000 + minor * 100 + patch;
    } catch (_) {
      return 0;
    }
  }

  void _onShowEnvDialog() {
    emitEffect(
      SwitchDialogEffect(
        title: I18nKeys.switchEnv.tr,
        showConfirmButton: false,
        options: EnvConfigs.values.map((config) {
          return SwitchDialogOption(
            label: _getEnvLabel(config.env),
            subtitle: config.baseUrl,
            value: config.env,
            isSelected: state.currentEnv == config.env,
          );
        }).toList(),
        onChanged: (val) {
          if (val is AppEnvironment) {
            handleIntent(SettingsIntent.switchEnv(val));
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
          }
        },
      ),
    );
  }

  void _onLogOverlayShowingChanged() {
    handleIntent(SettingsIntent.toggleLogOverlay(LogOverlayManager.isShowingNotifier.value));
  }

  Future<void> _onEnableDeveloperMode() async {
    if (state.isDeveloperMode) return;
    updateState(state.copyWith(isDeveloperMode: true));
    await SpUtil.put(AppConstants.developerModeKey, true);
    emitEffect(MessageEffect.info(I18nKeys.developerModeEnabled.tr));
  }

  Future<void> _onSimulateTokenExpired() async {
    await SecureStorageUtil.put(AppConstants.authTokenKey, 'invalid_expired_token_for_testing');
    emitEffect(MessageEffect.info(I18nKeys.tokenInvalidatedMessage.tr));
  }

  Future<void> _onSimulateDeferredDeepLink() async {
    final service = ref.read(installReferrerServiceProvider);
    final simulated = await service.simulateReferrer('refer=GooglePlayBeta&target=aboutMe');
    emitEffect(
      ReferralWelcomeEffect(
        data: simulated,
        onConfirm: () {
          emitEffect(MessageEffect.info(I18nKeys.referralSimulationTriggered.tr));
        },
      ),
    );
  }
}
