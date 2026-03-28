import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsPage Widget Tests (settings folder)', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('Should display settings page', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SettingsPage())));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);
    });
  });
}
