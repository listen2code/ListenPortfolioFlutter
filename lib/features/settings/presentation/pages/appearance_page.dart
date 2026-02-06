import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/theme/theme_provider.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  Color _selectedAccentColor = Colors.blueAccent;

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
      listenable: themeManager,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Appearance', style: TextStyle(fontWeight: FontWeight.w300)),
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
                  _buildSectionTitle('Theme Mode'),
                  _buildSettingsCard([
                    _buildThemeOption('System', Icons.settings_brightness_outlined, ThemeMode.system, themeManager.themeMode),
                    _buildThemeOption('Light', Icons.light_mode_outlined, ThemeMode.light, themeManager.themeMode),
                    _buildThemeOption('Dark', Icons.dark_mode_outlined, ThemeMode.dark, themeManager.themeMode),
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
                    const ListTile(
                      leading: Icon(Icons.text_fields, color: Colors.blueAccent),
                      title: Text('Standard'),
                      trailing: Icon(Icons.check, color: Colors.blueAccent),
                    ),
                    const ListTile(
                      leading: Icon(Icons.text_fields, color: Colors.blueAccent, size: 28),
                      title: Text('Large'),
                    ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildThemeOption(String label, IconData icon, ThemeMode mode, ThemeMode currentMode) {
    final isSelected = mode == currentMode;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blueAccent : Colors.grey),
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blueAccent) : null,
      onTap: () {
        themeManager.setThemeMode(mode);
      },
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = _selectedAccentColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedAccentColor = color),
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
