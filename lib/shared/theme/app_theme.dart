import 'package:flutter/material.dart';
import '../shared.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  /// Generates Light theme based on accent color, font size factor, and font family
  static ThemeData getLightTheme(SettingManager themeManager, {ColorScheme? dynamicColorScheme}) {
    final accentColor = themeManager.accentColor;
    final fontSizeFactor = themeManager.fontSize.factor;
    final fontFamily = themeManager.fontFamily.fontFamilyName;
    final effectiveAccentColor = dynamicColorScheme?.primary ?? accentColor;

    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.light,
      colorScheme: dynamicColorScheme ?? ColorScheme.fromSeed(seedColor: accentColor, brightness: Brightness.light),
      iconTheme: IconThemeData(color: effectiveAccentColor),
      primaryIconTheme: IconThemeData(color: effectiveAccentColor),
      listTileTheme: ListTileThemeData(iconColor: effectiveAccentColor),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
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
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveAccentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );

    final baseTextTheme = Typography.englishLike2021
        .merge(Typography.material2021(platform: theme.platform).black)
        .merge(theme.textTheme);

    return theme.copyWith(
      textTheme: baseTextTheme.apply(
        fontSizeFactor: fontSizeFactor,
        fontFamily: fontFamily,
      ),
    );
  }

  /// Generates Dark theme based on accent color, font size factor, and font family
  static ThemeData getDarkTheme(SettingManager themeManager, {ColorScheme? dynamicColorScheme}) {
    final accentColor = themeManager.accentColor;
    final fontSizeFactor = themeManager.fontSize.factor;
    final fontFamily = themeManager.fontFamily.fontFamilyName;
    final effectiveAccentColor = dynamicColorScheme?.primary ?? accentColor;

    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      colorScheme: dynamicColorScheme ?? ColorScheme.fromSeed(seedColor: accentColor, brightness: Brightness.dark),
      iconTheme: IconThemeData(color: effectiveAccentColor),
      primaryIconTheme: IconThemeData(color: effectiveAccentColor),
      listTileTheme: ListTileThemeData(iconColor: effectiveAccentColor),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
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
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveAccentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );

    final baseTextTheme = Typography.englishLike2021
        .merge(Typography.material2021(platform: theme.platform).white)
        .merge(theme.textTheme);

    return theme.copyWith(
      textTheme: baseTextTheme.apply(
        fontSizeFactor: fontSizeFactor,
        fontFamily: fontFamily,
      ),
    );
  }
}
