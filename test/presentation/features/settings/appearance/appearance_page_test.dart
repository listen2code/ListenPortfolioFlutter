import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/appearance_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppearancePage Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display appearance page with title', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AppearancePage())));

      await tester.pumpAndSettle();

      // Verify title and basic structure
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.byType(BasePage), findsOneWidget);
    });

    testWidgets('Should display theme mode options', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AppearancePage())));

      await tester.pumpAndSettle();

      // Verify theme mode section exists
      expect(find.text('Theme Mode'), findsOneWidget);
      expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
    });

    testWidgets('Should display accent color options', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AppearancePage())));

      await tester.pumpAndSettle();

      // Verify accent color section exists
      expect(find.text('Accent Color'), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('Should display font options', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AppearancePage())));

      await tester.pumpAndSettle();

      // Verify font section exists
      expect(find.text('Font'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
