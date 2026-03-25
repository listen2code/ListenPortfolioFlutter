import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/terms_of_service/terms_of_service_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TermsOfServicePage Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display terms of service page with title', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: TermsOfServicePage())));

      await tester.pumpAndSettle();

      // Verify title and basic structure
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.byType(BasePage), findsOneWidget);
    });

    testWidgets('Should display terms of service content', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: TermsOfServicePage())));

      await tester.pumpAndSettle();

      // Verify content is displayed
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Should display back button', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: TermsOfServicePage())));

      await tester.pumpAndSettle();

      // Verify back button exists
      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}
