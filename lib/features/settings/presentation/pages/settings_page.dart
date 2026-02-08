import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/constants/app_env.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/core/utils/cache_manager.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_page.dart';
import 'package:listen_portfolio_flutter/generated/r.dart';
import 'package:listen_portfolio_flutter/shared/widget/common_text.dart';

import 'appearance_page.dart';

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

  Future<void> _updateCacheSize() async {
    final size = await CacheManager.getCacheSize();
    if (mounted) {
      setState(() => _cacheSize = size);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = settingManager.accentColor;
    final isSwitchingEnvDisabled = AppEnv.isProd() && kReleaseMode;

    return BaseStatelessPage(
      title: I18nKeys.settings.tr,
      padding: const EdgeInsets.all(20),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(I18nKeys.general.tr),
          _buildSettingsCard(context, [
            _buildListTile(
              icon: Icons.palette_outlined,
              title: I18nKeys.appearance.tr,
              subtitle: I18nKeys.appearanceSubtitle.tr,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppearancePage()));
              },
            ),
            _buildListTile(
              icon: Icons.language_outlined,
              title: I18nKeys.language.tr,
              trailing: Text(settingManager.language.label, style: const TextStyle(color: Colors.grey)),
              onTap: () => _showLanguageDialog(),
            ),
            _buildListTile(
              icon: Icons.lock_outline,
              title: I18nKeys.changePassword.tr,
              subtitle: I18nKeys.changePasswordSubtitle.tr,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
              },
            ),
            _buildSwitchTile(
              icon: Icons.notifications_active_outlined,
              title: I18nKeys.notifications.tr,
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
          ]),
          const SizedBox(height: 25),
          _buildSectionTitle(I18nKeys.systemStorage.tr),
          _buildSettingsCard(context, [
            _buildListTile(
              icon: Icons.delete_outline_rounded,
              title: I18nKeys.clearCache.tr,
              trailing: Text(_cacheSize, style: const TextStyle(color: Colors.grey)),
              onTap: () => _handleClearCache(accentColor),
            ),
          ]),
          const SizedBox(height: 25),
          _buildSectionTitle(I18nKeys.about.tr),
          _buildSettingsCard(context, [
            _buildListTile(
              icon: Icons.description_outlined,
              title: I18nKeys.licenses.tr,
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
                    color: settingManager.accentColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
                applicationLegalese: '© ${AppConstants.date} ${AppConstants.author}',
              ),
            ),
            _buildListTile(
              icon: Icons.info_outline,
              title: I18nKeys.appVersion.tr,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${AppConstants.appVersion}${!AppEnv.isProd() ? ' (${AppEnv.env})' : ''}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (!isSwitchingEnvDisabled)
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                    ),
                ],
              ),
              onTap: () {
                if (isSwitchingEnvDisabled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Switching environment is disabled in release build.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                _showEnvSwitchDialog();
              },
            ),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _handleClearCache(Color accentColor) async {
    await CacheManager.clearAllCache();
    await _updateCacheSize();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(I18nKeys.cacheCleared.tr), behavior: SnackBarBehavior.floating, backgroundColor: accentColor),
      );
    }
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
        setState(() {
          AppEnv.setEnvironment(envCode);
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${I18nKeys.envSwitched.tr} $label'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: settingManager.accentColor,
          ),
        );
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
      onTap: () => _updateLang(lang),
    );
  }

  void _updateLang(AppLanguage lang) {
    settingManager.setLanguage(lang);
    Navigator.pop(context);
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
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
                Divider(height: 1, thickness: 0.5, indent: 65, endIndent: 20, color: theme.dividerColor.withOpacity(0.1)),
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
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: settingManager.accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: settingManager.accentColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: settingManager.accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: settingManager.accentColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      value: value,
      activeColor: settingManager.accentColor,
      onChanged: onChanged,
    );
  }
}
