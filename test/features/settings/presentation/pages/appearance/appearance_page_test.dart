import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/appearance_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/widgets/accent_color_grid.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/widgets/font_family_option_tile.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/widgets/font_size_option_tile.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/widgets/theme_option_tile.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
  });

  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: AppearancePage(),
      ),
    );
  }

  group('AppearancePage Widget Tests', () {
    testWidgets('should render theme modes, accent color grid, font sizes, and font families', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(I18nKeys.appearance.tr), findsOneWidget);
      expect(find.text(I18nKeys.themeMode.tr.toUpperCase()), findsOneWidget);
      expect(find.byType(ThemeOptionTile), findsNWidgets(3));
      expect(find.byType(AccentColorGrid), findsOneWidget);
      expect(find.byType(FontSizeOptionTile), findsNWidgets(2));
      expect(find.text(I18nKeys.fontFamily.tr.toUpperCase()), findsOneWidget);
      expect(find.byType(FontFamilyOptionTile), findsNWidgets(AppFontFamily.values.length));

      // Tap dark mode tile
      await tester.tap(find.text(I18nKeys.dark.tr));
      await tester.pumpAndSettle();

      // Tap large font tile
      await tester.tap(find.text(I18nKeys.large.tr));
      await tester.pumpAndSettle();

      // Tap Monospace font family tile
      await tester.ensureVisible(find.text(I18nKeys.fontFamilyMonospace.tr));
      await tester.tap(find.text(I18nKeys.fontFamilyMonospace.tr));
      await tester.pumpAndSettle();
      expect(settingManager.fontFamily, AppFontFamily.monospace);

      // Tap Serif font family tile
      await tester.ensureVisible(find.text(I18nKeys.fontFamilySerif.tr));
      await tester.tap(find.text(I18nKeys.fontFamilySerif.tr));
      await tester.pumpAndSettle();
      expect(settingManager.fontFamily, AppFontFamily.serif);

      // Tap light mode tile
      await tester.ensureVisible(find.text(I18nKeys.light.tr));
      await tester.tap(find.text(I18nKeys.light.tr));
      await tester.pumpAndSettle();
    });
  });
}
