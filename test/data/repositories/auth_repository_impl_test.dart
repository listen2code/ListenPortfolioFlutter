import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_response_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    // Register fallback values for mocktail
    registerFallbackValue(UserModel(id: '', name: '', email: '', createdAt: ''));
    registerFallbackValue(const LoginRequestModel(username: '', password: ''));
  });

  group('AuthRepositoryImpl - login', () {
    const testUsername = 'testuser';
    const testPassword = 'password123';
    const testToken = 'test_token_12345';
    const testRefreshToken = 'test_refresh_token_67890';

    final testUserModel = UserModel(id: '1', name: 'Test UserModel', email: 'test@example.com', createdAt: "2026-02-03");

    final testLoginResponse = BaseResponseModel<LoginResponseModel>(
      body: LoginResponseModel(token: testToken, refreshToken: testRefreshToken, user: testUserModel),
    );

    test('should check if device is online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenAnswer((_) async => testLoginResponse);
      when(() => mockLocalDataSource.cacheAuthToken(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => {});

      // Act
      await repository.login(username: testUsername, password: testPassword);

      // Assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    test('should return NetworkFailure when device is offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.login(username: testUsername, password: testPassword);

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
      verifyNever(() => mockRemoteDataSource.login(any()));
    });

    test('should call remote data source with correct parameters', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenAnswer((_) async => testLoginResponse);
      when(() => mockLocalDataSource.cacheAuthToken(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => {});

      // Act
      await repository.login(username: testUsername, password: testPassword);

      // Assert
      verify(() => mockRemoteDataSource.login(const LoginRequestModel(username: testUsername, password: testPassword))).called(1);
    });

    test('should cache token and user when login is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenAnswer((_) async => testLoginResponse);
      when(() => mockLocalDataSource.cacheAuthToken(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => {});

      // Act
      await repository.login(username: testUsername, password: testPassword);

      // Assert
      verify(() => mockLocalDataSource.cacheAuthToken(testToken)).called(1);
      verify(() => mockLocalDataSource.cacheUser(testUserModel)).called(1);
    });

    test('should return UserModel entity when login is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenAnswer((_) async => testLoginResponse);
      when(() => mockLocalDataSource.cacheAuthToken(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => {});

      // Act
      final result = await repository.login(username: testUsername, password: testPassword);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should return Right'), (user) {
        expect(user, isA<UserModel>());
        expect(user?.id, testUserModel.id);
        expect(user?.name, testUserModel.name);
        expect(user?.email, testUserModel.email);
      });
    });

    test('should return ServerFailure when remote data source throws ServerException', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenThrow(ServerException('Server error', 500));

      // Act
      final result = await repository.login(username: testUsername, password: testPassword);

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return NetworkFailure when remote data source throws NetworkException', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenThrow(NetworkException('Network timeout'));

      // Act
      final result = await repository.login(username: testUsername, password: testPassword);

      // Assert
      expect(result, const Left(NetworkFailure('Network timeout')));
    });

    test('should return CacheFailure when caching token fails', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenAnswer((_) async => testLoginResponse);
      when(() => mockLocalDataSource.cacheAuthToken(any())).thenThrow(CacheException('Failed to cache token'));

      // Act
      final result = await repository.login(username: testUsername, password: testPassword);

      // Assert
      expect(result, const Left(CacheFailure('Failed to cache token')));
    });

    test('should return UnknownFailure when unexpected error occurs', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await repository.login(username: testUsername, password: testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, contains('Exception: Unexpected error'));
      }, (user) => fail('Should return Left'));
    });
  });

  group('AuthRepositoryImpl - getCurrentUser', () {
    final testUserModel = UserModel(id: '1', name: 'Test UserModel', email: 'test@example.com', createdAt: "2026-02-03");

    test('should return UserModel when cached user exists', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser()).thenAnswer((_) async => testUserModel);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should return Right'), (user) {
        expect(user, isA<UserModel>());
        expect(user?.id, testUserModel.id);
        expect(user?.name, testUserModel.name);
      });
    });

    test('should return null when no cached user exists', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser()).thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, const Right(null));
    });

    test('should return null when cache exception occurs', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser()).thenThrow(CacheException('Cache read failed'));

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, const Right(null));
    });
  });
}
