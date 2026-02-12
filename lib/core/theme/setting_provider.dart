import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Font size options for the app
enum AppFontSize {
  standard(I18nKeys.standard, 1.0, 20.0),
  large(I18nKeys.large, 1.5, 28.0);

  final String label;
  final double factor;
  final double iconSize;

  const AppFontSize(this.label, this.factor, this.iconSize);

  static AppFontSize fromFactor(double? factor) {
    return AppFontSize.values.firstWhere((e) => e.factor == factor, orElse: () => AppFontSize.standard);
  }
}

class SettingManager extends ChangeNotifier {
  static List<Color> accentColors = [
    Colors.blueAccent,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.redAccent,
    Colors.orange,
    Colors.green,
    Colors.teal,
  ];
  static final SettingManager _instance = SettingManager._internal();

  factory SettingManager() => _instance;

  SettingManager._internal() {
    _loadSettings();
  }

  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.blueAccent;
  AppFontSize _fontSize = AppFontSize.standard;
  AppLanguage _language = AppLanguage.system;

  ThemeMode get themeMode => _themeMode;

  Color get accentColor => _accentColor;

  AppFontSize get fontSize => _fontSize;

  AppLanguage get language => _language;

  Locale get locale => _language.locale;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Theme Mode (Index 0 is System)
    final themeIndex = prefs.getInt(AppConstants.themeKey);
    _themeMode = themeIndex != null ? ThemeMode.values[themeIndex] : ThemeMode.system;

    // Load Accent Color
    final colorValue = prefs.getInt(AppConstants.accentColorKey);
    if (colorValue != null) _accentColor = Color(colorValue);

    // Load Font Size
    final factor = prefs.getDouble(AppConstants.fontSizeKey);
    _fontSize = AppFontSize.fromFactor(factor);

    // Load Language
    final langLabel = prefs.getString(AppConstants.languageKey);
    _language = AppLanguage.fromLabel(langLabel);

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

  Future<void> setFontSize(AppFontSize size) async {
    if (_fontSize == size) return;
    _fontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.fontSizeKey, size.factor);
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.languageKey, lang.label);
  }

  Future<void> resetSettings() async {
    _themeMode = ThemeMode.system;
    _accentColor = accentColors.first;
    _fontSize = AppFontSize.standard;
    _language = AppLanguage.system;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

final settingManager = SettingManager();
