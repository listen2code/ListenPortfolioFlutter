import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
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
        final theme = Theme.of(context);
        final currentAccentColor = settingManager.accentColor;

        return Scaffold(
          appBar: AppBar(
            title: Text(I18nKeys.appearance.tr, style: const TextStyle(fontWeight: FontWeight.w300)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [currentAccentColor.withValues(alpha: 0.05), theme.scaffoldBackgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSectionTitle(I18nKeys.themeMode.tr),
                  _buildSettingsCard(context, [
                    _buildThemeOption(
                      I18nKeys.system.tr,
                      Icons.settings_brightness_outlined,
                      ThemeMode.system,
                      settingManager.themeMode,
                    ),
                    _buildThemeOption(I18nKeys.light.tr, Icons.light_mode_outlined, ThemeMode.light, settingManager.themeMode),
                    _buildThemeOption(I18nKeys.dark.tr, Icons.dark_mode_outlined, ThemeMode.dark, settingManager.themeMode),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionTitle(I18nKeys.accentColor.tr),
                  _buildSettingsCard(context, [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        children: _accentColors.map((color) => _buildColorOption(color, currentAccentColor)).toList(),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionTitle(I18nKeys.fontSize.tr),
                  _buildSettingsCard(context, [
                    _buildFontSizeOption(I18nKeys.standard.tr, 1.0, Icons.text_fields, 20),
                    _buildFontSizeOption(I18nKeys.large.tr, 1.2, Icons.text_fields, 28),
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

  Widget _buildThemeOption(String label, IconData icon, ThemeMode mode, ThemeMode currentMode) {
    final isSelected = mode == currentMode;
    return ListTile(
      leading: Icon(icon, color: isSelected ? null : Colors.grey),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check_circle, color: settingManager.accentColor) : null,
      onTap: () => settingManager.setThemeMode(mode),
    );
  }

  Widget _buildFontSizeOption(String label, double factor, IconData icon, double iconSize) {
    final isSelected = settingManager.fontSizeFactor == factor;
    return ListTile(
      leading: Icon(icon, size: iconSize),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check_circle, color: settingManager.accentColor) : null,
      onTap: () => settingManager.setFontSizeFactor(factor),
    );
  }

  Widget _buildColorOption(Color color, Color currentAccentColor) {
    final isSelected = currentAccentColor.value == color.value;
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
