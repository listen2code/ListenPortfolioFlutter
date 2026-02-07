import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  final List<Color> _accentColors = [
    Colors.blueAccent,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.redAccent,
    Colors.orange,
    Colors.green,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingManager,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Appearance', style: TextStyle(fontWeight: FontWeight.w300)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white,
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [settingManager.accentColor.withValues(alpha: 0.05), Theme.of(context).scaffoldBackgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSectionTitle('Theme Mode'),
                  _buildSettingsCard([
                    _buildThemeOption('System', Icons.settings_brightness_outlined, ThemeMode.system, settingManager.themeMode),
                    _buildThemeOption('Light', Icons.light_mode_outlined, ThemeMode.light, settingManager.themeMode),
                    _buildThemeOption('Dark', Icons.dark_mode_outlined, ThemeMode.dark, settingManager.themeMode),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionTitle('Accent Color'),
                  _buildSettingsCard([
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        children: _accentColors.map((color) => _buildColorOption(color)).toList(),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionTitle('Font Size'),
                  _buildSettingsCard([
                    _buildFontSizeOption('Standard', 1.0, Icons.text_fields, 20),
                    _buildFontSizeOption('Large', 1.2, Icons.text_fields, 28),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildThemeOption(String label, IconData icon, ThemeMode mode, ThemeMode currentMode) {
    final isSelected = mode == currentMode;
    return ListTile(
      leading: Icon(icon, color: isSelected ? null : Colors.grey),
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check_circle) : null,
      onTap: () => settingManager.setThemeMode(mode),
    );
  }

  Widget _buildFontSizeOption(String label, double factor, IconData icon, double iconSize) {
    final isSelected = settingManager.fontSizeFactor == factor;
    return ListTile(
      leading: Icon(icon, size: iconSize),
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check_circle) : null,
      onTap: () => settingManager.setFontSizeFactor(factor),
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = settingManager.accentColor.value == color.value;
    return GestureDetector(
      onTap: () => settingManager.setAccentColor(color),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)] : null,
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }
}
