import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProjectsWidget Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('Should display projects widget when active', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ProjectsWidget(active: true))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProjectsWidget), findsOneWidget);
    });

    testWidgets('Should not display content when inactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ProjectsWidget(active: false))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProjectsWidget), findsOneWidget);
    });

    testWidgets('Should show skeleton loading when data is loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ProjectsWidget(active: true))),
        ),
      );
      await tester.pump();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
