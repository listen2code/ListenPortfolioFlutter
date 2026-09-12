import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../shared/shared.dart';

part 'appearance_intent.freezed.dart';

/// ============================================================================
/// AppearanceIntent
/// ============================================================================
/// Sealed MVI Intent union capturing all user interactions on the Appearance screen.
///
/// Encapsulates user actions to change theme mode, accent color, font size,
/// font family, dynamic color toggles, and invoking the custom color picker dialog.
@freezed
class AppearanceIntent extends BaseIntent with _$AppearanceIntent {
  /// Updates the application theme mode (system, light, or dark).
  const factory AppearanceIntent.setThemeMode(ThemeMode mode) = _SetThemeMode;

  /// Sets the primary brand accent color.
  const factory AppearanceIntent.setAccentColor(Color color) = _SetAccentColor;

  /// Updates global typography font scaling factor (standard vs large).
  const factory AppearanceIntent.setFontSize(AppFontSize size) = _SetFontSize;

  /// Switches the active font family and fallback chain.
  const factory AppearanceIntent.setFontFamily(AppFontFamily fontFamily) = _SetFontFamily;

  /// Toggles Material You dynamic wallpaper color harmonization on Android.
  const factory AppearanceIntent.setUseDynamicColor(bool use) = _SetUseDynamicColor;

  /// Requests presentation of the custom HSL color picker dialog.
  const factory AppearanceIntent.showColorPicker(Color initialColor) = _ShowColorPicker;

  const AppearanceIntent._();

  /// Registers intent deserializers with [MviPlaybackRegistry].
  ///
  /// Enables complete tape recording, serialization, and deterministic replay
  /// of user appearance interactions during automated testing or telemetry playback.
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
