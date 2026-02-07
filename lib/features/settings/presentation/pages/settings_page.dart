import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/constants/app_env.dart';
import 'package:listen_portfolio_flutter/core/theme/theme_provider.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_page.dart';
import 'package:listen_portfolio_flutter/shared/widget/common_text.dart';
import 'package:url_launcher/url_launcher.dart';

import 'appearance_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _cacheSize = '128 MB';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeManager,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w300)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.black87,
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [themeManager.accentColor.withOpacity(0.05), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSectionTitle('General'),
                  _buildSettingsCard([
                    _buildListTile(
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      subtitle: 'Theme, colors, and fonts',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppearancePage()));
                      },
                    ),
                    _buildListTile(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      trailing: Text(themeManager.language, style: const TextStyle(color: Colors.grey)),
                      onTap: () => _showLanguageDialog(),
                    ),
                    _buildListTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your account security',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'Notifications',
                      value: _notificationsEnabled,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionTitle('System & Storage'),
                  _buildSettingsCard([
                    _buildListTile(
                      icon: Icons.delete_outline_rounded,
                      title: 'Clear Cache',
                      trailing: Text(_cacheSize, style: const TextStyle(color: Colors.grey)),
                      onTap: () => _clearCache(),
                    ),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionTitle('Connect'),
                  _buildSettingsCard([
                    _buildListTile(
                      icon: Icons.description_outlined,
                      title: 'Open Source Licenses',
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: '${AppConstants.appVersion} Portfolio',
                        applicationVersion: AppConstants.appVersion,
                        applicationIcon: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.auto_awesome, size: 48)),
                        applicationLegalese: '© ${AppConstants.date} ${AppConstants.author}',
                      ),
                    ),
                    _buildListTile(
                      icon: Icons.alternate_email_rounded,
                      title: 'Contact Me',
                      subtitle: 'Send an email to ${AppConstants.author}',
                      onTap: () => _launchURL('mailto:${AppConstants.mail}?subject=Portfolio%20Feedback'),
                    ),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionTitle('About'),
                  _buildSettingsCard([
                    _buildListTile(
                      icon: Icons.info_outline,
                      title: 'App Version',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${AppConstants.appVersion}${!AppEnv.isProd() ? ' (${AppEnv.env})' : ''}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                        ],
                      ),
                      onTap: () => _showEnvSwitchDialog(),
                    ),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEnvSwitchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CommonText('Switch Environment'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildEnvTile('Development', 'dev'), _buildEnvTile('Testing', 'test'), _buildEnvTile('Production', 'prod')],
        ),
      ),
    );
  }

  Widget _buildEnvTile(String label, String envCode) {
    final bool isCurrent = AppEnv.env == envCode;
    return ListTile(
      title: Text(label),
      subtitle: Text(isCurrent ? 'Currently Active' : 'Switch to $envCode'),
      trailing: isCurrent ? const Icon(Icons.check_circle) : null,
      onTap: () {
        AppEnv.setEnvironment(envCode);
        setState(() {}); // Refresh UI
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Environment switched to: $label'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: themeManager.accentColor,
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await canLaunchUrl(url) && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No email apps installed'), behavior: SnackBarBehavior.floating));
      return;
    }
    if (!await launchUrl(url) && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $urlString'), behavior: SnackBarBehavior.floating));
    }
  }

  void _showLanguageDialog() {
    final currentLang = themeManager.language;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English', currentLang),
            _buildLanguageOption('Chinese', currentLang),
            _buildLanguageOption('Japanese', currentLang),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String lang, String currentLang) {
    final isSelected = lang == currentLang;
    return ListTile(
      title: Text(
        lang,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? themeManager.accentColor : Colors.black87,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check_circle, color: themeManager.accentColor) : null,
      onTap: () => _updateLang(lang),
    );
  }

  void _updateLang(String lang) {
    themeManager.setLanguage(lang);
    Navigator.pop(context);
  }

  void _clearCache() {
    setState(() => _cacheSize = '0 MB');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cache cleared successfully!'), behavior: SnackBarBehavior.floating));
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

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) Divider(height: 1, thickness: 0.5, indent: 65, endIndent: 20, color: Colors.grey[100]),
          ],
        ],
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
        decoration: BoxDecoration(color: themeManager.accentColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 22),
      ),
      title: CommonText(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: themeManager.accentColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      value: value,
      activeThumbColor: themeManager.accentColor,
      onChanged: onChanged,
    );
  }
}
