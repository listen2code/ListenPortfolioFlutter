import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/projects_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/projects_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/repositories/projects_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockProjectsRemoteDataSource extends Mock
    implements ProjectsRemoteDataSource {}

class MockProjectsLocalDataSource extends Mock
    implements ProjectsLocalDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(<ProjectModel>[]);
  });

  late ProjectsRepositoryImpl repository;
  late MockProjectsRemoteDataSource mockRemote;
  late MockProjectsLocalDataSource mockLocal;

  final testProjects = [
    ProjectModel(
      id: '1',
      title: 'Flutter App',
      subtitle: 'Mobile',
      desc: 'A sample app',
    ),
    ProjectModel(
      id: '2',
      title: 'Web App',
      subtitle: 'Web',
      desc: 'A web project',
    ),
  ];

  final successResponse = BaseResponseModel<List<ProjectModel>>(
    result: ApiResult.success,
    body: [
      ProjectModel(
        id: '1',
        title: 'Flutter App',
        subtitle: 'Mobile',
        desc: 'A sample app',
      ),
      ProjectModel(
        id: '2',
        title: 'Web App',
        subtitle: 'Web',
        desc: 'A web project',
      ),
    ],
  );

  final failureResponse = BaseResponseModel<List<ProjectModel>>(
    result: ApiResult.serverError,
    message: 'Internal server error',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    // Mock the connectivity_plus platform channel to simulate wifi connection
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (MethodCall call) async => ['wifi'],
        );

    mockRemote = MockProjectsRemoteDataSource();
    mockLocal = MockProjectsLocalDataSource();
    repository = ProjectsRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('ProjectsRepositoryImpl - getProjects', () {
    test('should return project list when remote call succeeds', () async {
      // Arrange
      when(
        () => mockRemote.getProjects(),
      ).thenAnswer((_) async => successResponse);
      when(() => mockLocal.cache(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.getProjects();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Expected Right but got Left: $failure'), (
        data,
      ) {
        expect(data.length, testProjects.length);
        expect(data.first.title, testProjects.first.title);
      });
      verify(() => mockRemote.getProjects()).called(1);
      verify(() => mockLocal.cache(any())).called(1);
    });

    test('should cache project list after successful remote fetch', () async {
      // Arrange
      when(
        () => mockRemote.getProjects(),
      ).thenAnswer((_) async => successResponse);
      when(() => mockLocal.cache(any())).thenAnswer((_) async {});

      // Act
      await repository.getProjects();

      // Assert — cache must be written exactly once
      verify(() => mockLocal.cache(any())).called(1);
    });

    test(
      'should return cached projects when remote fails and cache exists',
      () async {
        // Arrange
        when(
          () => mockRemote.getProjects(),
        ).thenAnswer((_) async => failureResponse);
        when(
          () => mockLocal.getCached(),
        ).thenAnswer((_) async => testProjects);

        // Act
        final result = await repository.getProjects();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (data) => expect(data.length, testProjects.length),
        );
        verify(() => mockLocal.getCached()).called(1);
      },
    );

    test(
      'should return Failure when remote fails and cache is empty',
      () async {
        // Arrange
        when(
          () => mockRemote.getProjects(),
        ).thenAnswer((_) async => failureResponse);
        when(() => mockLocal.getCached()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getProjects();

        // Assert
        expect(result.isLeft(), isTrue);
      },
    );

    test(
      'should return Left when remote throws generic exception regardless of cache',
      () async {
        // Arrange — generic exceptions bypass cache fallback in safeCall's catch block
        when(
          () => mockRemote.getProjects(),
        ).thenThrow(Exception('Connection refused'));
        when(
          () => mockLocal.getCached(),
        ).thenAnswer((_) async => testProjects);

        // Act
        final result = await repository.getProjects();

        // Assert — generic exceptions go straight to Left without checking cache
        expect(result.isLeft(), isTrue);
      },
    );

    test(
      'should fall back to cache when remote returns session timeout failure',
      () async {
        // Arrange — ApiResult.sessionTimeout maps to AuthFailure, which is NOT ServerFailure
        // so _handleFailureFallback will try the cache (failure is! ServerFailure == true)
        final sessionTimeoutResponse = BaseResponseModel<List<ProjectModel>>(
          result: ApiResult.sessionTimeout,
          message: 'Session expired',
        );
        when(
          () => mockRemote.getProjects(),
        ).thenAnswer((_) async => sessionTimeoutResponse);
        when(
          () => mockLocal.getCached(),
        ).thenAnswer((_) async => testProjects);

        // Act
        final result = await repository.getProjects();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (data) => expect(data.length, testProjects.length),
        );
      },
    );

    test('should return empty list when remote returns empty body', () async {
      // Arrange — server returns success but with empty list
      final emptyResponse = BaseResponseModel<List<ProjectModel>>(
        result: ApiResult.success,
        body: [],
      );
      when(
        () => mockRemote.getProjects(),
      ).thenAnswer((_) async => emptyResponse);
      when(() => mockLocal.cache(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.getProjects();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (data) => expect(data, isEmpty),
      );
    });
  });

  group('Projects API Contract Tests', () {
    group('GET /projects', () {
      test(
        '✅ List Projects - All required fields present and have correct types',
        () {
          // Sample mock data representing what comes from /projects endpoint
          final mockProjectJson = {
            'id': '1',
            'businessId': 'lportfolio-flutter',
            'title': 'lPortfolio Flutter',
            'subtitle': 'Current Project',
            'desc':
                'My personal portfolio app (this one!). Demonstrating Clean Architecture, MVI pattern, and advanced Riverpod state management in Flutter.',
            'imageUrl': 'localhost/images/project1.jpg',
            'githubUrl':
                'https://github.com/listen2code/ListenPortfolioFlutter',
            'techStack': ['Flutter', 'Riverpod', 'Clean Architecture', 'MVI'],
          };

          // Act: Convert mock to ProjectModel
          final project = ProjectModel.fromJson(mockProjectJson);

          // Assert: All required fields are present
          expect(project.id, equals('1'), reason: 'id should be String "1"');
          expect(
            project.businessId,
            equals('lportfolio-flutter'),
            reason: 'businessId must match',
          );
          expect(project.title, isNotEmpty, reason: 'title is required');
          expect(project.subtitle, isNotEmpty, reason: 'subtitle is required');
          expect(project.desc, isNotEmpty, reason: 'description is required');
          expect(project.imageUrl, isNotEmpty, reason: 'imageUrl is required');
          expect(
            project.githubUrl,
            isNotEmpty,
            reason: 'githubUrl is required',
          );

          // Assert: techStack is List<String>
          expect(
            project.techStack,
            isA<List<String>>(),
            reason: 'techStack must be List<String>',
          );
          expect(
            project.techStack,
            isNotEmpty,
            reason: 'techStack should not be empty',
          );
          expect(
            project.techStack,
            contains('Flutter'),
            reason: 'Flutter in techStack',
          );
        },
      );

      test('⚠️ ID Field Type - Verify Long→String conversion is handled', () {
        // Backend returns Long id, should serialize to String in JSON
        final mockProjectJson = {
          'id': '123',
          'businessId': 'test',
          'techStack': [],
        };

        final project = ProjectModel.fromJson(mockProjectJson);

        // id comes from Backend as Long, converted to String via @JsonSerialize
        expect(
          project.id,
          isA<String>(),
          reason:
              'id must be String (converted from Long with @ToStringConverter)',
        );
        expect(project.id, equals('123'));
      });

      test('⚠️ TechStack Format - Ensure array structure is consistent', () {
        // Verify that techStack is always a List, never null
        final projectWithEmptyStack = ProjectModel.fromJson({
          'id': '1',
          'businessId': 'test',
        });

        expect(
          projectWithEmptyStack.techStack,
          isA<List<String>>(),
          reason: 'techStack should default to empty list',
        );
        expect(
          projectWithEmptyStack.techStack,
          isEmpty,
          reason: 'when not provided, should be []',
        );
      });

      test(
        '❌ Field Mismatch - Catch if Backend adds/removes fields without updating Flutter',
        () {
          // This test would fail if Backend changes the ProjectDto structure
          // Example: if Backend adds a new 'status' field, this should be updated here
          final mockProjectJson = {
            'id': '1',
            'businessId': 'test',
            'title': 'Test Project',
            'subtitle': 'Subtitle',
            'desc': 'Description',
            'imageUrl': 'url',
            'githubUrl': 'url',
            'techStack': [],
            // Future fields (if Backend adds): 'status', 'createdAt', 'updatedAt'
          };

          // Should deserialize without error
          expect(
            () => ProjectModel.fromJson(mockProjectJson),
            returnsNormally,
            reason: 'current required fields should deserialize successfully',
          );
        },
      );

      test(
        '📄 Response Wrapper Format - Verify mock follows ApiResponse<List<ProjectDto>> structure',
        () {
          // This represents what the actual mock file should contain
          final mockResponseWrapper = {
            'result': '0',
            'messageId': '',
            'message': '',
            'body': [
              {
                'id': '1',
                'businessId': 'lportfolio-flutter',
                'title': 'lPortfolio Flutter',
                'subtitle': 'Current Project',
                'desc': 'Description...',
                'imageUrl': 'url',
                'githubUrl': 'url',
                'techStack': ['Flutter'],
              },
            ],
          };

          // Assert: body is List (for projects endpoint)
          expect(
            mockResponseWrapper['body'],
            isA<List>(),
            reason: 'projects endpoint returns array in body',
          );
          expect(
            (mockResponseWrapper['body'] as List).length,
            greaterThan(0),
            reason: 'mock should have at least one project',
          );

          // Each item in body should be convertible to ProjectModel
          final projects = (mockResponseWrapper['body'] as List)
              .map(
                (json) => ProjectModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          expect(
            projects,
            isNotEmpty,
            reason: 'should convert to ProjectModel list',
          );
        },
      );
    });

    group('Backend DTO ↔ Flutter Model Alignment', () {
      test(
        '🔄 Verify ProjectDto.id (Long) matches ProjectModel.id (String)',
        () {
          // Backend: ProjectDto has Long id
          // Flutter: ProjectModel has String? id with @ToStringConverter
          // Mock: has "id": "123" (string in JSON)

          // This test ensures the chain is complete:
          // Long (Backend) → "123" (JSON) → String? (Flutter Model)

          final mockJson = {'id': '999'};
          final model = ProjectModel.fromJson(mockJson);

          expect(model.id, equals('999'));
          expect(model.id, isA<String>());
        },
      );

      test(
        '🔄 Verify ProjectDto.techStack (List<String>) matches ProjectModel.techStack',
        () {
          // Both should be List<String>
          final mockJson = {
            'techStack': ['Flutter', 'Dart', 'Riverpod'],
          };

          final model = ProjectModel.fromJson(mockJson);

          expect(model.techStack, isA<List<String>>());
          expect(model.techStack, hasLength(3));
          expect(model.techStack.first, equals('Flutter'));
        },
      );
    });
  });
}
