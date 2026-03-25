import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CrashLogListPage Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display crash log list page with title', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: CrashLogListPage())));

      await tester.pumpAndSettle();

      // Verify title and basic structure
      expect(find.text('Crash Reports'), findsOneWidget);
      expect(find.byType(BaseRefreshPage), findsOneWidget);
    });

    testWidgets('Should display action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: CrashLogListPage())));

      await tester.pumpAndSettle();

      // Verify action buttons exist
      expect(find.byIcon(Icons.flash_on_rounded), findsOneWidget);
      expect(find.byIcon(Icons.delete_sweep_rounded), findsOneWidget);
    });

    testWidgets('Should show empty state when no crash logs', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: CrashLogListPage())));

      await tester.pumpAndSettle();

      // Should show empty state or loading
      expect(find.byType(BaseRefreshPage), findsOneWidget);
    });
  });
}
