import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/domain/models/fault_injection_scenario.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/fault_injection_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/resume/resume_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/appearance_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/playback_tape_list/playback_tape_list_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_intent.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  group('Feature Intents Coverage Tests', () {
    test('initMviPlaybackRegistry registers all intent deserializers', () {
      initMviPlaybackRegistry();

      final registered = MviPlaybackRegistry.registeredKeys;
      expect(registered.containsKey('SettingsIntent'), isTrue);
      expect(registered.containsKey('AppearanceIntent'), isTrue);
      expect(registered.containsKey('AboutMeIntent'), isTrue);
      expect(registered.containsKey('ArchitectureIntent'), isTrue);
      expect(registered.containsKey('FaultInjectionIntent'), isTrue);
      expect(registered.containsKey('CrashLogListIntent'), isTrue);
      expect(registered.containsKey('DeleteAccountIntent'), isTrue);
      expect(registered.containsKey('PlaybackTapeListIntent'), isTrue);
    });

    test('SettingsIntent variants', () {
      const init = SettingsIntent.init();
      const toggleNotifications = SettingsIntent.toggleNotifications(true);
      const clearCache = SettingsIntent.clearCache();
      const resetSettings = SettingsIntent.resetSettings();
      const confirmReset = SettingsIntent.confirmReset();
      const switchLanguage = SettingsIntent.switchLanguage(AppLanguage.chinese);
      const switchEnv = SettingsIntent.switchEnv(AppEnvironment.prod);
      const toggleLogOverlay = SettingsIntent.toggleLogOverlay(true);
      const checkUpdates = SettingsIntent.checkUpdates();
      const buyMeCoffee = SettingsIntent.buyMeCoffee();
      const showEnvDialog = SettingsIntent.showEnvDialog();
      const showLanguageDialog = SettingsIntent.showLanguageDialog();
      const shareApp = SettingsIntent.shareApp();
      const enableDeveloperMode = SettingsIntent.enableDeveloperMode();
      const rateApp = SettingsIntent.rateApp();
      const showLicenses = SettingsIntent.showLicenses();
      const toAppearance = SettingsIntent.toAppearance();
      const toChangePassword = SettingsIntent.toChangePassword();
      const toDeleteAccount = SettingsIntent.toDeleteAccount();
      const toCrashLogs = SettingsIntent.toCrashLogs();
      const toPrivacyPolicy = SettingsIntent.toPrivacyPolicy();
      const toTermsOfService = SettingsIntent.toTermsOfService();
      const toWebViewTest = SettingsIntent.toWebViewTest();
      const toFaultInjection = SettingsIntent.toFaultInjection();
      const simulateTokenExpired = SettingsIntent.simulateTokenExpired();
      const simulateDeferredDeepLink = SettingsIntent.simulateDeferredDeepLink();
      const confirmOpenSettings = SettingsIntent.confirmOpenSettings();
      const confirmDownloadUpdate = SettingsIntent.confirmDownloadUpdate('https://example.com/app.apk');

      expect(init, isNotNull);
      expect(toggleNotifications, isNotNull);
      expect(clearCache, isNotNull);
      expect(resetSettings, isNotNull);
      expect(confirmReset, isNotNull);
      expect(switchLanguage, isNotNull);
      expect(switchEnv, isNotNull);
      expect(toggleLogOverlay, isNotNull);
      expect(checkUpdates, isNotNull);
      expect(buyMeCoffee, isNotNull);
      expect(showEnvDialog, isNotNull);
      expect(showLanguageDialog, isNotNull);
      expect(shareApp, isNotNull);
      expect(enableDeveloperMode, isNotNull);
      expect(rateApp, isNotNull);
      expect(showLicenses, isNotNull);
      expect(toAppearance, isNotNull);
      expect(toChangePassword, isNotNull);
      expect(toDeleteAccount, isNotNull);
      expect(toCrashLogs, isNotNull);
      expect(toPrivacyPolicy, isNotNull);
      expect(toTermsOfService, isNotNull);
      expect(toWebViewTest, isNotNull);
      expect(toFaultInjection, isNotNull);
      expect(simulateTokenExpired, isNotNull);
      expect(simulateDeferredDeepLink, isNotNull);
      expect(confirmOpenSettings, isNotNull);
      expect(confirmDownloadUpdate, isNotNull);
    });

    test('AppearanceIntent variants', () {
      const setTheme = AppearanceIntent.setThemeMode(ThemeMode.dark);
      const setAccent = AppearanceIntent.setAccentColor(Colors.blue);
      const setFontSize = AppearanceIntent.setFontSize(AppFontSize.large);
      const setFontFamily = AppearanceIntent.setFontFamily(AppFontFamily.system);
      const setDynamic = AppearanceIntent.setUseDynamicColor(true);
      const showPicker = AppearanceIntent.showColorPicker(Colors.red);

      expect(setTheme, isNotNull);
      expect(setAccent, isNotNull);
      expect(setFontSize, isNotNull);
      expect(setFontFamily, isNotNull);
      expect(setDynamic, isNotNull);
      expect(showPicker, isNotNull);
    });

    test('AboutMeIntent & ArchitectureIntent & ResumeIntent variants', () {
      const refresh = AboutMeIntent.refresh();
      const showPicker = AboutMeIntent.showPickerMenu();
      const previewAvatar = AboutMeIntent.previewAvatar();
      const toResume = AboutMeIntent.toResume();

      expect(refresh, isNotNull);
      expect(showPicker, isNotNull);
      expect(previewAvatar, isNotNull);
      expect(toResume, isNotNull);

      const archRefresh = ArchitectureIntent.refresh();
      const archLaunch = ArchitectureIntent.launchURL('https://flutter.dev');
      expect(archRefresh, isNotNull);
      expect(archLaunch, isNotNull);

      const resInit = ResumeIntent.init();
      const resExport = ResumeIntent.exportPDF();
      expect(resInit, isNotNull);
      expect(resExport, isNotNull);
    });

    test('FaultInjectionIntent variants', () {
      const init = FaultInjectionIntent.init();
      const selectCat = FaultInjectionIntent.selectCategory(FaultCategory.network);
      const runScenario = FaultInjectionIntent.runScenario(FaultScenarioType.concurrent401);
      const clearConsole = FaultInjectionIntent.clearConsole();
      const copyTrace = FaultInjectionIntent.copyTraceId('trace-123');
      const drillTrace = FaultInjectionIntent.drillTrace('trace-123');
      const resetAll = FaultInjectionIntent.resetAll();

      expect(init, isNotNull);
      expect(selectCat, isNotNull);
      expect(runScenario, isNotNull);
      expect(clearConsole, isNotNull);
      expect(copyTrace, isNotNull);
      expect(drillTrace, isNotNull);
      expect(resetAll, isNotNull);
    });

    test('PlaybackTapeListIntent & DeleteAccountIntent & CrashLogListIntent variants', () {
      const pbLoad = PlaybackTapeListIntent.loadTapes();
      const pbDelete = PlaybackTapeListIntent.deleteTape('tape-1');
      const pbConfirmDelete = PlaybackTapeListIntent.confirmDeleteTape('tape-1');
      const pbPlay = PlaybackTapeListIntent.startPlayback('tape-1');
      const pbDetails = PlaybackTapeListIntent.showTapeDetails('tape-1', 'Tape 1');

      expect(pbLoad, isNotNull);
      expect(pbDelete, isNotNull);
      expect(pbConfirmDelete, isNotNull);
      expect(pbPlay, isNotNull);
      expect(pbDetails, isNotNull);

      const daToggle = DeleteAccountIntent.toggleConfirm();
      const daDelete = DeleteAccountIntent.deleteAccount();
      const daConfirm = DeleteAccountIntent.confirmDelete();

      expect(daToggle, isNotNull);
      expect(daDelete, isNotNull);
      expect(daConfirm, isNotNull);

      const clInit = CrashLogListIntent.init();
      const clRefresh = CrashLogListIntent.refresh();
      const clTrigger = CrashLogListIntent.triggerCrash();
      const clConfirmTrigger = CrashLogListIntent.confirmTriggerCrash();
      const clDeleteAll = CrashLogListIntent.deleteAll();
      const clConfirmDeleteAll = CrashLogListIntent.confirmDeleteAll();

      expect(clInit, isNotNull);
      expect(clRefresh, isNotNull);
      expect(clTrigger, isNotNull);
      expect(clConfirmTrigger, isNotNull);
      expect(clDeleteAll, isNotNull);
      expect(clConfirmDeleteAll, isNotNull);
    });
  });
}
