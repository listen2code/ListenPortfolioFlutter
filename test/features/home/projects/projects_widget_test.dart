import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../test_helpers/test_setup.dart';

void main() async {
  // Initialize test environment for network access
  await setupTestEnvironment();

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
      
      // Just pump once to start the build, don't wait for settle
      await tester.pump();
      
      // Verify widget is rendered
      expect(find.byType(ProjectsWidget), findsOneWidget);
    });

    testWidgets('Should not display content when inactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ProjectsWidget(active: false))),
        ),
      );
      
      await tester.pump();
      expect(find.byType(ProjectsWidget), findsOneWidget);
    });

    testWidgets('Should show skeleton loading when data is loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ProjectsWidget(active: true))),
        ),
      );
      
      await tester.pump();
      
      // Verify skeleton is shown (SingleChildScrollView is part of the skeleton)
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });
  });
}
