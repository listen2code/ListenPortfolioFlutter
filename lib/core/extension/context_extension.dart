import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

/// Extension to provide shorthand access to common theme, layout, and setting properties.
extension BuildContextX on BuildContext {
  /// Shorthand for Theme.of(context)
  ThemeData get theme => Theme.of(this);

  /// Shorthand for Theme.of(context).textTheme
  TextTheme get textTheme => theme.textTheme;

  /// Shorthand for Theme.of(context).colorScheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Shorthand for the app's global accent color from settingManager
  Color get accentColor => settingManager.accentColor;

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
