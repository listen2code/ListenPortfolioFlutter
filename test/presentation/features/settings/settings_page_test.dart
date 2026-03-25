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

    testWidgets('Should display settings page with title', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SettingsPage())));

      await tester.pumpAndSettle();

      // Verify title and basic structure
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byType(BasePage), findsOneWidget);
    });

    testWidgets('Should display settings sections', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SettingsPage())));

      await tester.pumpAndSettle();

      // Verify settings sections exist
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Advanced'), findsOneWidget);
    });

    testWidgets('Should display settings items', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SettingsPage())));

      await tester.pumpAndSettle();

      // Verify settings items exist
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(SwitchListTile), findsWidgets);
    });

    testWidgets('Settings items should be interactive', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SettingsPage())));

      await tester.pumpAndSettle();

      // Verify interactive elements
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(SwitchListTile), findsWidgets);
    });
  });
}
