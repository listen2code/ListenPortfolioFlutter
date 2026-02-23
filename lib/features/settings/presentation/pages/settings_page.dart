import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/constants/app_env.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/utils/cache_manager.dart';
import 'package:listen_portfolio_flutter/core/utils/log_overlay_manager.dart';
import 'package:listen_portfolio_flutter/generated/r.dart';
import 'package:listen_portfolio_flutter/shared/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/shared/base/base_page.dart';
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/i18n/app_language.dart';
import 'package:listen_portfolio_flutter/shared/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/theme/setting_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _cacheSize = '...';

  @override
  void initState() {
    super.initState();
    _updateCacheSize();
  }

  // Fetch and update cache size display
  Future<void> _updateCacheSize() async {
    final size = await CacheManager.getCacheSize();
    if (mounted) {
      setState(() => _cacheSize = size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        return BasePage(
          title: I18nKeys.settings.tr,
          body: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. PREFERENCES: UI and localization
                  _buildSectionTitle(I18nKeys.general.tr),
                  _buildSettingsCard([
                    _buildListTile(
                      icon: Icons.palette_outlined,
                      title: I18nKeys.appearance.tr,
                      subtitle: I18nKeys.appearanceSubtitle.tr,
                      onTap: () => AppNav.to(Routes.appearance),
                    ),
                    _buildListTile(
                      icon: Icons.language_outlined,
                      title: I18nKeys.language.tr,
                      trailing: Text(
                        settingManager.language.label,
                        style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      onTap: () => _showLanguageDialog(),
                    ),
                  ]),

                  SizedBox(height: 25.f),

                  // 2. ACCOUNT & SECURITY
                  _buildSectionTitle(I18nKeys.account.tr),
                  _buildSettingsCard([
                    _buildListTile(
                      icon: Icons.lock_outline_rounded,
                      title: I18nKeys.changePassword.tr,
                      blurLevel: AuthBlurLevel.low,
                      onTap: () => AppNav.to(Routes.changePassword, needLogin: true),
                    ),
                    _buildSwitchTile(
                      icon: Icons.notifications_none_rounded,
                      title: I18nKeys.notifications.tr,
                      value: _notificationsEnabled,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                    _buildListTile(
                      icon: Icons.no_accounts_outlined,
                      title: I18nKeys.deleteAccount.tr,
                      blurLevel: AuthBlurLevel.low,
                      onTap: () => AppNav.to(Routes.deleteAccount, needLogin: true),
                    ),
                  ]),

                  SizedBox(height: 25.f),

                  // 3. STORAGE & MAINTENANCE
                  _buildSectionTitle(I18nKeys.systemStorage.tr),
                  _buildSettingsCard([
                    _buildListTile(
                      icon: Icons.cleaning_services_outlined,
                      title: I18nKeys.clearCache.tr,
                      trailing: Text(
                        _cacheSize,
                        style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      onTap: () => _handleClearCache(),
                    ),
                    _buildListTile(
                      icon: Icons.restart_alt_rounded,
                      title: I18nKeys.resetSettings.tr,
                      onTap: () => _showResetConfirmation(),
                    ),
                  ]),

                  SizedBox(height: 25.f),

                  // 4. DEVELOPER TOOLS
                  _buildSectionTitle(I18nKeys.developer.tr),
                  _buildSettingsCard([
                    // Log Overlay Switch
                    ValueListenableBuilder<bool>(
                      valueListenable: LogOverlayManager.isShowingNotifier,
                      builder: (context, isShowing, child) {
                        return _buildSwitchTile(
                          icon: Icons.terminal_rounded,
                          title: I18nKeys.viewLogs.tr,
                          value: isShowing,
                          onChanged: (val) {
                            if (val) {
                              LogOverlayManager.show(context);
                            } else {
                              LogOverlayManager.hide();
                            }
                          },
                        );
                      },
                    ),
                    // Crash Reports Entry
                    _buildListTile(
                      icon: Icons.bug_report_outlined,
                      title: I18nKeys.crashReports.tr,
                      subtitle: I18nKeys.crashReportsSubtitle.tr,
                      onTap: () => AppNav.to(Routes.crashLogs),
                    ),
                    _buildListTile(
                      icon: Icons.settings_input_antenna_rounded,
                      title: I18nKeys.switchEnv.tr,
                      subtitle: '${I18nKeys.currentlyActive.tr}: ${AppEnv.env}',
                      onTap: () => _showEnvSwitchDialog(),
                    ),
                  ]),

                  SizedBox(height: 25.f),

                  // 5. LEGAL & ABOUT
                  _buildSectionTitle(I18nKeys.about.tr),
                  _buildSettingsCard([
                    _buildListTile(
                      icon: Icons.privacy_tip_outlined,
                      title: I18nKeys.privacyPolicy.tr,
                      onTap: () => AppNav.to(Routes.privacyPolicy),
                    ),
                    _buildListTile(
                      icon: Icons.gavel_outlined,
                      title: I18nKeys.termsOfService.tr,
                      onTap: () => AppNav.to(Routes.termsOfService),
                    ),
                    _buildListTile(
                      icon: Icons.info_outline_rounded,
                      title: I18nKeys.licenses.tr,
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: AppConstants.appName,
                        applicationVersion: AppConstants.appVersion,
                        applicationIcon: Padding(
                          padding: EdgeInsets.all(8.f),
                          child: Image.asset(
                            R.imagesIcLauncherAdaptiveFore,
                            width: 48.f,
                            height: 48.f,
                            color: context.accentColor,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        ),
                        applicationLegalese: '© ${AppConstants.date} ${AppConstants.author}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: Center(
                        child: Text(
                          '${I18nKeys.appVersion.tr} ${AppConstants.appVersion}',
                          style: context.textTheme.labelSmall?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 40.f),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- Logic Handlers ---

  void _handleClearCache() async {
    await CacheManager.clearAllCache();
    await _updateCacheSize();
    if (mounted) {
      CommonToast.show(I18nKeys.cacheCleared.tr);
    }
  }

  void _showResetConfirmation() {
    CommonDialog.showConfirm(
      title: I18nKeys.resetConfirmTitle.tr,
      message: I18nKeys.resetConfirmContent.tr,
      okText: I18nKeys.reset.tr,
      okColor: Colors.red,
    ).then((confirmed) async {
      if (confirmed == true) {
        await settingManager.resetSettings();
        CommonToast.show(I18nKeys.settingsResetSuccess.tr);
      }
    });
  }

  void _showEnvSwitchDialog() {
    CommonDialog.showSwitchDialog(
      title: I18nKeys.switchEnv.tr,
      items: AppEnvironment.values.map((envCode) {
        return DialogSwitchItem(
          label: _getEnvLabel(envCode),
          value: AppEnv.currentEnv == envCode,
          onChanged: (_) async {
            await AppEnv.setEnvironment(envCode);
            if (mounted) setState(() {});
            AppNav.back();
          },
        );
      }).toList(),
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

  void _showLanguageDialog() {
    CommonDialog.showSwitchDialog(
      title: I18nKeys.selectLanguage.tr,
      items: AppLanguage.values.map((lang) {
        return DialogSwitchItem(
          label: lang.label,
          value: settingManager.language == lang,
          onChanged: (_) {
            settingManager.setLanguage(lang);
            AppNav.back();
          },
        );
      }).toList(),
    );
  }

  // --- UI Builders ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10.f, bottom: 8.f, top: 5.f),
      child: Text(
        title.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8.f, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20.f),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 60.f,
                  endIndent: 20.f,
                  color: context.theme.dividerColor.withValues(alpha: 0.05),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    AuthBlurLevel blurLevel = AuthBlurLevel.none,
  }) {
    final accentColor = context.accentColor;
    final iconSize = 20.f * 0.8;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 4.f),
      leading: Container(
        padding: EdgeInsets.all(8.f),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.f),
        ),
        child: Icon(icon, color: accentColor, size: iconSize),
      ),
      title: CommonAuthText(
        title,
        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
        blurLevel: blurLevel,
        onTap: onTap,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(color: Colors.grey),
            )
          : null,
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, size: 20.f, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final accentColor = context.accentColor;
    final iconSize = 20.f * 0.8;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 4.f),
      leading: Container(
        padding: EdgeInsets.all(8.f),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.f),
        ),
        child: Icon(icon, color: accentColor, size: iconSize),
      ),
      title: CommonText(
        title,
        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
      ),
      trailing: CommonSwitch(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
    );
  }
}
