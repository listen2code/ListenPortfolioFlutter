import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../shared.dart';

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

/// Font family options for the app
enum AppFontFamily {
  system(I18nKeys.fontFamilySystem, null, null),
  sansSerif(
    I18nKeys.fontFamilySansSerif,
    'sans-serif',
    [
      'PingFang SC',
      'Hiragino Sans',
      'Hiragino Kaku Gothic ProN',
      'Microsoft YaHei',
      'Yu Gothic',
      'Noto Sans SC',
      'Noto Sans JP',
      'SF Pro Text',
      'SF Pro',
      '-apple-system',
      'Segoe UI',
      'Roboto',
      'Arial',
      'Helvetica',
      'sans-serif',
    ],
  ),
  serif(
    I18nKeys.fontFamilySerif,
    'serif',
    [
      'Songti SC',
      'Hiragino Mincho ProN',
      'Yu Mincho',
      'SimSun',
      'NSimSun',
      'STSong',
      'Noto Serif SC',
      'Noto Serif JP',
      'Times New Roman',
      'Georgia',
      'Palatino',
      'serif',
    ],
  ),
  kaiti(
    I18nKeys.fontFamilyKaiti,
    'KaiTi',
    [
      'KaiTi',
      'Kaiti SC',
      'STKaiti',
      'Kaiti TC',
      'KaiTi_GB2312',
      'Klee',
      'Yu Kyokashotai',
      'HGSeikaishotaiPRO',
      'Toppan Bunkyu Midashi Mincho',
      'Snell Roundhand',
      'Bradley Hand',
      'cursive',
    ],
  ),
  rounded(
    I18nKeys.fontFamilyRounded,
    'Yuanti SC',
    [
      'Yuanti SC',
      'Hiragino Maru Gothic ProN',
      'YouYuan',
      'HGMaruGothicMPRO',
      'SF Pro Rounded',
      'Arial Rounded MT Bold',
      'Comic Sans MS',
      'sans-serif',
    ],
  ),
  monospace(
    I18nKeys.fontFamilyMonospace,
    'monospace',
    [
      'Roboto Mono',
      'Consolas',
      'Menlo',
      'Courier New',
      'Courier',
      'PingFang SC',
      'Hiragino Kaku Gothic ProN',
      'MS Gothic',
      'monospace',
    ],
  ),
  cursive(
    I18nKeys.fontFamilyCursive,
    'cursive',
    [
      'Dancing Script',
      'Segoe Script',
      'Snell Roundhand',
      'STXingkai',
      'Chalkduster',
      'Comic Sans MS',
      'KaiTi',
      'cursive',
    ],
  );

  final String label;
  final String? fontFamilyName;
  final List<String>? fontFamilyFallback;

  const AppFontFamily(this.label, this.fontFamilyName, [this.fontFamilyFallback]);

  static AppFontFamily fromName(String? name) {
    if (name == null || name.isEmpty) return AppFontFamily.system;
    return AppFontFamily.values.firstWhere(
      (e) => e.fontFamilyName == name || e.name == name,
      orElse: () => AppFontFamily.system,
    );
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
  AppFontFamily _fontFamily = AppFontFamily.system;
  AppLanguage _language = AppLanguage.system;
  bool _useDynamicColor = defaultTargetPlatform == TargetPlatform.android;

  ThemeMode get themeMode => _themeMode;

  Color get accentColor => _accentColor;

  AppFontSize get fontSize => _fontSize;

  AppFontFamily get fontFamily => _fontFamily;

  AppLanguage get language => _language;

  Locale get locale => _language.locale;

  bool get useDynamicColor => _useDynamicColor;

  /// Load settings from SharedPreferences.
  /// Should be called once at app startup.
  void loadSettings() {
    // Load Theme Mode (Index 0 is System)
    final themeIndex = SpUtil.getInt(AppConstants.themeKey);
    _themeMode = themeIndex != null ? ThemeMode.values[themeIndex] : ThemeMode.system;

    // Load Accent Color
    final colorValue = SpUtil.getInt(AppConstants.accentColorKey);
    if (colorValue != null) _accentColor = Color(colorValue);

    // Load Font Size
    final factor = SpUtil.getDouble(AppConstants.fontSizeKey);
    _fontSize = AppFontSize.fromFactor(factor);

    // Load Font Family
    final fontName = SpUtil.getString(AppConstants.fontFamilyKey);
    _fontFamily = AppFontFamily.fromName(fontName);

    // Load Language
    final langLabel = SpUtil.getString(AppConstants.languageKey);
    _language = AppLanguage.fromLabel(langLabel);

    // Load Dynamic Color
    final defaultVal = defaultTargetPlatform == TargetPlatform.android;
    _useDynamicColor = SpUtil.getBool(AppConstants.useDynamicColorKey, defaultValue: defaultVal);
    if (defaultTargetPlatform != TargetPlatform.android) {
      _useDynamicColor = false;
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await SpUtil.put(AppConstants.themeKey, mode.index);
  }

  Future<void> setAccentColor(Color color) async {
    if (_accentColor == color) return;
    _accentColor = color;
    notifyListeners();
    await SpUtil.put(AppConstants.accentColorKey, color.toARGB32());
  }

  Future<void> setFontSize(AppFontSize size) async {
    if (_fontSize == size) return;
    _fontSize = size;
    notifyListeners();
    await SpUtil.put(AppConstants.fontSizeKey, size.factor);
  }

  Future<void> setFontFamily(AppFontFamily family) async {
    if (_fontFamily == family) return;
    _fontFamily = family;
    notifyListeners();
    await SpUtil.put(AppConstants.fontFamilyKey, family.fontFamilyName ?? '');
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
    await SpUtil.put(AppConstants.languageKey, lang.label);
    
    // Broadcast language change event via EventBus to refresh remote localized data
    eventBus.fire(CommonEvent<AppLanguage>(AppConstants.languageChangedEventKey, data: lang));
  }

  Future<void> setUseDynamicColor(bool use) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    if (_useDynamicColor == use) return;
    _useDynamicColor = use;
    notifyListeners();
    await SpUtil.put(AppConstants.useDynamicColorKey, use);
  }

  Future<void> resetSettings() async {
    _themeMode = ThemeMode.system;
    _accentColor = accentColors.first;
    _fontSize = AppFontSize.standard;
    _fontFamily = AppFontFamily.system;
    _language = AppLanguage.system;
    _useDynamicColor = defaultTargetPlatform == TargetPlatform.android;
    notifyListeners();

    // This clears everything, so be cautious.
    // If you only want to reset settings managed by SettingManager,
    // you should remove keys one by one.
    await SpUtil.clear();
    await SecureStorageUtil.clear();
    await DiskCleanupUtil.clearAllCache();
    EventBus().clearAllSticky();
    // Restore defaults after clearing
    await setThemeMode(_themeMode);
    await setAccentColor(_accentColor);
    await setFontSize(_fontSize);
    await setFontFamily(_fontFamily);
    await setLanguage(_language);
    await setUseDynamicColor(_useDynamicColor);
  }
}

final settingManager = SettingManager();
