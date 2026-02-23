import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/shared/theme/setting_provider.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  /// Generates Light theme based on accent color and font size factor
  static ThemeData getLightTheme(SettingManager themeManager) {
    final accentColor = themeManager.accentColor;
    final fontSizeFactor = themeManager.fontSize.factor;

    final theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: accentColor, brightness: Brightness.light),
      iconTheme: IconThemeData(color: accentColor),
      primaryIconTheme: IconThemeData(color: accentColor),
      listTileTheme: ListTileThemeData(iconColor: accentColor),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );

    final baseTextTheme = Typography.englishLike2021
        .merge(Typography.material2021(platform: theme.platform).black)
        .merge(theme.textTheme);

    return theme.copyWith(textTheme: baseTextTheme.apply(fontSizeFactor: fontSizeFactor));
  }

  /// Generates Dark theme based on accent color and font size factor
  static ThemeData getDarkTheme(SettingManager themeManager) {
    final accentColor = themeManager.accentColor;
    final fontSizeFactor = themeManager.fontSize.factor;

    final theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: accentColor, brightness: Brightness.dark),
      iconTheme: IconThemeData(color: accentColor),
      primaryIconTheme: IconThemeData(color: accentColor),
      listTileTheme: ListTileThemeData(iconColor: accentColor),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );

    final baseTextTheme = Typography.englishLike2021
        .merge(Typography.material2021(platform: theme.platform).white)
        .merge(theme.textTheme);

    return theme.copyWith(textTheme: baseTextTheme.apply(fontSizeFactor: fontSizeFactor));
  }
}
