import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/presentation/pages/password/change_password_page.dart';
import 'appearance_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _currentLanguage = 'English';
  String _cacheSize = '128 MB';

  @override
  Widget build(BuildContext context) {
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
            colors: [Colors.blueAccent.withOpacity(0.05), Colors.white],
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
                  trailing: Text(_currentLanguage, style: const TextStyle(color: Colors.grey)),
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
                    applicationName: 'Listen Portfolio',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.auto_awesome, size: 48, color: Colors.blueAccent),
                    ),
                    applicationLegalese: '© 2026 Listen',
                  ),
                ),
                _buildListTile(
                  icon: Icons.alternate_email_rounded,
                  title: 'Contact Me',
                  subtitle: 'Send an email to Listen',
                  onTap: () => _launchURL('mailto:listen2code@gmail.com?subject=Portfolio%20Feedback'),
                ),
              ]),
              const SizedBox(height: 25),
              _buildSectionTitle('About'),
              _buildSettingsCard([
                _buildListTile(
                  icon: Icons.info_outline,
                  title: 'App Version',
                  trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await canLaunchUrl(url) && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No email apps installed'), behavior: SnackBarBehavior.floating));
      return;
    }
    if (!await launchUrl(url) && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $urlString'), behavior: SnackBarBehavior.floating));
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('English'), onTap: () => _updateLang('English')),
            ListTile(title: const Text('Chinese'), onTap: () => _updateLang('Chinese')),
            ListTile(title: const Text('Japanese'), onTap: () => _updateLang('Japanese')),
          ],
        ),
      ),
    );
  }

  void _updateLang(String lang) {
    setState(() => _currentLanguage = lang);
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
        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.blueAccent, size: 22),
      ),
      title: Text(
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
        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.blueAccent, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      value: value,
      activeColor: Colors.blueAccent,
      onChanged: onChanged,
    );
  }
}
