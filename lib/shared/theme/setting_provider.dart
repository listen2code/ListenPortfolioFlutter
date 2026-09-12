import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../shared.dart';

/// ============================================================================
/// AppFontSize
/// ============================================================================
/// Represents supported global typography scaling tiers across the application.
///
/// Combines a localized display label with a proportional [factor] used by
/// [TextTheme.apply] and [NumScaleX.f] to scale font sizes app-wide, and an
/// [iconSize] for responsive preview badges.
enum AppFontSize {
  standard(I18nKeys.standard, 1.0, 20.0),
  large(I18nKeys.large, 1.3, 28.0);

  /// Localized translation key for the font size label.
  final String label;

  /// Proportional scaling multiplier applied to all [TextStyle.fontSize] instances.
  final double factor;

  /// Diameter/size of preview iconography associated with this scale tier.
  final double iconSize;

  const AppFontSize(this.label, this.factor, this.iconSize);

  /// Resolves an [AppFontSize] instance from a persisted [factor], defaulting to [standard].
  static AppFontSize fromFactor(double? factor) {
    return AppFontSize.values.firstWhere((e) => e.factor == factor, orElse: () => AppFontSize.standard);
  }
}

/// ============================================================================
/// AppFontFamily
/// ============================================================================
/// Represents supported cross-platform font families and their system fallback chains.
///
/// ### Architecture & Zero-Overhead Strategy:
/// 1. **Zero Asset & Network Overhead**:
///    Instead of bundling multi-megabyte font files (OTF/TTF) inside the APK/AAB or
///    downloading them at runtime over flaky mobile networks, this system maps to
///    high-quality system fonts already pre-installed on iOS, macOS, Android, and Windows.
/// 2. **Multi-Platform CJK Fallback Chains**:
///    Because Chinese (Simplified/Traditional), Japanese (Kanji/Kana), and Western glyphs
///    are often distributed across different system font files (e.g., `PingFang SC` on iOS,
///    `Hiragino Sans` in macOS/iOS for Japanese, `Microsoft YaHei` on Windows, `Noto Sans` on Android),
///    each generic family declares an ordered [fontFamilyFallback] list ensuring zero missing glyphs
///    (tofu-free rendering).
/// 3. **Instant Live Switching**:
///    Combined with [SettingManager] and [ListenableBuilder], changing this enum triggers
///    a seamless top-level [ThemeData] hot-rebuild across the entire widget tree.
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

  /// Translation key representing the font family display name.
  final String label;

  /// Primary CSS / generic / PostScript font family name passed to Flutter engine (e.g., `'sans-serif'`, `'serif'`).
  final String? fontFamilyName;

  /// Ordered fallback chain of installed system font names prioritized during glyph resolution.
  final List<String>? fontFamilyFallback;

  const AppFontFamily(this.label, this.fontFamilyName, [this.fontFamilyFallback]);

  /// Safely resolves an [AppFontFamily] enum from a persisted name or key.
  ///
  /// Falls back gracefully to [system] if null, empty, or unparseable.
  static AppFontFamily fromName(String? name) {
    if (name == null || name.isEmpty) return AppFontFamily.system;
    return AppFontFamily.values.firstWhere(
      (e) => e.fontFamilyName == name || e.name == name,
      orElse: () => AppFontFamily.system,
    );
  }
}

/// ============================================================================
/// SettingManager
/// ============================================================================
/// Centralized singleton state coordinator for global application appearance,
/// theme mode, typography (font family and scaling), locale, and dynamic colors.
///
/// ### Architecture & UX Rationale:
/// 1. **Zero FOUT (Flash of Unstyled Text) Startup Hydration**:
///    [loadSettings] is executed synchronously during [AppInitializer.init] before
///    [runApp] is called. This guarantees that the very first frame rendered by
///    Flutter's engine already uses the user's custom font family and scale factor.
/// 2. **Observable Broadcast Pipeline**:
///    Extends [ChangeNotifier] to integrate directly with [BaseSettingPage] and
///    [ListenableBuilder], triggering top-level [ThemeData] rebuilds across the entire
///    navigator tree without requiring heavy state management overhead for theme toggles.
/// 3. **Fault-Tolerant Persistence**:
///    All updates immediately notify active listeners in memory and asynchronously
///    persist to [SpUtil] (SharedPreferences) to survive app restarts.
class SettingManager extends ChangeNotifier {
  /// Curated palette of high-contrast accent colors available for user selection.
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

  /// The active theme mode (system, light, or dark).
  ThemeMode get themeMode => _themeMode;

  /// The user-selected primary brand accent color.
  Color get accentColor => _accentColor;

  /// The global typography scaling tier.
  AppFontSize get fontSize => _fontSize;

  /// The global font family configuration and fallback chain.
  AppFontFamily get fontFamily => _fontFamily;

  /// The active application language configuration.
  AppLanguage get language => _language;

  /// Locale derived from current language setting.
  Locale get locale => _language.locale;

  /// Whether Material You Dynamic Theming is active on Android.
  bool get useDynamicColor => _useDynamicColor;

  /// Loads persisted appearance and localization settings from [SpUtil].
  ///
  /// Executed once during startup in [AppInitializer] to ensure zero visual flickering.
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

  /// Updates global font scaling and triggers reactive layout adjustments.
  Future<void> setFontSize(AppFontSize size) async {
    if (_fontSize == size) return;
    _fontSize = size;
    notifyListeners();
    await SpUtil.put(AppConstants.fontSizeKey, size.factor);
  }

  /// Updates global font family selection, triggers root [ThemeData] hot-rebuild,
  /// and asynchronously persists the choice to [SpUtil].
  Future<void> setFontFamily(AppFontFamily family) async {
    if (_fontFamily == family) return;
    _fontFamily = family;
    notifyListeners();
    await SpUtil.put(AppConstants.fontFamilyKey, family.fontFamilyName ?? '');
  }

  /// Updates application locale, triggers UI re-translation, and fires an event.
  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
    await SpUtil.put(AppConstants.languageKey, lang.label);
    
    // Broadcast language change event via EventBus to refresh remote localized data
    eventBus.fire(CommonEvent<AppLanguage>(AppConstants.languageChangedEventKey, data: lang));
  }

  /// Toggles Material You dynamic theming on Android.
  Future<void> setUseDynamicColor(bool use) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    if (_useDynamicColor == use) return;
    _useDynamicColor = use;
    notifyListeners();
    await SpUtil.put(AppConstants.useDynamicColorKey, use);
  }

  /// Resets all appearance, theme, and font settings to system defaults and wipes disk caches.
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
