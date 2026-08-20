import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/shared/extensions/string_extension.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers/test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setupTestEnvironment();
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init(prefix: 'test_');
    settingManager.loadSettings();
  });

  group('StringUrlExtension Tests', () {
    test('toApiUrl converts localhost URLs to current environment base URL', () {
      expect(''.toApiUrl(), '');
      expect('https://api.example.com/data'.toApiUrl(), 'https://api.example.com/data');
      expect('localhost/projects'.toApiUrl(), contains('/projects'));
    });
  });

  group('Theme and SettingManager Tests', () {
    test('AppFontSize values and fromFactor conversion', () {
      expect(AppFontSize.fromFactor(1.0), AppFontSize.standard);
      expect(AppFontSize.fromFactor(1.3), AppFontSize.large);
      expect(AppFontSize.fromFactor(99.0), AppFontSize.standard);
    });

    test('AppFontFamily values and fromName conversion', () {
      expect(AppFontFamily.fromName(null), AppFontFamily.system);
      expect(AppFontFamily.fromName(''), AppFontFamily.system);
      expect(AppFontFamily.fromName('sans-serif'), AppFontFamily.sansSerif);
      expect(AppFontFamily.fromName('serif'), AppFontFamily.serif);
      expect(AppFontFamily.fromName('monospace'), AppFontFamily.monospace);
      expect(AppFontFamily.fromName('cursive'), AppFontFamily.cursive);
      expect(AppFontFamily.fromName('unknown'), AppFontFamily.system);
    });

    test('SettingManager update methods work correctly', () async {
      await settingManager.setThemeMode(ThemeMode.dark);
      expect(settingManager.themeMode, ThemeMode.dark);

      await settingManager.setAccentColor(Colors.purple);
      expect(settingManager.accentColor, Colors.purple);

      await settingManager.setFontSize(AppFontSize.large);
      expect(settingManager.fontSize, AppFontSize.large);
      expect(10.f, 13.0);

      await settingManager.setFontFamily(AppFontFamily.monospace);
      expect(settingManager.fontFamily, AppFontFamily.monospace);

      await settingManager.setLanguage(AppLanguage.chinese);
      expect(settingManager.language, AppLanguage.chinese);

      await settingManager.setUseDynamicColor(false);
      expect(settingManager.useDynamicColor, isFalse);

      // Reset to defaults
      await settingManager.resetSettings();
      expect(settingManager.themeMode, ThemeMode.system);
      expect(settingManager.fontFamily, AppFontFamily.system);
    });

    testWidgets('BuildContextX and AppTheme integration', (WidgetTester tester) async {
      late bool isDarkMode;
      late double scaleFactor;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.getLightTheme(settingManager),
          darkTheme: AppTheme.getDarkTheme(settingManager),
          themeMode: ThemeMode.light,
          home: Builder(
            builder: (context) {
              isDarkMode = context.isDark;
              scaleFactor = context.fontFactor;
              return Scaffold(
                body: Text('Theme Check', style: TextStyle(fontSize: 16.f)),
              );
            },
          ),
        ),
      );

      expect(isDarkMode, isFalse);
      expect(scaleFactor, isNotNull);
      expect(find.text('Theme Check'), findsOneWidget);
    });
  });
}
