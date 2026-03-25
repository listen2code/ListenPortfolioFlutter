import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsPage Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display settings page', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SettingsPage())));

      await tester.pumpAndSettle();

      // Verify BaseRefreshPage is rendered
      expect(find.byType(BaseRefreshPage), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Should display settings options', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SettingsPage())));

      await tester.pumpAndSettle();

      // Verify settings sections exist
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Privacy & Security'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });
  });
}
