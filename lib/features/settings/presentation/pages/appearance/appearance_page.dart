import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import 'appearance_intent.dart';
import 'appearance_state.dart';
import 'appearance_view_model.dart';

class AppearancePage extends ConsumerWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<AppearanceViewModel, AppearanceState>(
      title: I18nKeys.appearance.tr,
      provider: appearanceViewModelProvider,
      padding: const EdgeInsets.all(20),
      body: (context, child, viewModel, state) {
        if (state == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(I18nKeys.themeMode.tr),
            _buildSettingsCard(context, [
              _buildThemeOption(
                context,
                viewModel,
                I18nKeys.system.tr,
                Icons.settings_brightness_outlined,
                ThemeMode.system,
                state,
              ),
              _buildThemeOption(
                context,
                viewModel,
                I18nKeys.light.tr,
                Icons.light_mode_outlined,
                ThemeMode.light,
                state,
              ),
              _buildThemeOption(
                context,
                viewModel,
                I18nKeys.dark.tr,
                Icons.dark_mode_outlined,
                ThemeMode.dark,
                state,
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
                  itemCount: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    if (index < 7) {
                      final color = SettingManager.accentColors[index];
                      return _buildColorOption(viewModel, color, state.accentColor);
                    } else {
                      return _buildCustomColorOption(context, viewModel, state.accentColor);
                    }
                  },
                ),
              ),
            ]),
            const SizedBox(height: 25),
            _buildSectionTitle(I18nKeys.fontSize.tr),
            _buildSettingsCard(context, [
              _buildFontSizeOption(viewModel, I18nKeys.standard.tr, AppFontSize.standard, state),
              _buildFontSizeOption(viewModel, I18nKeys.large.tr, AppFontSize.large, state),
            ]),
            const SizedBox(height: 40),
          ],
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

  Widget _buildThemeOption(
    BuildContext context,
    AppearanceViewModel? viewModel,
    String label,
    IconData icon,
    ThemeMode mode,
    AppearanceState state,
  ) {
    final isSelected = mode == state.themeMode;
    return ListTile(
      leading: SizedBox(width: 20, child: Icon(icon, color: isSelected ? state.accentColor : Colors.grey)),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check_circle, color: state.accentColor) : null,
      onTap: () => viewModel?.handleIntent(AppearanceIntent.setThemeMode(mode)),
    );
  }

  Widget _buildFontSizeOption(
    AppearanceViewModel? viewModel,
    String label,
    AppFontSize fontSize,
    AppearanceState state,
  ) {
    final isSelected = state.fontSize == fontSize;
    return ListTile(
      leading: SizedBox(
        width: 20,
        child: Icon(
          Icons.text_fields,
          size: fontSize.iconSize,
          color: isSelected ? state.accentColor : Colors.grey,
        ),
      ),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check_circle, color: state.accentColor) : null,
      onTap: () => viewModel?.handleIntent(AppearanceIntent.setFontSize(fontSize)),
    );
  }

  Widget _buildColorOption(AppearanceViewModel? viewModel, Color color, Color currentAccentColor) {
    final isSelected = currentAccentColor.toARGB32() == color.toARGB32();
    return Center(
      child: GestureDetector(
        onTap: () => viewModel?.handleIntent(AppearanceIntent.setAccentColor(color)),
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

  Widget _buildCustomColorOption(
    BuildContext context,
    AppearanceViewModel? viewModel,
    Color currentAccentColor,
  ) {
    final isPreset = SettingManager.accentColors.any((c) => c.toARGB32() == currentAccentColor.toARGB32());
    final isSelected = !isPreset;

    return Center(
      child: GestureDetector(
        onTap: () => _showColorPickerDialog(context, viewModel, currentAccentColor),
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

  void _showColorPickerDialog(BuildContext context, AppearanceViewModel? viewModel, Color initialColor) {
    Color selectedColor = initialColor;

    CommonDialog.showCustom<void>(
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
              _buildRGBBSlider('R', (selectedColor.r * 255.0).round().clamp(0, 255), (val) {
                setDialogState(() => selectedColor = selectedColor.withRed(val.toInt()));
              }),
              _buildRGBBSlider('G', (selectedColor.g * 255.0).round().clamp(0, 255), (val) {
                setDialogState(() => selectedColor = selectedColor.withGreen(val.toInt()));
              }),
              _buildRGBBSlider('B', (selectedColor.b * 255.0).round().clamp(0, 255), (val) {
                setDialogState(() => selectedColor = selectedColor.withBlue(val.toInt()));
              }),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => AppNav.back<void>(),
          child: Text(I18nKeys.cancel.tr, style: const TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            viewModel?.handleIntent(AppearanceIntent.setAccentColor(selectedColor));
            AppNav.back<void>();
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
