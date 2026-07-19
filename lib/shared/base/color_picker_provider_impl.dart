import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../features/settings/presentation/pages/widgets/color_picker_widget.dart';
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
      body: ColorPickerWidget(
        initialColor: effect.initialColor,
        onColorChanged: (color) {
          selectedColor = color;
        },
      ),
      actions: [
        CommonButton(
          text: I18nKeys.cancel.tr,
          onPressed: () => AppNav.back<void>(),
          type: ButtonType.text,
          foregroundColor: Colors.grey,
          isFullWidth: false,
          height: 36,
        ),
        CommonButton(
          text: I18nKeys.ok.tr,
          onPressed: () {
            effect.onColorSelected(selectedColor);
            AppNav.back<void>();
          },
          type: ButtonType.text,
          isFullWidth: false,
          height: 36,
        ),
      ],
    );
  }
}
