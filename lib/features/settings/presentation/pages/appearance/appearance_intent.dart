import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../shared/shared.dart';

part 'appearance_intent.freezed.dart';

@freezed
class AppearanceIntent extends BaseIntent with _$AppearanceIntent {
  const factory AppearanceIntent.setThemeMode(ThemeMode mode) = _SetThemeMode;
  const factory AppearanceIntent.setAccentColor(Color color) = _SetAccentColor;
  const factory AppearanceIntent.setFontSize(AppFontSize size) = _SetFontSize;
  const factory AppearanceIntent.setFontFamily(AppFontFamily fontFamily) = _SetFontFamily;
  const factory AppearanceIntent.setUseDynamicColor(bool use) = _SetUseDynamicColor;
  const factory AppearanceIntent.showColorPicker(Color initialColor) = _ShowColorPicker;
  const AppearanceIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('AppearanceIntent', 'setThemeMode', (args) {
      final modeStr = args['mode'] ?? '';
      final mode = ThemeMode.values.firstWhere(
        (e) => e.toString().split('.').last == modeStr || e.toString() == modeStr,
        orElse: () => ThemeMode.system,
      );
      return AppearanceIntent.setThemeMode(mode);
    });
    MviPlaybackRegistry.register('AppearanceIntent', 'setAccentColor', (args) {
      final colorStr = args['color'] ?? '';
      final value = int.tryParse(colorStr.replaceAll(RegExp(r'[^\dxa-fA-F]'), '')) ?? Colors.blue.toARGB32();
      return AppearanceIntent.setAccentColor(Color(value));
    });
    MviPlaybackRegistry.register('AppearanceIntent', 'setFontSize', (args) {
      final sizeStr = args['size'] ?? '';
      final size = AppFontSize.values.firstWhere(
        (e) => e.toString().split('.').last == sizeStr || e.toString() == sizeStr,
        orElse: () => AppFontSize.standard,
      );
      return AppearanceIntent.setFontSize(size);
    });
    MviPlaybackRegistry.register('AppearanceIntent', 'setFontFamily', (args) {
      final familyStr = args['fontFamily'] ?? args['family'] ?? '';
      final family = AppFontFamily.values.firstWhere(
        (e) => e.toString().split('.').last == familyStr || e.name == familyStr || e.fontFamilyName == familyStr,
        orElse: () => AppFontFamily.system,
      );
      return AppearanceIntent.setFontFamily(family);
    });
    MviPlaybackRegistry.register(
      'AppearanceIntent',
      'setUseDynamicColor',
      (args) => AppearanceIntent.setUseDynamicColor(args['use'] == 'true'),
    );
    MviPlaybackRegistry.register('AppearanceIntent', 'showColorPicker', (args) {
      final colorStr = args['initialColor'] ?? '';
      final value = int.tryParse(colorStr.replaceAll(RegExp(r'[^\dxa-fA-F]'), '')) ?? Colors.blue.toARGB32();
      return AppearanceIntent.showColorPicker(Color(value));
    });
  }
}
