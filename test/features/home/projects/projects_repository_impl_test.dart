import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/projects_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/projects_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/repositories/projects_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockProjectsRemoteDataSource extends Mock implements ProjectsRemoteDataSource {}

class MockProjectsLocalDataSource extends Mock implements ProjectsLocalDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(<ProjectModel>[]);
  });

  late ProjectsRepositoryImpl repository;
  late MockProjectsRemoteDataSource mockRemote;
  late MockProjectsLocalDataSource mockLocal;

  final testProjects = [
    ProjectModel(id: '1', title: 'Flutter App', subtitle: 'Mobile', desc: 'A sample app'),
    ProjectModel(id: '2', title: 'Web App', subtitle: 'Web', desc: 'A web project'),
  ];

  final successResponse = BaseResponseModel<List<ProjectModel>>(
    result: ApiResult.success,
    body: [
      ProjectModel(id: '1', title: 'Flutter App', subtitle: 'Mobile', desc: 'A sample app'),
      ProjectModel(id: '2', title: 'Web App', subtitle: 'Web', desc: 'A web project'),
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
      when(() => mockRemote.getProjects()).thenAnswer((_) async => successResponse);
      when(() => mockLocal.cacheProjects(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.getProjects();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (data) {
          expect(data.length, testProjects.length);
          expect(data.first.title, testProjects.first.title);
        },
      );
      verify(() => mockRemote.getProjects()).called(1);
      verify(() => mockLocal.cacheProjects(any())).called(1);
    });

    test('should cache project list after successful remote fetch', () async {
      // Arrange
      when(() => mockRemote.getProjects()).thenAnswer((_) async => successResponse);
      when(() => mockLocal.cacheProjects(any())).thenAnswer((_) async {});

      // Act
      await repository.getProjects();

      // Assert — cache must be written exactly once
      verify(() => mockLocal.cacheProjects(any())).called(1);
    });

    test('should return cached projects when remote fails and cache exists', () async {
      // Arrange
      when(() => mockRemote.getProjects()).thenAnswer((_) async => failureResponse);
      when(() => mockLocal.getCachedProjects()).thenAnswer((_) async => testProjects);

      // Act
      final result = await repository.getProjects();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (data) => expect(data.length, testProjects.length),
      );
      verify(() => mockLocal.getCachedProjects()).called(1);
    });

    test('should return Failure when remote fails and cache is empty', () async {
      // Arrange
      when(() => mockRemote.getProjects()).thenAnswer((_) async => failureResponse);
      when(() => mockLocal.getCachedProjects()).thenAnswer((_) async => null);

      // Act
      final result = await repository.getProjects();

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should return Left when remote throws generic exception regardless of cache', () async {
      // Arrange — generic exceptions bypass cache fallback in safeCall's catch block
      when(() => mockRemote.getProjects()).thenThrow(Exception('Connection refused'));
      when(() => mockLocal.getCachedProjects()).thenAnswer((_) async => testProjects);

      // Act
      final result = await repository.getProjects();

      // Assert — generic exceptions go straight to Left without checking cache
      expect(result.isLeft(), isTrue);
    });

    test('should fall back to cache when remote returns session timeout failure', () async {
      // Arrange — ApiResult.sessionTimeout maps to AuthFailure, which is NOT ServerFailure
      // so _handleFailureFallback will try the cache (failure is! ServerFailure == true)
      final sessionTimeoutResponse = BaseResponseModel<List<ProjectModel>>(
        result: ApiResult.sessionTimeout,
        message: 'Session expired',
      );
      when(() => mockRemote.getProjects()).thenAnswer((_) async => sessionTimeoutResponse);
      when(() => mockLocal.getCachedProjects()).thenAnswer((_) async => testProjects);

      // Act
      final result = await repository.getProjects();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (data) => expect(data.length, testProjects.length),
      );
    });

    test('should return empty list when remote returns empty body', () async {
      // Arrange — server returns success but with empty list
      final emptyResponse = BaseResponseModel<List<ProjectModel>>(
        result: ApiResult.success,
        body: [],
      );
      when(() => mockRemote.getProjects()).thenAnswer((_) async => emptyResponse);
      when(() => mockLocal.cacheProjects(any())).thenAnswer((_) async {});

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
}
