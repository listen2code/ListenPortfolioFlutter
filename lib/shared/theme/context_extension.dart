import 'package:flutter/material.dart';
import '../shared.dart';

/// ============================================================================
/// BuildContextX & NumScaleX
/// ============================================================================
/// Convenient syntax extensions providing reactive access to global theme,
/// layout boundaries, and typography scaling properties.

/// Extension on [BuildContext] for ergonomic access to appearance configurations.
extension BuildContextX on BuildContext {
  /// Whether the current active theme brightness is dark.
  bool get isDark => theme.brightness == Brightness.dark;

  /// Quick access to the global typography scaling multiplier (e.g., 1.0 for standard, 1.3 for large).
  double get fontFactor => settingManager.fontSize.factor;
}

/// Extension on [num] to dynamically scale numeric layout and typography values.
///
/// Allows declarative scaling such as `14.f` or `32.0.f`, ensuring that custom
/// sizes proportionally scale with the user's global font size preference.
extension NumScaleX on num {
  /// Returns this numeric value scaled by the current global font factor ([SettingManager.fontSize.factor]).
  double get f => this * settingManager.fontSize.factor;
}
