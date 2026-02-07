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
  double _fontSizeFactor = 1.0;
  String _language = 'English';

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  double get fontSizeFactor => _fontSizeFactor;
  String get language => _language;

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

    // Load Font Size
    _fontSizeFactor = prefs.getDouble(AppConstants.fontSizeKey) ?? 1.0;

    // Load Language
    _language = prefs.getString(AppConstants.languageKey) ?? 'English';

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

  Future<void> setFontSizeFactor(double factor) async {
    if (_fontSizeFactor == factor) return;
    _fontSizeFactor = factor;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.fontSizeKey, factor);
  }

  Future<void> setLanguage(String lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.languageKey, lang);
  }
}

final themeManager = ThemeManager();
