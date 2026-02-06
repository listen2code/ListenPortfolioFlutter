import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the theme mode, allowing dynamic switching and persistence.
/// Using a standard NotifierProvider (manual implementation).
final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(() {
  return ThemeController();
});

class ThemeController extends Notifier<ThemeMode> {
  late SharedPreferences _prefs;

  @override
  ThemeMode build() {
    // Initial state is system, but we trigger a load immediately.
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final themeIndex = _prefs.getInt(AppConstants.themeKey);
    if (themeIndex != null) {
      state = ThemeMode.values[themeIndex];
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setInt(AppConstants.themeKey, mode.index);
  }
}
