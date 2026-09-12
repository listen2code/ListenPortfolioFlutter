import 'package:flutter/material.dart';
import '../shared.dart';

/// ============================================================================
/// AppTheme
/// ============================================================================
/// Centralized factory for generating Material 3 Light and Dark [ThemeData] configurations.
///
/// ### Typography & Font Family Architecture:
/// 1. **Zero-Overhead Font Family Propagation**:
///    Derives primary [fontFamily] and ordered [fontFamilyFallback] directly from
///    the active [SettingManager.fontFamily]. Injects these properties at both the root
///    [ThemeData] level and within individual component sub-themes (AppBar, Dialogs,
///    Tabs, Chips, Inputs, Buttons) to prevent platform-level style overrides.
/// 2. **Multi-Platform Typography Merge & Fallback Pipeline**:
///    Merges Material 2021 platform geometries with [Typography.englishLike2021],
///    and invokes [TextTheme.apply] to uniformly enforce `fontSizeFactor`, `fontFamily`,
///    and `fontFamilyFallback` across all 15 Material typography scale tiers (display,
///    headline, title, body, label).
/// 3. **Material You Dynamic Color Interoperability**:
///    Seamlessly synthesizes accent colors with Android 12+ [dynamicColorScheme] without
///    breaking custom font family inheritance.
class AppTheme {
  AppTheme._();

  /// Generates a Material 3 Light [ThemeData] instance fully configured with the
  /// user's active brand accent color, typography scaling, font family, and fallback chains.
  ///
  /// - [themeManager]: The singleton holding user appearance preferences.
  /// - [dynamicColorScheme]: Optional platform-derived color scheme from Wallpaper/System.
  static ThemeData getLightTheme(SettingManager themeManager, {ColorScheme? dynamicColorScheme}) {
    final accentColor = themeManager.accentColor;
    final fontSizeFactor = themeManager.fontSize.factor;
    final fontFamily = themeManager.fontFamily.fontFamilyName;
    final fontFamilyFallback = themeManager.fontFamily.fontFamilyFallback;
    final effectiveAccentColor = dynamicColorScheme?.primary ?? accentColor;

    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      brightness: Brightness.light,
      colorScheme: dynamicColorScheme ?? ColorScheme.fromSeed(seedColor: accentColor, brightness: Brightness.light),
      iconTheme: IconThemeData(color: effectiveAccentColor),
      primaryIconTheme: IconThemeData(color: effectiveAccentColor),
      listTileTheme: ListTileThemeData(iconColor: effectiveAccentColor),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 18 * fontSizeFactor,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 18 * fontSizeFactor,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          color: Colors.black87,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          fontWeight: FontWeight.normal,
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 12 * fontSizeFactor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        prefixIconColor: effectiveAccentColor,
        suffixIconColor: effectiveAccentColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: effectiveAccentColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          color: Colors.grey,
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          color: effectiveAccentColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveAccentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
            fontSize: 16 * fontSizeFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final baseTextTheme = Typography.englishLike2021
        .merge(Typography.material2021(platform: theme.platform).black)
        .merge(theme.textTheme);

    final basePrimaryTextTheme = Typography.englishLike2021
        .merge(Typography.material2021(platform: theme.platform).black)
        .merge(theme.primaryTextTheme);

    return theme.copyWith(
      textTheme: baseTextTheme.apply(
        fontSizeFactor: fontSizeFactor,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
      primaryTextTheme: basePrimaryTextTheme.apply(
        fontSizeFactor: fontSizeFactor,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
    );
  }

  /// Generates a Material 3 Dark [ThemeData] instance with high-contrast surfaces,
  /// dark-adapted elevation overlays, accent colors, typography scaling, font family,
  /// and fallback chains.
  ///
  /// - [themeManager]: The singleton holding user appearance preferences.
  /// - [dynamicColorScheme]: Optional platform-derived color scheme from Wallpaper/System.
  static ThemeData getDarkTheme(SettingManager themeManager, {ColorScheme? dynamicColorScheme}) {
    final accentColor = themeManager.accentColor;
    final fontSizeFactor = themeManager.fontSize.factor;
    final fontFamily = themeManager.fontFamily.fontFamilyName;
    final fontFamilyFallback = themeManager.fontFamily.fontFamilyFallback;
    final effectiveAccentColor = dynamicColorScheme?.primary ?? accentColor;

    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      brightness: Brightness.dark,
      colorScheme: dynamicColorScheme ?? ColorScheme.fromSeed(seedColor: accentColor, brightness: Brightness.dark),
      iconTheme: IconThemeData(color: effectiveAccentColor),
      primaryIconTheme: IconThemeData(color: effectiveAccentColor),
      listTileTheme: ListTileThemeData(iconColor: effectiveAccentColor),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 18 * fontSizeFactor,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 18 * fontSizeFactor,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          color: Colors.white70,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          fontWeight: FontWeight.normal,
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 12 * fontSizeFactor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        prefixIconColor: effectiveAccentColor,
        suffixIconColor: effectiveAccentColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: effectiveAccentColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          color: Colors.white38,
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 14 * fontSizeFactor,
          color: effectiveAccentColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveAccentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
            fontSize: 16 * fontSizeFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final baseTextTheme = Typography.englishLike2021
        .merge(Typography.material2021(platform: theme.platform).white)
        .merge(theme.textTheme);

    final basePrimaryTextTheme = Typography.englishLike2021
        .merge(Typography.material2021(platform: theme.platform).white)
        .merge(theme.primaryTextTheme);

    return theme.copyWith(
      textTheme: baseTextTheme.apply(
        fontSizeFactor: fontSizeFactor,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
      primaryTextTheme: basePrimaryTextTheme.apply(
        fontSizeFactor: fontSizeFactor,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
    );
  }
}
