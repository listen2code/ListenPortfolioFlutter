import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Initialize test binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginPage Widget Tests', () {
    setUp(() {
      // 2. Mock SharedPreferences initial values
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display login form elements', (WidgetTester tester) async {
      // 3. Build UI and trigger frame
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      // 4. Wait for animations/async loads
      await tester.pumpAndSettle();

      // 5. Verify key elements exist
      expect(find.byType(Hero), findsOneWidget); // Logo
      expect(find.byType(TextFormField), findsNWidgets(2)); // User & Pass
      expect(find.byType(ElevatedButton), findsOneWidget); // Login button
    });

    testWidgets('Entering text should update state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      // Enter username
      await tester.enterText(find.byType(TextFormField).first, 'test_user');
      await tester.pump();

      // Verify input value
      expect(find.text('test_user'), findsOneWidget);
    });
  });
}
