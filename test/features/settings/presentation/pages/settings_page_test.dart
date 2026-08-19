import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:listen_portfolio_flutter/shared/services/shorebird/shorebird_service.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
    shorebirdService = ShorebirdServiceImpl();
  });

  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: SettingsPage(),
      ),
    );
  }

  group('SettingsPage Widget Tests', () {
    testWidgets('renders all settings sections and tiles correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.text(I18nKeys.settings.tr), findsOneWidget);
      expect(find.byType(CommonSettingsSectionTitle), findsWidgets);
      expect(find.byType(CommonSettingsCard), findsWidgets);
      expect(find.byType(CommonSettingsTile), findsWidgets);

      expect(find.text(I18nKeys.appearance.tr), findsOneWidget);
      expect(find.text(I18nKeys.language.tr), findsOneWidget);
      expect(find.text(I18nKeys.changePassword.tr), findsOneWidget);
      expect(find.text(I18nKeys.clearCache.tr), findsOneWidget);
    });
  });
}
