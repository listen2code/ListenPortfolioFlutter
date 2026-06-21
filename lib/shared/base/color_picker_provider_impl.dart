import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../shared.dart';

/// Effect to show custom color picker dialog.
class ColorPickerEffect extends BaseEffect {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  ColorPickerEffect({
    required this.initialColor,
    required this.onColorSelected,
  });
}

/// Provider to handle [ColorPickerEffect].
class ColorPickerProviderImpl extends BaseProvider<ColorPickerEffect> {
  const ColorPickerProviderImpl();

  @override
  void handleEffect(ColorPickerEffect effect) {
    final context = AppNavConfig.context;
    if (context == null) return;

    Color selectedColor = effect.initialColor;

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
            effect.onColorSelected(selectedColor);
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
