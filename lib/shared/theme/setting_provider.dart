import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

/// Font size options for the app
enum AppFontSize {
  standard(I18nKeys.standard, 1.0, 20.0),
  large(I18nKeys.large, 1.3, 28.0);

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
  ];
  static final SettingManager _instance = SettingManager._internal();

  factory SettingManager() => _instance;

  SettingManager._internal();

  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.blueAccent;
  AppFontSize _fontSize = AppFontSize.standard;
  AppLanguage _language = AppLanguage.system;

  ThemeMode get themeMode => _themeMode;

  Color get accentColor => _accentColor;

  AppFontSize get fontSize => _fontSize;

  AppLanguage get language => _language;

  Locale get locale => _language.locale;

  /// Load settings from SharedPreferences.
  /// Should be called once at app startup.
  void loadSettings() {
    // Load Theme Mode (Index 0 is System)
    final themeIndex = SpUtil.getInt(Constants.themeKey);
    _themeMode = themeIndex != null ? ThemeMode.values[themeIndex] : ThemeMode.system;

    // Load Accent Color
    final colorValue = SpUtil.getInt(Constants.accentColorKey);
    if (colorValue != null) _accentColor = Color(colorValue);

    // Load Font Size
    final factor = SpUtil.getDouble(Constants.fontSizeKey);
    _fontSize = AppFontSize.fromFactor(factor);

    // Load Language
    final langLabel = SpUtil.getString(Constants.languageKey);
    _language = AppLanguage.fromLabel(langLabel);

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await SpUtil.put(Constants.themeKey, mode.index);
  }

  Future<void> setAccentColor(Color color) async {
    if (_accentColor == color) return;
    _accentColor = color;
    notifyListeners();
    await SpUtil.put(Constants.accentColorKey, color.toARGB32());
  }

  Future<void> setFontSize(AppFontSize size) async {
    if (_fontSize == size) return;
    _fontSize = size;
    notifyListeners();
    await SpUtil.put(Constants.fontSizeKey, size.factor);
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
    await SpUtil.put(Constants.languageKey, lang.label);
  }

  Future<void> resetSettings() async {
    _themeMode = ThemeMode.system;
    _accentColor = accentColors.first;
    _fontSize = AppFontSize.standard;
    _language = AppLanguage.system;
    notifyListeners();

    // This clears everything, so be cautious.
    // If you only want to reset settings managed by SettingManager,
    // you should remove keys one by one.
    await SpUtil.clear();
    // Restore defaults after clearing
    await setThemeMode(_themeMode);
    await setAccentColor(_accentColor);
    await setFontSize(_fontSize);
    await setLanguage(_language);
  }
}

final settingManager = SettingManager();
