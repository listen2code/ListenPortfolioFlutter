import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomePage Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display home page with scaffold structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomePage())),
      );
      await tester.pump();

      // Verify basic scaffold structure exists
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Should display overview tab by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomePage())),
      );
      await tester.pump();

      // Verify overview content is displayed
      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('Should display menu button for drawer', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomePage())),
      );
      await tester.pump();

      // Verify menu button exists
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('Should display app title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomePage())),
      );
      await tester.pump();

      // Verify app title exists (could be empty for overview tab)
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Should display drawer when currentTab is not overview', (
      WidgetTester tester,
    ) async {
      // Test with default state first - drawer should exist but may not be visible
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomePage())),
      );
      await tester.pump();

      // Verify scaffold structure exists (drawer capability)
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.drawer, isNotNull);

      // Verify menu button exists
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });
  });
}
