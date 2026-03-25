import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/privacy_policy/privacy_policy_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrivacyPolicyPage Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display privacy policy page with title', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: PrivacyPolicyPage())));

      await tester.pumpAndSettle();

      // Verify title and basic structure
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.byType(BasePage), findsOneWidget);
    });

    testWidgets('Should display privacy policy content', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: PrivacyPolicyPage())));

      await tester.pumpAndSettle();

      // Verify content is displayed
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Should display back button', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: PrivacyPolicyPage())));

      await tester.pumpAndSettle();

      // Verify back button exists
      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}
