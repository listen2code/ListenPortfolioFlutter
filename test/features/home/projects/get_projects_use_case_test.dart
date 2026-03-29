import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/repositories/projects_repository.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_projects_use_case.dart';
import 'package:mocktail/mocktail.dart';

///
/// GetProjectsUseCase 单元测试
///
/// 测试覆盖范围：
/// 1. 正常获取项目列表数据（成功场景）
/// 2. 各种失败场景（网络错误、服务器错误、数据解析错误等）
/// 3. 边界情况（空列表、单个项目、大量项目）
/// 4. 错误处理（Repository层错误传递）
///
/// 架构原则：
/// - UseCase层负责协调Repository调用，不包含业务逻辑验证
/// - 所有数据验证逻辑应在ViewModel层或Repository层处理
/// - UseCase直接返回Repository的结果（成功或失败）
///

// Mock repository
class MockProjectsRepository extends Mock implements ProjectsRepository {}

void main() {
  late GetProjectsUseCase useCase;
  late MockProjectsRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectsRepository();
    useCase = GetProjectsUseCase(mockRepository);
  });

  group('GetProjectsUseCase', () {
    // 测试数据
    final testProjectsList = [
      ProjectModel(
        id: '1',
        title: 'E-commerce App',
        subtitle: 'Mobile shopping application',
        desc: 'A full-featured e-commerce app built with Flutter',
        imageUrl: 'https://example.com/ecommerce.jpg',
        githubUrl: 'https://github.com/testuser/ecommerce',
        techStack: ['Flutter', 'Dart', 'Firebase'],
      ),
      ProjectModel(
        id: '2',
        title: 'Weather Dashboard',
        subtitle: 'Real-time weather tracking',
        desc: 'Beautiful weather app with forecasts and maps',
        imageUrl: 'https://example.com/weather.jpg',
        githubUrl: 'https://github.com/testuser/weather',
        techStack: ['Flutter', 'Dart', 'OpenWeather API'],
      ),
      ProjectModel(
        id: '3',
        title: 'Task Manager',
        subtitle: 'Productivity application',
        desc: 'Intuitive task management with team collaboration',
        imageUrl: 'https://example.com/tasks.jpg',
        githubUrl: 'https://github.com/testuser/tasks',
        techStack: ['Flutter', 'Dart', 'SQLite'],
      ),
    ];

    test('should return List<ProjectModel> when repository call is successful', () async {
      // Arrange: Mock repository to return success with test data
      when(() => mockRepository.getProjects()).thenAnswer((_) async => Right(testProjectsList));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, Right<Failure, List<ProjectModel>>(testProjectsList));
      result.fold((failure) => fail('Expected Right but got Left: $failure'), (projects) {
        expect(projects.length, 3);
        expect(projects[0].title, 'E-commerce App');
        expect(projects[1].techStack, contains('OpenWeather API'));
      });
      verify(() => mockRepository.getProjects()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository returns ServerFailure', () async {
      // Arrange
      const serverFailure = ServerFailure('Server error occurred');
      when(() => mockRepository.getProjects()).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, List<ProjectModel>>(serverFailure));
      verify(() => mockRepository.getProjects()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const networkFailure = NetworkFailure('Network connection failed');
      when(() => mockRepository.getProjects()).thenAnswer((_) async => const Left(networkFailure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, List<ProjectModel>>(networkFailure));
      verify(() => mockRepository.getProjects()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when local cache error occurs', () async {
      // Arrange
      const cacheFailure = CacheFailure('Cache read error');
      when(() => mockRepository.getProjects()).thenAnswer((_) async => const Left(cacheFailure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, List<ProjectModel>>(cacheFailure));
      verify(() => mockRepository.getProjects()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty projects list correctly', () async {
      // Arrange
      final emptyProjectsList = <ProjectModel>[];
      when(() => mockRepository.getProjects()).thenAnswer((_) async => Right(emptyProjectsList));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, Right<Failure, List<ProjectModel>>(emptyProjectsList));
      result.fold((failure) => fail('Expected Right but got Left: $failure'), (projects) {
        expect(projects, isEmpty);
        expect(projects.length, 0);
      });
      verify(() => mockRepository.getProjects()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle single project correctly', () async {
      // Arrange
      final singleProjectList = [
        ProjectModel(
          id: '1',
          title: 'Single Project',
          subtitle: 'Solo development project',
          desc: 'A project developed independently',
          imageUrl: 'https://example.com/single.jpg',
          githubUrl: 'https://github.com/testuser/single',
          techStack: ['Flutter', 'Dart'],
        ),
      ];
      when(() => mockRepository.getProjects()).thenAnswer((_) async => Right(singleProjectList));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, Right<Failure, List<ProjectModel>>(singleProjectList));
      result.fold((failure) => fail('Expected Right but got Left: $failure'), (projects) {
        expect(projects.length, 1);
        expect(projects[0].title, 'Single Project');
      });
      verify(() => mockRepository.getProjects()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle large projects list correctly', () async {
      // Arrange
      final largeProjectsList = List.generate(
        50,
        (index) => ProjectModel(
          id: '${index + 1}',
          title: 'Project ${index + 1}',
          subtitle: 'Project subtitle ${index + 1}',
          desc: 'Description for project ${index + 1}',
          imageUrl: 'https://example.com/project${index + 1}.jpg',
          githubUrl: 'https://github.com/testuser/project${index + 1}',
          techStack: ['Flutter', 'Dart', 'Technology ${index + 1}'],
        ),
      );
      when(() => mockRepository.getProjects()).thenAnswer((_) async => Right(largeProjectsList));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, Right<Failure, List<ProjectModel>>(largeProjectsList));
      result.fold((failure) => fail('Expected Right but got Left: $failure'), (projects) {
        expect(projects.length, 50);
        expect(projects[0].title, 'Project 1');
        expect(projects[49].title, 'Project 50');
      });
      verify(() => mockRepository.getProjects()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle ProjectModel with minimal data correctly', () async {
      // Arrange
      final minimalProject = ProjectModel(
        id: 'minimal',
        title: 'Minimal Project',
        subtitle: null,
        desc: null,
        imageUrl: null,
        githubUrl: null,
        techStack: [],
      );
      final minimalProjectsList = [minimalProject];
      when(() => mockRepository.getProjects()).thenAnswer((_) async => Right(minimalProjectsList));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, Right<Failure, List<ProjectModel>>(minimalProjectsList));
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (projects) {
          expect(projects[0].title, 'Minimal Project');
          expect(projects[0].subtitle, isNull);
          expect(projects[0].desc, isNull);
          expect(projects[0].techStack, isEmpty);
        },
      );
      verify(() => mockRepository.getProjects()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass through BaseParam correctly', () async {
      // Arrange
      final testParam = BaseParam();
      when(() => mockRepository.getProjects()).thenAnswer((_) async => Right(testProjectsList));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, Right<Failure, List<ProjectModel>>(testProjectsList));
      verify(() => mockRepository.getProjects()).called(1);
      verifyNoMoreInteractions(mockRepository);
      // Note: BaseParam is not used in this use case, but we verify it doesn't break the call
    });

    test('should handle repository exceptions gracefully', () async {
      // Arrange
      when(() => mockRepository.getProjects()).thenThrow(Exception('Unexpected repository error'));

      // Act & Assert
      expect(() => useCase(param: null), throwsA(isA<Exception>()));
    });
  });
}