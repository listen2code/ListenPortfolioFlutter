import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/about_me_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/about_me_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/repositories/about_me_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockAboutMeRemoteDataSource extends Mock implements AboutMeRemoteDataSource {}

class MockAboutMeLocalDataSource extends Mock implements AboutMeLocalDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(AboutMeModel());
  });

  late AboutMeRepositoryImpl repository;
  late MockAboutMeRemoteDataSource mockRemote;
  late MockAboutMeLocalDataSource mockLocal;

  final testAboutMe = AboutMeModel(
    status: 'Software Engineer',
    jobTitle: 'Senior Flutter Developer',
    bio: 'Passionate about mobile development',
  );

  final successResponse = BaseResponseModel<AboutMeModel>(
    result: ApiResult.success,
    body: AboutMeModel(
      status: 'Software Engineer',
      jobTitle: 'Senior Flutter Developer',
      bio: 'Passionate about mobile development',
    ),
  );

  final failureResponse = BaseResponseModel<AboutMeModel>(
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

    mockRemote = MockAboutMeRemoteDataSource();
    mockLocal = MockAboutMeLocalDataSource();
    repository = AboutMeRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('AboutMeRepositoryImpl - getAboutMe', () {
    test('should return AboutMeModel when remote call succeeds', () async {
      // Arrange
      when(() => mockRemote.getAboutMe()).thenAnswer((_) async => successResponse);
      when(() => mockLocal.cacheAboutMe(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.getAboutMe();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (data) {
          expect(data.status, testAboutMe.status);
          expect(data.jobTitle, testAboutMe.jobTitle);
        },
      );
      verify(() => mockRemote.getAboutMe()).called(1);
      verify(() => mockLocal.cacheAboutMe(any())).called(1);
    });

    test('should cache data after successful remote fetch', () async {
      // Arrange
      when(() => mockRemote.getAboutMe()).thenAnswer((_) async => successResponse);
      when(() => mockLocal.cacheAboutMe(any())).thenAnswer((_) async {});

      // Act
      await repository.getAboutMe();

      // Assert — cache must be written exactly once
      verify(() => mockLocal.cacheAboutMe(any())).called(1);
    });

    test('should return cached data when remote fails and cache exists', () async {
      // Arrange — remote returns failure, cache has data
      when(() => mockRemote.getAboutMe()).thenAnswer((_) async => failureResponse);
      when(() => mockLocal.getCachedAboutMe()).thenAnswer((_) async => testAboutMe);

      // Act
      final result = await repository.getAboutMe();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (data) => expect(data.status, testAboutMe.status),
      );
      verify(() => mockLocal.getCachedAboutMe()).called(1);
    });

    test('should return Failure when remote fails and no cache exists', () async {
      // Arrange
      when(() => mockRemote.getAboutMe()).thenAnswer((_) async => failureResponse);
      when(() => mockLocal.getCachedAboutMe()).thenAnswer((_) async => null);

      // Act
      final result = await repository.getAboutMe();

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should return Left when remote throws generic exception regardless of cache', () async {
      // Arrange — generic exceptions bypass cache fallback in safeCall's catch block
      when(() => mockRemote.getAboutMe()).thenThrow(Exception('Connection refused'));
      when(() => mockLocal.getCachedAboutMe()).thenAnswer((_) async => testAboutMe);

      // Act
      final result = await repository.getAboutMe();

      // Assert — generic exceptions go straight to Left without checking cache
      expect(result.isLeft(), isTrue);
    });

    test('should fall back to cache when remote returns session timeout failure', () async {
      // Arrange — ApiResult.sessionTimeout maps to AuthFailure, which is NOT ServerFailure
      // so _handleFailureFallback will try the cache (failure is! ServerFailure == true)
      final sessionTimeoutResponse = BaseResponseModel<AboutMeModel>(
        result: ApiResult.sessionTimeout,
        message: 'Session expired',
      );
      when(() => mockRemote.getAboutMe()).thenAnswer((_) async => sessionTimeoutResponse);
      when(() => mockLocal.getCachedAboutMe()).thenAnswer((_) async => testAboutMe);

      // Act
      final result = await repository.getAboutMe();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (data) => expect(data.status, testAboutMe.status),
      );
    });
  });
}
