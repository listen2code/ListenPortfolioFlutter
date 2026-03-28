import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OverviewWidget Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('Should display overview widget when active', (WidgetTester tester) async {
      container.read(homeViewModelProvider);
      final homeViewModel = container.read(homeViewModelProvider.notifier);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: OverviewWidget(active: true, homeViewModel: homeViewModel)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OverviewWidget), findsOneWidget);
    });

    testWidgets('Should handle inactive state', (WidgetTester tester) async {
      container.read(homeViewModelProvider);
      final homeViewModel = container.read(homeViewModelProvider.notifier);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: OverviewWidget(active: false, homeViewModel: homeViewModel)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OverviewWidget), findsOneWidget);
    });
  });
}
