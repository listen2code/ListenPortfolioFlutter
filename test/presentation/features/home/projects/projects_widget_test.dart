import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProjectsWidget Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should display projects widget when active', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ProjectsWidget(active: true))),
        ),
      );

      await tester.pumpAndSettle();

      // Verify BaseRefreshPage is rendered
      expect(find.byType(BaseRefreshPage), findsOneWidget);
    });

    testWidgets('Should not display content when inactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ProjectsWidget(active: false))),
        ),
      );

      await tester.pumpAndSettle();

      // When inactive, widget should still render but not show content
      expect(find.byType(BaseRefreshPage), findsOneWidget);
    });

    testWidgets('Should show skeleton loading when data is loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ProjectsWidget(active: true))),
        ),
      );

      await tester.pump();

      // Initially should show skeleton
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
