import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_widget.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AboutMeWidget Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display about me widget when active', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: AboutMeWidget(active: true))),
        ),
      );

      await tester.pumpAndSettle();

      // Verify BaseRefreshPage is rendered
      expect(find.byType(BaseRefreshPage), findsOneWidget);
    });

    testWidgets('Should handle inactive state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AboutMeWidget(active: false)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should still render when inactive
      expect(find.byType(BaseRefreshPage), findsOneWidget);
    });
  });
}
