import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/constants/app_env.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/core/utils/cache_manager.dart';
import 'package:listen_portfolio_flutter/core/utils/log_overlay_manager.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_page.dart';
import 'package:listen_portfolio_flutter/generated/r.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_auth_text.dart';

import 'appearance_page.dart';
import 'delete_account_page.dart';
import 'privacy_policy_page.dart';
import 'terms_of_service_page.dart';

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
        final accentColor = settingManager.accentColor;

        return BaseStatelessPage(
          title: I18nKeys.settings.tr,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          body: (BuildContext context, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. PREFERENCES: UI related settings
                  _buildSectionTitle(I18nKeys.general.tr),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      icon: Icons.palette_outlined,
                      title: I18nKeys.appearance.tr,
                      subtitle: I18nKeys.appearanceSubtitle.tr,
                      accentColor: accentColor,
                      onTap: () => Nav.to(const AppearancePage()),
                    ),
                    _buildListTile(
                      icon: Icons.language_outlined,
                      title: I18nKeys.language.tr,
                      accentColor: accentColor,
                      trailing: Text(
                        settingManager.language.label,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      onTap: () => _showLanguageDialog(),
                    ),
                  ]),

                  const SizedBox(height: 25),

                  // 2. ACCOUNT & SECURITY
                  _buildSectionTitle(I18nKeys.account.tr),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      icon: Icons.lock_outline_rounded,
                      title: I18nKeys.changePassword.tr,
                      accentColor: accentColor,
                      blurLevel: AuthBlurLevel.low,
                      onTap: () => Nav.to(const ChangePasswordPage(), needLogin: true),
                    ),
                    _buildSwitchTile(
                      icon: Icons.notifications_none_rounded,
                      title: I18nKeys.notifications.tr,
                      value: _notificationsEnabled,
                      accentColor: accentColor,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                    _buildListTile(
                      icon: Icons.no_accounts_outlined,
                      title: I18nKeys.deleteAccount.tr,
                      accentColor: accentColor,
                      blurLevel: AuthBlurLevel.low,
                      onTap: () => Nav.to(const DeleteAccountPage(), needLogin: true),
                    ),
                  ]),

                  const SizedBox(height: 25),

                  // 3. STORAGE & MAINTENANCE
                  _buildSectionTitle(I18nKeys.systemStorage.tr),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      icon: Icons.cleaning_services_outlined,
                      title: I18nKeys.clearCache.tr,
                      accentColor: accentColor,
                      trailing: Text(_cacheSize, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      onTap: () => _handleClearCache(accentColor),
                    ),
                    _buildListTile(
                      icon: Icons.restart_alt_rounded,
                      title: I18nKeys.resetSettings.tr,
                      accentColor: accentColor,
                      onTap: () => _showResetConfirmation(accentColor),
                    ),
                  ]),

                  const SizedBox(height: 25),

                  // 4. DEVELOPER TOOLS
                  _buildSectionTitle(I18nKeys.developer.tr),
                  _buildSettingsCard(context, [
                    _buildSwitchTile(
                      icon: Icons.terminal_rounded,
                      title: I18nKeys.viewLogs.tr,
                      value: LogOverlayManager.isShowing,
                      accentColor: accentColor,
                      onChanged: (val) {
                        setState(() {
                          if (val) {
                            LogOverlayManager.show(context);
                          } else {
                            LogOverlayManager.hide();
                          }
                        });
                      },
                    ),
                    _buildListTile(
                      icon: Icons.settings_input_antenna_rounded,
                      title: I18nKeys.switchEnv.tr,
                      subtitle: '${I18nKeys.currentlyActive.tr}: ${AppEnv.env}',
                      accentColor: accentColor,
                      onTap: () => _showEnvSwitchDialog(),
                    ),
                  ]),

                  const SizedBox(height: 25),

                  // 5. LEGAL & ABOUT
                  _buildSectionTitle(I18nKeys.about.tr),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      icon: Icons.privacy_tip_outlined,
                      title: I18nKeys.privacyPolicy.tr,
                      accentColor: accentColor,
                      onTap: () => Nav.to(const PrivacyPolicyPage()),
                    ),
                    _buildListTile(
                      icon: Icons.gavel_outlined,
                      title: I18nKeys.termsOfService.tr,
                      accentColor: accentColor,
                      onTap: () => Nav.to(const TermsOfServicePage()),
                    ),
                    _buildListTile(
                      icon: Icons.info_outline_rounded,
                      title: I18nKeys.licenses.tr,
                      accentColor: accentColor,
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: AppConstants.appName,
                        applicationVersion: AppConstants.appVersion,
                        applicationIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            R.imagesIcLauncherAdaptiveFore,
                            width: 48,
                            height: 48,
                            color: accentColor,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        ),
                        applicationLegalese: '© ${AppConstants.date} ${AppConstants.author}',
                      ),
                    ),
                    ListTile(
                      title: Center(
                        child: Text(
                          '${I18nKeys.appVersion.tr} ${AppConstants.appVersion}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- Logic Helpers ---

  void _handleClearCache(Color accentColor) async {
    await CacheManager.clearAllCache();
    await _updateCacheSize();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(I18nKeys.cacheCleared.tr),
          behavior: SnackBarBehavior.floating,
          backgroundColor: accentColor,
        ),
      );
    }
  }

  void _showResetConfirmation(Color accentColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(I18nKeys.resetConfirmTitle.tr),
        content: Text(I18nKeys.resetConfirmContent.tr),
        actions: [
          TextButton(onPressed: () => Nav.back(), child: Text(I18nKeys.cancel.tr)),
          TextButton(
            onPressed: () async {
              await settingManager.resetSettings();
              if (mounted) {
                Nav.back();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(I18nKeys.settingsResetSuccess.tr),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: accentColor,
                  ),
                );
              }
            },
            child: Text(I18nKeys.reset.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEnvSwitchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CommonText(I18nKeys.switchEnv.tr),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEnvTile(I18nKeys.envDev.tr, AppEnvironment.dev),
            _buildEnvTile(I18nKeys.envTest.tr, AppEnvironment.test),
            _buildEnvTile(I18nKeys.envProd.tr, AppEnvironment.prod),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvTile(String label, AppEnvironment envCode) {
    final bool isCurrent = AppEnv.env == envCode.name;
    return ListTile(
      title: Text(label),
      subtitle: Text(isCurrent ? I18nKeys.currentlyActive.tr : envCode.name),
      trailing: isCurrent ? const Icon(Icons.check_circle) : null,
      onTap: () {
        setState(() => AppEnv.setEnvironment(envCode));
        Nav.back();
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(I18nKeys.selectLanguage.tr),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLanguage.values.map((lang) => _buildLanguageOption(lang)).toList(),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(AppLanguage lang) {
    final isSelected = lang == settingManager.language;
    return ListTile(
      title: Text(
        lang.label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? settingManager.accentColor : null,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check_circle, color: settingManager.accentColor) : null,
      onTap: () {
        settingManager.setLanguage(lang);
        Nav.back();
      },
    );
  }

  // --- UI Reusable Builders ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8, top: 5),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 60,
                  endIndent: 20,
                  color: theme.dividerColor.withValues(alpha: 0.05),
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
    required Color accentColor,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    AuthBlurLevel blurLevel = AuthBlurLevel.none,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      title: CommonAuthText(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        maxLines: 1,
        blurLevel: blurLevel,
        onTap: onTap,
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey))
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Color accentColor,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      dense: true,
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      title: CommonText(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        maxLines: 1,
      ),
      value: value,
      activeColor: accentColor,
      onChanged: onChanged,
    );
  }
}
