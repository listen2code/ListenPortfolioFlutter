import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class AccentColorGrid extends StatelessWidget {
  final Color currentAccentColor;
  final bool useDynamicColor;
  final ValueChanged<Color> onSelectedColor;
  final VoidCallback onShowColorPicker;

  const AccentColorGrid({
    super.key,
    required this.currentAccentColor,
    required this.useDynamicColor,
    required this.onSelectedColor,
    required this.onShowColorPicker,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: useDynamicColor ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(
        ignoring: useDynamicColor,
        child: Padding(
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
                return _buildColorOption(color);
              } else {
                return _buildCustomColorOption(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = currentAccentColor.toARGB32() == color.toARGB32();
    return Center(
      child: CommonClickable(
        ripple: false,
        selected: isSelected,
        semanticLabel: I18nKeys.accentColorOption.tr,
        onTap: () => onSelectedColor(color),
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

  Widget _buildCustomColorOption(BuildContext context) {
    final isPreset = SettingManager.accentColors.any((c) => c.toARGB32() == currentAccentColor.toARGB32());
    final isSelected = !isPreset;

    return Center(
      child: CommonClickable(
        ripple: false,
        selected: isSelected,
        semanticLabel: I18nKeys.customColorOption.tr,
        onTap: onShowColorPicker,
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
}
