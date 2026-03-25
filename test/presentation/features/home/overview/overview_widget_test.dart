import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OverviewWidget Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display overview widget when active', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: OverviewWidget(active: true, homeViewModel: null))),
        ),
      );

      await tester.pumpAndSettle();

      // Verify BaseRefreshPage is rendered
      expect(find.byType(BaseRefreshPage), findsOneWidget);
    });

    testWidgets('Should handle inactive state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: OverviewWidget(active: false, homeViewModel: null))),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should still render when inactive
      expect(find.byType(BaseRefreshPage), findsOneWidget);
    });
  });
}
