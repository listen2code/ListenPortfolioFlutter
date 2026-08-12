import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_about_me_use_case.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_projects_use_case.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/about_me_provider.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/projects_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../test_helpers/test_setup.dart';

// Mock classes
class MockGetProjectsUseCase extends Mock implements GetProjectsUseCase {}
class MockGetAboutMeUseCase extends Mock implements GetAboutMeUseCase {}
class FakeBaseParam extends Fake implements BaseParam {}

void main() async {
  // 1. Initialize test binding
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Initialize test environment for network access
  await setupTestEnvironment();

  setUpAll(() {
    registerFallbackValue(FakeBaseParam());
  });

  group('OverviewViewModel Tests', () {
    late ProviderContainer container;
    late OverviewViewModel viewModel;
    late MockGetProjectsUseCase mockGetProjectsUseCase;
    late MockGetAboutMeUseCase mockGetAboutMeUseCase;
    late ProviderSubscription<OverviewState> subscription;
    final List<BaseEffect> emittedEffects = [];

    // Test data
    final testProjects = [
      ProjectModel(id: '1', title: 'Flutter App', subtitle: 'Mobile'),
      ProjectModel(id: '2', title: 'Web Dashboard', subtitle: 'Web'),
      ProjectModel(id: '3', title: 'API Service', subtitle: 'Backend'),
    ];

    final testAboutMeModel = AboutMeModel(
      status: 'Software Engineer',
      jobTitle: 'Senior Flutter Developer',
      bio: 'Passionate about mobile development',
      graduationYear: '2018',
      major: 'Computer Science',
      github: 'https://github.com/testuser',
      certifications: ['Flutter Certified', 'AWS Certified'],
      stats: [
        AboutMeStatModel(id: '1', year: '2023', label: 'Projects Completed', tags: ['Mobile', 'Web']),
      ],
      experiences: [
        ExperienceItemModel(
          title: 'Senior Developer',
          company: 'Tech Corp',
          period: '2020-2023',
          description: 'Led mobile development team',
        ),
      ],
      education: [
        EducationItemModel(
          degree: 'Bachelor of Science',
          school: 'University of Technology',
          period: '2014-2018',
          description: 'Computer Science major',
        ),
      ],
      skills: [
        SkillCategoryModel(category: 'Programming', items: ['Flutter', 'Dart', 'Python']),
      ],
      languages: [LanguageItemModel(name: 'English', level: 'Native')],
    );

    setUp(() async {
      // 2. Mock SharedPreferences for SpUtil
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      mockGetProjectsUseCase = MockGetProjectsUseCase();
      mockGetAboutMeUseCase = MockGetAboutMeUseCase();

      // Stub mocks
      when(() => mockGetProjectsUseCase.call(param: any(named: 'param'))).thenAnswer((_) async => Right(testProjects));
      when(() => mockGetProjectsUseCase.call(param: null)).thenAnswer((_) async => Right(testProjects));
      when(() => mockGetAboutMeUseCase.call(param: any(named: 'param'))).thenAnswer((_) async => Right(testAboutMeModel));
      when(() => mockGetAboutMeUseCase.call(param: null)).thenAnswer((_) async => Right(testAboutMeModel));

      // 3. Create a ProviderContainer for testing
      container = ProviderContainer(
        overrides: [
          getProjectsUseCaseProvider.overrideWith((ref) => mockGetProjectsUseCase),
          getAboutMeUseCaseProvider.overrideWith((ref) => mockGetAboutMeUseCase),
        ],
      );

      // Keep provider alive during async operations
      subscription = container.listen(overviewViewModelProvider, (_, __) {}, fireImmediately: false);

      viewModel = container.read(overviewViewModelProvider.notifier);

      // 4. Record effects
      emittedEffects.clear();
      viewModel.onBindEffect((effect) {
        emittedEffects.add(effect);
      });
    });

    tearDown(() async {
      subscription.close();
      // Wait for any pending async operations before disposing
      await Future.delayed(const Duration(milliseconds: 100));
      container.dispose();
    });

    test('Initial state should be empty and not loaded', () {
      final state = container.read(overviewViewModelProvider);
      expect(state.isInitialLoaded, isFalse);
      expect(state.featuredProjects, isEmpty);
      expect(state.aboutMe, isNull);
    });

    test('Should handle refresh intent and emit LoadingEffect', () async {
      // When - Trigger refresh
      await viewModel.handleIntent(const OverviewIntent.refresh());

      // Wait for async operations to complete
      await Future.delayed(const Duration(milliseconds: 300));

      // Then - State updated with projects
      final state = container.read(overviewViewModelProvider);
      expect(state.isInitialLoaded, isTrue);
      expect(state.featuredProjects.length, equals(3)); // ViewModel takes 2
    });

    test('Should respect onVisible lifecycle', () async {
      // Given - Not loaded
      expect(viewModel.state.isInitialLoaded, isFalse);

      // When - Component becomes visible
      viewModel.onVisible();

      // Wait for async operations to complete
      await Future.delayed(const Duration(milliseconds: 300));

      // Then - Should have triggered refresh and loaded projects
      final state = container.read(overviewViewModelProvider);
      expect(state.isInitialLoaded, isTrue);
      expect(state.featuredProjects.length, equals(3));
    });
  });
}
