import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        final accentColor = settingManager.accentColor;

        return BasePage(
          title: I18nKeys.appearance.tr,
          padding: const EdgeInsets.all(20),
          body: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(I18nKeys.themeMode.tr),
                _buildSettingsCard(context, [
                  _buildThemeOption(
                    I18nKeys.system.tr,
                    Icons.settings_brightness_outlined,
                    ThemeMode.system,
                    settingManager.themeMode,
                  ),
                  _buildThemeOption(
                    I18nKeys.light.tr,
                    Icons.light_mode_outlined,
                    ThemeMode.light,
                    settingManager.themeMode,
                  ),
                  _buildThemeOption(
                    I18nKeys.dark.tr,
                    Icons.dark_mode_outlined,
                    ThemeMode.dark,
                    settingManager.themeMode,
                  ),
                ]),
                const SizedBox(height: 25),
                _buildSectionTitle(I18nKeys.accentColor.tr),
                _buildSettingsCard(context, [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // 7 preset colors + 1 custom color button = 8 items
                      itemCount: 8,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        if (index < 7) {
                          // Preset colors
                          final color = SettingManager.accentColors[index];
                          return _buildColorOption(color, currentAccentColor: accentColor);
                        } else {
                          // Custom color button
                          return _buildCustomColorOption(currentAccentColor: accentColor);
                        }
                      },
                    ),
                  ),
                ]),
                const SizedBox(height: 25),
                _buildSectionTitle(I18nKeys.fontSize.tr),
                _buildSettingsCard(context, [
                  _buildFontSizeOption(I18nKeys.standard.tr, AppFontSize.standard),
                  _buildFontSizeOption(I18nKeys.large.tr, AppFontSize.large),
                ]),
                const SizedBox(height: 40),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Material(
        color: context.theme.cardColor,
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
                  indent: 65,
                  endIndent: 20,
                  color: context.theme.dividerColor.withValues(alpha: 0.1),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String label, IconData icon, ThemeMode mode, ThemeMode currentMode) {
    final isSelected = mode == currentMode;
    return ListTile(
      leading: SizedBox(width: 20, child: Icon(icon, color: isSelected ? null : Colors.grey)),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check_circle, color: settingManager.accentColor) : null,
      onTap: () => settingManager.setThemeMode(mode),
    );
  }

  Widget _buildFontSizeOption(String label, AppFontSize fontSize) {
    final isSelected = settingManager.fontSize == fontSize;
    return ListTile(
      leading: SizedBox(width: 20, child: Icon(Icons.text_fields, size: fontSize.iconSize)),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check_circle, color: settingManager.accentColor) : null,
      onTap: () => settingManager.setFontSize(fontSize),
    );
  }

  Widget _buildColorOption(Color color, {required Color currentAccentColor}) {
    final isSelected = currentAccentColor.value == color.value;
    return Center(
      child: GestureDetector(
        onTap: () => settingManager.setAccentColor(color),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
            boxShadow: isSelected
                ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 2)]
                : null,
          ),
          child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
        ),
      ),
    );
  }

  Widget _buildCustomColorOption({required Color currentAccentColor}) {
    // Check if current accent color is one of the preset colors
    final isPreset = SettingManager.accentColors.any((c) => c.value == currentAccentColor.value);
    final isSelected = !isPreset;

    return Center(
      child: GestureDetector(
        onTap: () => _showColorPickerDialog(currentAccentColor),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? currentAccentColor : Colors.grey.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: currentAccentColor.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: isSelected
              ? const Icon(Icons.check, color: Colors.white)
              : const Icon(Icons.colorize_outlined, color: Colors.grey),
        ),
      ),
    );
  }

  void _showColorPickerDialog(Color initialColor) {
    Color selectedColor = initialColor;

    CommonDialog.showCustom(
      title: I18nKeys.selectColor.tr,
      body: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              const SizedBox(height: 20),
              _buildRGBBSlider('R', selectedColor.red, (val) {
                setDialogState(() => selectedColor = selectedColor.withRed(val.toInt()));
              }),
              _buildRGBBSlider('G', selectedColor.green, (val) {
                setDialogState(() => selectedColor = selectedColor.withGreen(val.toInt()));
              }),
              _buildRGBBSlider('B', selectedColor.blue, (val) {
                setDialogState(() => selectedColor = selectedColor.withBlue(val.toInt()));
              }),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(I18nKeys.cancel.tr, style: const TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            settingManager.setAccentColor(selectedColor);
            Navigator.pop(context);
          },
          child: Text(I18nKeys.ok.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildRGBBSlider(String label, int value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 255,
            activeColor: label == 'R' ? Colors.red : (label == 'G' ? Colors.green : Colors.blue),
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 30, child: Text(value.toString())),
      ],
    );
  }
}
