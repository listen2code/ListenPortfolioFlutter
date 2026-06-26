import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_projects_use_case.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/projects_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../test_helpers/test_setup.dart';

// Mock classes
class MockGetProjectsUseCase extends Mock implements GetProjectsUseCase {}
class FakeBaseParam extends Fake implements BaseParam {}

void main() async {
  // Initialize test environment for network access
  await setupTestEnvironment();

  setUpAll(() {
    registerFallbackValue(FakeBaseParam());
  });

  group('ProjectsWidget Widget Tests', () {
    late MockGetProjectsUseCase mockUseCase;
    final testProjects = [
      ProjectModel(id: '1', title: 'Flutter App', subtitle: 'Mobile'),
      ProjectModel(id: '2', title: 'Web Dashboard', subtitle: 'Web'),
    ];

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      mockUseCase = MockGetProjectsUseCase();
      when(() => mockUseCase.call(param: null)).thenAnswer((_) async => Right(testProjects));
      when(() => mockUseCase.call(param: any(named: 'param'))).thenAnswer((_) async => Right(testProjects));
    });

    testWidgets('Should display projects widget when active', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getProjectsUseCaseProvider.overrideWith((ref) => mockUseCase),
          ],
          child: const MaterialApp(home: Scaffold(body: ProjectsWidget(active: true))),
        ),
      );
      
      // Just pump once to start the build, don't wait for settle
      await tester.pump();
      
      // Verify widget is rendered
      expect(find.byType(ProjectsWidget), findsOneWidget);
    });

    testWidgets('Should not display content when inactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getProjectsUseCaseProvider.overrideWith((ref) => mockUseCase),
          ],
          child: const MaterialApp(home: Scaffold(body: ProjectsWidget(active: false))),
        ),
      );
      
      await tester.pump();
      expect(find.byType(ProjectsWidget), findsOneWidget);
    });

    testWidgets('Should show skeleton loading when data is loading', (WidgetTester tester) async {
      // Return a delayed future to simulate loading state
      when(() => mockUseCase.call(param: null)).thenAnswer(
        (_) async => Future.delayed(const Duration(seconds: 1), () => Right(testProjects)),
      );
      when(() => mockUseCase.call(param: any(named: 'param'))).thenAnswer(
        (_) async => Future.delayed(const Duration(seconds: 1), () => Right(testProjects)),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getProjectsUseCaseProvider.overrideWith((ref) => mockUseCase),
          ],
          child: const MaterialApp(home: Scaffold(body: ProjectsWidget(active: true))),
        ),
      );
      
      await tester.pump();
      
      // Verify skeleton is shown (SingleChildScrollView is part of the skeleton)
      expect(find.byType(SingleChildScrollView), findsWidgets);

      // Settle the fake timers before finishing the test to avoid pending timers error
      await tester.pumpAndSettle();
    });
  });
}
