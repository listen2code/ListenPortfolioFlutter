import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() => _instance;

  ThemeManager._internal() {
    _loadSettings();
  }

  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.blueAccent;

  ThemeMode get themeMode => _themeMode;

  Color get accentColor => _accentColor;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Theme Mode
    final themeIndex = prefs.getInt(AppConstants.themeKey);
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    }

    // Load Accent Color
    final colorValue = prefs.getInt(AppConstants.accentColorKey);
    if (colorValue != null) {
      _accentColor = Color(colorValue);
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.themeKey, mode.index);
  }

  Future<void> setAccentColor(Color color) async {
    if (_accentColor == color) return;
    _accentColor = color;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.accentColorKey, color.toARGB32());
  }
}

final themeManager = ThemeManager();
