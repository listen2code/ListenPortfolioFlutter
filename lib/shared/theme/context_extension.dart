import 'package:flutter/material.dart';
import '../shared.dart';

/// Extension to provide shorthand access to common theme, layout, and setting properties.
extension BuildContextX on BuildContext {
  /// Quick check for dark mode
  bool get isDark => theme.brightness == Brightness.dark;

  /// Quick access to font scaling factor
  double get fontFactor => settingManager.fontSize.factor;
}

/// Extension to scale numeric values based on the global font size factor.
/// Allows usage like: 30.f or 15.5.f
extension NumScaleX on num {
  /// Returns the value multiplied by the current global font size factor.
  double get f => this * settingManager.fontSize.factor;
}
