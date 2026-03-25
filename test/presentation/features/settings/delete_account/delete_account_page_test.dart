import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeleteAccountPage Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display delete account page with title', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: DeleteAccountPage())));

      await tester.pumpAndSettle();

      // Verify page title
      expect(find.text('Delete Account'), findsOneWidget);
      expect(find.byType(BasePage), findsOneWidget);
    });

    testWidgets('Should display warning message', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: DeleteAccountPage())));

      await tester.pumpAndSettle();

      // Verify warning content exists
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('Should display account deletion form', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: DeleteAccountPage())));

      await tester.pumpAndSettle();

      // Verify form elements exist
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Delete button should be disabled initially', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: DeleteAccountPage())));

      await tester.pumpAndSettle();

      // Find the delete button and verify it's disabled
      final deleteButton = find.byType(ElevatedButton);
      expect(deleteButton, findsOneWidget);

      final buttonWidget = tester.widget<ElevatedButton>(deleteButton);
      expect(buttonWidget.onPressed, isNull);
    });
  });
}
