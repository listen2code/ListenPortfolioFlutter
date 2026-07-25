import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import 'settings_intent.dart';
import 'settings_state.dart';
import 'settings_view_model.dart';
import 'widgets/settings_version_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<SettingsViewModel, SettingsState>(
      title: I18nKeys.settings.tr,
      provider: settingsViewModelProvider,
      body: (context, child, viewModel, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. PREFERENCES: UI and localization
              CommonSettingsSectionTitle(title: I18nKeys.general.tr),
              CommonSettingsCard(
                children: [
                  CommonSettingsTile(
                    icon: Icons.palette_outlined,
                    title: I18nKeys.appearance.tr,
                    subtitle: I18nKeys.appearanceSubtitle.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.toAppearance()),
                  ),
                  CommonSettingsTile(
                    icon: Icons.language_outlined,
                    title: I18nKeys.language.tr,
                    trailing: CommonText(
                      state.currentLanguage.label,
                      style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    onTap: () => viewModel.handleIntent(const SettingsIntent.showLanguageDialog()),
                  ),
                ],
              ),

              SizedBox(height: 25.f),

              // 2. ACCOUNT & SECURITY
              CommonSettingsSectionTitle(title: I18nKeys.account.tr),
              CommonSettingsCard(
                children: [
                  CommonSettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: I18nKeys.changePassword.tr,
                    blurLevel: AuthBlurLevel.low,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.toChangePassword()),
                  ),
                  CommonSettingsSwitchTile(
                    icon: Icons.notifications_none_rounded,
                    title: I18nKeys.notifications.tr,
                    value: state.notificationsEnabled,
                    onChanged: (val) => viewModel.handleIntent(SettingsIntent.toggleNotifications(val)),
                  ),
                  CommonSettingsTile(
                    icon: Icons.no_accounts_outlined,
                    title: I18nKeys.deleteAccount.tr,
                    blurLevel: AuthBlurLevel.low,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.toDeleteAccount()),
                  ),
                ],
              ),

              SizedBox(height: 25.f),

              // 3. STORAGE & MAINTENANCE
              CommonSettingsSectionTitle(title: I18nKeys.systemStorage.tr),
              CommonSettingsCard(
                children: [
                  CommonSettingsTile(
                    icon: Icons.cleaning_services_outlined,
                    title: I18nKeys.clearCache.tr,
                    trailing: CommonText(
                      state.cacheSize,
                      style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    onTap: () => viewModel.handleIntent(const SettingsIntent.clearCache()),
                  ),
                  CommonSettingsTile(
                    icon: Icons.restart_alt_rounded,
                    title: I18nKeys.resetSettings.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.resetSettings()),
                  ),
                ],
              ),

              SizedBox(height: 25.f),

              // 4. DEVELOPER TOOLS
              CommonSettingsSectionTitle(title: I18nKeys.developer.tr),
              CommonSettingsCard(
                children: [
                  CommonSettingsSwitchTile(
                    icon: Icons.terminal_rounded,
                    title: I18nKeys.debugPanel.tr,
                    value: state.isLogOverlayShowing,
                    onChanged: (val) {
                      viewModel.handleIntent(SettingsIntent.toggleLogOverlay(val));
                    },
                  ),
                  CommonSettingsTile(
                    icon: Icons.bug_report_outlined,
                    title: I18nKeys.crashReports.tr,
                    subtitle: I18nKeys.crashReportsSubtitle.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.toCrashLogs()),
                  ),
                  CommonSettingsTile(
                    icon: Icons.settings_input_antenna_rounded,
                    title: I18nKeys.switchEnv.tr,
                    subtitle: '${I18nKeys.currentlyActive.tr}: ${state.currentEnv.name}',
                    onTap: () => viewModel.handleIntent(const SettingsIntent.showEnvDialog()),
                  ),
                  if (kDebugMode || state.isDeveloperMode)
                    CommonSettingsTile(
                      icon: Icons.notification_important_outlined,
                      title: 'Push Test',
                      subtitle: '触发前台推送通知横幅模拟',
                      onTap: () async {
                        await notificationService.requestPermission();
                        final service = notificationService;
                        if (service is FirebaseNotificationServiceImpl) {
                          service.simulateMessageReceived(
                            const NotificationPayload(
                              title: '前台测试通知',
                              body: '这是一个在前台接收的推送通知横幅模拟。',
                              data: {'type': 'test'},
                            ),
                          );
                        }
                      },
                    ),
                  if (kDebugMode || state.isDeveloperMode)
                    CommonSettingsTile(
                      icon: Icons.html,
                      title: 'WebView Test',
                      subtitle: 'WebView Dialog',
                      onTap: () => viewModel.handleIntent(const SettingsIntent.toWebViewTest()),
                    ),
                ],
              ),

              SizedBox(height: 25.f),

              // 4.5 SUPPORT & SHARE
              CommonSettingsSectionTitle(title: I18nKeys.supportAndShare.tr),
              CommonSettingsCard(
                children: [
                  CommonSettingsTile(
                    icon: Icons.coffee_outlined,
                    title: I18nKeys.buyMeCoffee.tr,
                    subtitle: I18nKeys.supportProject.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.buyMeCoffee()),
                  ),
                  CommonSettingsTile(
                    icon: Icons.share_outlined,
                    title: I18nKeys.shareApp.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.shareApp()),
                  ),
                  CommonSettingsTile(
                    icon: Icons.star_outline_rounded,
                    title: I18nKeys.rateApp.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.rateApp()),
                  ),
                ],
              ),

              SizedBox(height: 25.f),

              // 5. LEGAL & ABOUT
              CommonSettingsSectionTitle(title: I18nKeys.about.tr),
              CommonSettingsCard(
                children: [
                  CommonSettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: I18nKeys.privacyPolicy.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.toPrivacyPolicy()),
                  ),
                  CommonSettingsTile(
                    icon: Icons.gavel_outlined,
                    title: I18nKeys.termsOfService.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.toTermsOfService()),
                  ),
                  CommonSettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: I18nKeys.licenses.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.showLicenses()),
                  ),
                  CommonSettingsTile(
                    icon: Icons.system_update_outlined,
                    title: I18nKeys.checkUpdates.tr,
                    onTap: () => viewModel.handleIntent(const SettingsIntent.checkUpdates()),
                  ),
                  SettingsVersionTile(
                    onTrigger: () => viewModel.handleIntent(const SettingsIntent.enableDeveloperMode()),
                  ),
                ],
              ),
              SizedBox(height: 40.f),
            ],
          ),
        );
      },
    );
  }
}
