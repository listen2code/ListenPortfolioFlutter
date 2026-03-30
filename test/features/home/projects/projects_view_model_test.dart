import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_projects_use_case.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/projects_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock class
class MockGetProjectsUseCase extends Mock implements GetProjectsUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProjectsViewModel Tests', () {
    late ProviderContainer container;
    late ProjectsViewModel viewModel;
    late MockGetProjectsUseCase mockUseCase;
    late ProviderSubscription<ProjectsState> subscription;
    final List<BaseEffect> emittedEffects = [];

    final testProjects = [
      ProjectModel(id: '1', title: 'Flutter App', subtitle: 'Mobile'),
      ProjectModel(id: '2', title: 'Web Dashboard', subtitle: 'Web'),
      ProjectModel(id: '3', title: 'API Service', subtitle: 'Backend'),
    ];

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      mockUseCase = MockGetProjectsUseCase();

      container = ProviderContainer(
        overrides: [
          getProjectsUseCaseProvider.overrideWith((ref) => mockUseCase),
        ],
      );

      subscription = container.listen(
        projectsViewModelProvider,
        (_, __) {},
        fireImmediately: false,
      );
      viewModel = container.read(projectsViewModelProvider.notifier);
      emittedEffects.clear();
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));
    });

    tearDown(() {
      subscription.close();
      container.dispose();
    });

    group('Initial State', () {
      test('should have correct default initial state', () {
        final state = container.read(projectsViewModelProvider);
        expect(state.isInitialLoaded, isFalse);
        expect(state.projects, isEmpty);
      });
    });

    group('Refresh Intent — Success', () {
      test('should update state with projects on successful refresh', () async {
        // Arrange
        when(() => mockUseCase.call(param: null))
            .thenAnswer((_) async => Right(testProjects));

        // Act
        await viewModel.handleIntent(const ProjectsIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert
        final state = container.read(projectsViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.projects.length, testProjects.length);
      });

      test('should set isInitialLoaded to true after successful refresh', () async {
        // Arrange
        when(() => mockUseCase.call(param: null))
            .thenAnswer((_) async => Right(testProjects));

        // Act
        await viewModel.handleIntent(const ProjectsIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert
        expect(container.read(projectsViewModelProvider).isInitialLoaded, isTrue);
      });

      test('should handle empty project list from server', () async {
        // Arrange
        when(() => mockUseCase.call(param: null))
            .thenAnswer((_) async => const Right([]));

        // Act
        await viewModel.handleIntent(const ProjectsIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert
        final state = container.read(projectsViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.projects, isEmpty);
      });
    });

    group('Refresh Intent — Failure', () {
      test('should NOT set isInitialLoaded on server failure', () async {
        // Arrange
        const failure = ServerFailure('Failed to load projects');
        when(() => mockUseCase.call(param: null))
            .thenAnswer((_) async => const Left(failure));

        // Act
        await viewModel.handleIntent(const ProjectsIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert
        final state = container.read(projectsViewModelProvider);
        expect(state.isInitialLoaded, isFalse);
        expect(state.projects, isEmpty);
      });

      test('should NOT update projects on network failure', () async {
        // Arrange
        const failure = NetworkFailure('No internet connection');
        when(() => mockUseCase.call(param: null))
            .thenAnswer((_) async => const Left(failure));

        // Act
        await viewModel.handleIntent(const ProjectsIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert
        expect(container.read(projectsViewModelProvider).projects, isEmpty);
      });
    });

    group('onVisible Lifecycle', () {
      test('should trigger refresh on first onVisible call', () async {
        // Arrange
        when(() => mockUseCase.call(param: null))
            .thenAnswer((_) async => Right(testProjects));

        // Act
        viewModel.onVisible();
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert
        final state = container.read(projectsViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.projects.length, testProjects.length);
      });

      test('should NOT re-trigger refresh when already loaded', () async {
        // Arrange — load once
        when(() => mockUseCase.call(param: null))
            .thenAnswer((_) async => Right(testProjects));

        await viewModel.handleIntent(const ProjectsIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));
        expect(container.read(projectsViewModelProvider).isInitialLoaded, isTrue);

        clearInteractions(mockUseCase);

        // Act — trigger onVisible again
        viewModel.onVisible();
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert — use case should NOT be called again
        verifyNever(() => mockUseCase.call(param: null));
      });
    });
  });
}
