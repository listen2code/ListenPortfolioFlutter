import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
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

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockSecureStorage = MockFlutterSecureStorage();

    // Link mock secure storage to the local data source
    when(() => mockLocalDataSource.secureStorage).thenReturn(mockSecureStorage);

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
    const testUserId = 'user_123';
    const testToken = 'mock_token';

    final testLoginResponse = BaseResponseModel<LoginResponseModel>(
      result: "0", // CRITICAL: safeCall needs "0" to indicate success
      body: const LoginResponseModel(userId: testUserId, token: testToken),
    );

    test('should cache token and return LoginResponseModel when successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any())).thenAnswer((_) async => testLoginResponse);
      when(() => mockLocalDataSource.cacheAuthToken(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheRefreshToken(any())).thenAnswer((_) async => {});

      // Act
      // We MUST use double await to unwrap the nested Future caused by the async closure in fold.
      final result = await repository.login(username: testUsername, password: testPassword);

      // Assert
      final response = result.getRight().toNullable();
      expect(response?.token, testToken);
      expect(response?.userId, testUserId);
      verify(() => mockLocalDataSource.cacheAuthToken(testToken)).called(1);
    });
  });

  group('AuthRepositoryImpl - getCurrentUser', () {
    const testUserId = 'user_123';
    final testUserModel = UserModel(
      id: testUserId,
      name: 'Test',
      email: 'test@example.com',
      createdAt: "2026",
    );
    final testApiResponse = BaseResponseModel<UserModel>(
      result: "0", // CRITICAL: Success status code
      body: testUserModel,
    );

    test('should return remote user and update cache when API call is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUserById(any())).thenAnswer((_) async => testApiResponse);
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => {});

      // Act
      final result = await repository.getCurrentUser(userId: testUserId);

      // Assert
      expect(result.getRight().toNullable(), testUserModel);
      verify(() => mockRemoteDataSource.getUserById(testUserId)).called(1);
      verify(() => mockLocalDataSource.cacheUser(testUserModel)).called(1);
    });

    test('should return cached user when API call fails and cache is available', () async {
      // Arrange: Simulate offline failure
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedUser()).thenAnswer((_) async => testUserModel);

      // Act
      final result = await repository.getCurrentUser(userId: testUserId);

      // Assert
      expect(result.getRight().toNullable(), testUserModel);
      verify(() => mockLocalDataSource.getCachedUser()).called(1);
    });

    test('should return failure when both API and cache are unavailable', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUserById(any())).thenThrow(ServerException('API Error', 500));
      when(() => mockLocalDataSource.getCachedUser()).thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser(userId: testUserId);

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockLocalDataSource.getCachedUser()).called(1);
    });
  });

  group('AuthRepositoryImpl - refreshToken', () {
    const testOldRefreshToken = 'old_refresh_token';
    const testNewAccessToken = 'new_access_token';
    const testNewRefreshToken = 'new_refresh_token';

    test('should return new access token and update cache when refresh is successful', () async {
      // Arrange
      when(() => mockLocalDataSource.getRefreshToken()).thenAnswer((_) async => testOldRefreshToken);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.refreshToken(testOldRefreshToken)).thenAnswer(
        (_) async => BaseResponseModel(
          result: "0", // CRITICAL: Success status code
          body: const LoginResponseModel(token: testNewAccessToken, refreshToken: testNewRefreshToken),
        ),
      );
      when(() => mockLocalDataSource.cacheAuthToken(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheRefreshToken(any())).thenAnswer((_) async => {});

      // Act
      final result = await repository.refreshToken();

      // Assert
      expect(result.getRight().toNullable(), testNewAccessToken);
      verify(() => mockLocalDataSource.cacheAuthToken(testNewAccessToken)).called(1);
      verify(() => mockLocalDataSource.cacheRefreshToken(testNewRefreshToken)).called(1);
    });
  });
}
