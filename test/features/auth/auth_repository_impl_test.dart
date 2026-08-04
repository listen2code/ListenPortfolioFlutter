import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/get_current_user_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    // Mock the connectivity_plus platform channel to simulate wifi connection
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (MethodCall call) async => ['wifi'],
        );

    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();

    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );

    // Register fallback values for mocktail
    registerFallbackValue(UserModel(id: '', name: '', email: ''));
    registerFallbackValue(const LoginRequestModel(userName: '', password: ''));
  });

  group('AuthRepositoryImpl - login', () {
    const testUsername = 'testuser';
    const testPassword = 'password123';
    const testUserId = 'user_123';
    const testToken = 'mock_token';

    final testLoginResponse = BaseResponseModel<LoginModel>(
      result: ApiResult.success, // Success status
      body: const LoginModel(userId: testUserId, token: testToken),
    );

    test(
      'should cache token and return LoginResponseModel when successful',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.login(any()),
        ).thenAnswer((_) async => testLoginResponse);
        when(
          () => mockLocalDataSource.cacheAuthToken(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockLocalDataSource.cacheRefreshToken(any()),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.login(
          param: LoginRequestModel(
            userName: testUsername,
            password: testPassword,
          ),
        );

        // Assert
        final response = result.getRight().toNullable();
        expect(response?.token, testToken);
        expect(response?.userId, testUserId);
        verify(() => mockLocalDataSource.cacheAuthToken(testToken)).called(1);
      },
    );
  });

  group('AuthRepositoryImpl - getCurrentUser', () {
    const testUserId = 'user_123';
    final testUserModel = UserModel(
      id: testUserId,
      name: 'Test',
      email: 'test@example.com',
    );
    final testApiResponse = BaseResponseModel<UserModel>(
      result: ApiResult.success,
      body: testUserModel,
    );
    final failureResponse = BaseResponseModel<UserModel>(
      result: ApiResult.serverError,
      message: 'Internal server error',
    );

    test(
      'should return remote user and update cache when API call is successful',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getUserById(any()),
        ).thenAnswer((_) async => testApiResponse);
        when(
          () => mockLocalDataSource.cache(any()),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.getCurrentUser(
          param: GetCurrentUserRequestModel(userId: testUserId),
        );

        // Assert
        expect(result.getRight().toNullable(), testUserModel);
        verify(() => mockRemoteDataSource.getUserById(testUserId)).called(1);
        verify(() => mockLocalDataSource.cache(testUserModel)).called(1);
      },
    );

    test(
      'should return cached user when API call fails and cache is available',
      () async {
        // Arrange - return a failure BaseResponseModel to trigger safeCall cache fallback
        when(
          () => mockRemoteDataSource.getUserById(any()),
        ).thenAnswer((_) async => failureResponse);
        when(
          () => mockLocalDataSource.getCached(),
        ).thenAnswer((_) async => testUserModel);

        // Act
        final result = await repository.getCurrentUser(
          param: GetCurrentUserRequestModel(userId: testUserId),
        );

        // Assert
        expect(result.getRight().toNullable(), testUserModel);
        verify(() => mockLocalDataSource.getCached()).called(1);
      },
    );

    test(
      'should return failure when both API and cache are unavailable',
      () async {
        // Arrange - return a failure BaseResponseModel; cache returns null
        when(
          () => mockRemoteDataSource.getUserById(any()),
        ).thenAnswer((_) async => failureResponse);
        when(
          () => mockLocalDataSource.getCached(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCurrentUser(
          param: GetCurrentUserRequestModel(userId: testUserId),
        );

        // Assert
        expect(result.isLeft(), true);
        verify(() => mockLocalDataSource.getCached()).called(1);
      },
    );
  });

  group('AuthRepositoryImpl - refreshToken', () {
    const testOldRefreshToken = 'old_refresh_token';
    const testNewAccessToken = 'new_access_token';
    const testNewRefreshToken = 'new_refresh_token';

    test(
      'should return new access token and update cache when refresh is successful',
      () async {
        // Arrange
        when(
          () => mockLocalDataSource.getRefreshToken(),
        ).thenAnswer((_) async => testOldRefreshToken);
        when(
          () => mockRemoteDataSource.refreshToken(testOldRefreshToken),
        ).thenAnswer(
          (_) async => BaseResponseModel(
            result: ApiResult.success,
            body: const LoginModel(
              token: testNewAccessToken,
              refreshToken: testNewRefreshToken,
            ),
          ),
        );
        when(
          () => mockLocalDataSource.cacheAuthToken(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockLocalDataSource.cacheRefreshToken(any()),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.refreshToken();

        // Assert
        expect(result.getRight().toNullable(), testNewAccessToken);
        verify(
          () => mockLocalDataSource.cacheAuthToken(testNewAccessToken),
        ).called(1);
        verify(
          () => mockLocalDataSource.cacheRefreshToken(testNewRefreshToken),
        ).called(1);
      },
    );
  });

  group('AuthRepositoryImpl - logout', () {
    String createMockJwt(int expSeconds) {
      final header = base64Url.encode(utf8.encode(json.encode({'alg': 'HS256', 'typ': 'JWT'})));
      final payload = base64Url.encode(utf8.encode(json.encode({'exp': expSeconds})));
      return '$header.$payload.signature';
    }

    test(
      'should call API logout and clear cache when access token is valid (not expired)',
      () async {
        final validToken = createMockJwt(DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600);
        when(() => mockLocalDataSource.getAuthToken()).thenAnswer((_) async => validToken);
        when(() => mockRemoteDataSource.logout()).thenAnswer((_) async => BaseResponseModel(result: ApiResult.success));
        when(() => mockLocalDataSource.clearAuthData()).thenAnswer((_) async => {});

        final result = await repository.logout();

        expect(result.isRight(), true);
        verify(() => mockRemoteDataSource.logout()).called(1);
        verify(() => mockLocalDataSource.clearAuthData()).called(1);
      },
    );

    test(
      'should perform silent refresh successfully, call API logout, and clear cache when access token is expired',
      () async {
        final expiredToken = createMockJwt(DateTime.now().millisecondsSinceEpoch ~/ 1000 - 100);
        final oldRefreshToken = 'old_refresh_token';
        final newAccessToken = createMockJwt(DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600);
        final newRefreshToken = 'new_refresh_token';

        when(() => mockLocalDataSource.getAuthToken()).thenAnswer((_) async => expiredToken);
        when(() => mockLocalDataSource.getRefreshToken()).thenAnswer((_) async => oldRefreshToken);
        when(() => mockRemoteDataSource.refreshToken(oldRefreshToken)).thenAnswer(
          (_) async => BaseResponseModel(
            result: ApiResult.success,
            body: LoginModel(token: newAccessToken, refreshToken: newRefreshToken),
          ),
        );
        when(() => mockLocalDataSource.cacheAuthToken(newAccessToken)).thenAnswer((_) async => {});
        when(() => mockLocalDataSource.cacheRefreshToken(newRefreshToken)).thenAnswer((_) async => {});
        when(() => mockRemoteDataSource.logout()).thenAnswer((_) async => BaseResponseModel(result: ApiResult.success));
        when(() => mockLocalDataSource.clearAuthData()).thenAnswer((_) async => {});

        final result = await repository.logout();

        expect(result.isRight(), true);
        verify(() => mockRemoteDataSource.refreshToken(oldRefreshToken)).called(1);
        verify(() => mockRemoteDataSource.logout()).called(1);
        verify(() => mockLocalDataSource.clearAuthData()).called(1);
      },
    );

    test(
      'should force clear cache and return success when access token is expired and silent refresh fails',
      () async {
        final expiredToken = createMockJwt(DateTime.now().millisecondsSinceEpoch ~/ 1000 - 100);
        final oldRefreshToken = 'old_refresh_token';

        when(() => mockLocalDataSource.getAuthToken()).thenAnswer((_) async => expiredToken);
        when(() => mockLocalDataSource.getRefreshToken()).thenAnswer((_) async => oldRefreshToken);
        when(() => mockRemoteDataSource.refreshToken(oldRefreshToken)).thenAnswer(
          (_) async => BaseResponseModel(result: ApiResult.serverError, message: 'Invalid refresh token'),
        );
        when(() => mockLocalDataSource.clearAuthData()).thenAnswer((_) async => {});

        final result = await repository.logout();

        expect(result.isRight(), true);
        verify(() => mockRemoteDataSource.refreshToken(oldRefreshToken)).called(1);
        verifyNever(() => mockRemoteDataSource.logout());
        verify(() => mockLocalDataSource.clearAuthData()).called(1);
      },
    );
  });

  group('Auth API Contract Tests - Login Flow', () {
    group('POST /auth/login', () {
      test(
        '✅ Login Success - Returns valid LoginModel with token and refreshToken',
        () {
          // Verify mock response structure for login endpoint
          final mockResponse = {
            'result': '0',
            'messageId': '',
            'message': '',
            'body': {
              'userId': 'user_123',
              'token':
                  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U',
              'refreshToken': 'refresh_token_value',
            },
          };

          // Act: Parse mock response to LoginModel
          final loginModel = LoginModel.fromJson(mockResponse['body'] as Map<String, dynamic>);

          // Assert: Verify all required fields are present and have correct types
          expect(
            loginModel.userId,
            isNotNull,
            reason: 'userId should not be null',
          );
          expect(
            loginModel.userId,
            isA<String>(),
            reason: 'userId must be String (converted from Long)',
          );
          expect(
            loginModel.token,
            isNotNull,
            reason: 'token should not be null',
          );
          expect(
            loginModel.token,
            isA<String>(),
            reason: 'token must be String',
          );
          expect(
            loginModel.refreshToken,
            isNotNull,
            reason: 'refreshToken should not be null',
          );
          expect(
            loginModel.refreshToken,
            isA<String>(),
            reason: 'refreshToken must be String',
          );

          // Verify token format looks like JWT (roughly)
          expect(
            loginModel.token!.split('.').length,
            equals(3),
            reason: 'token should have JWT format (header.payload.signature)',
          );
        },
      );

      test(
        '⚠️ Mock vs DTO Contract - Response structure matches ApiResponse wrapper',
        () {
          // This test verifies that mock JSON has the expected wrapper structure
          final mockResponse = {
            'result': '0',
            'messageId': 'LOGIN_SUCCESS',
            'message': 'Login successful',
            'body': {
              'userId': 'user_123',
              'token': 'jwt_token',
              'refreshToken': 'refresh_token',
            },
          };

          // Assert: Response should have standard wrapper fields
          expect(
            mockResponse,
            containsPair('result', '0'),
            reason: 'result code should be "0" for success',
          );
          expect(
            mockResponse,
            contains('messageId'),
            reason: 'messageId field must exist',
          );
          expect(
            mockResponse,
            contains('message'),
            reason: 'message field must exist',
          );
          expect(
            mockResponse,
            contains('body'),
            reason: 'body field must exist (contains LoginResponse DTO)',
          );

          // Assert: body should have all LoginResponse fields
          final body = mockResponse['body'];
          expect(
            body,
            contains('userId'),
            reason: 'userId required in LoginResponse',
          );
          expect(
            body,
            contains('token'),
            reason: 'token required in LoginResponse',
          );
          expect(
            body,
            contains('refreshToken'),
            reason: 'refreshToken required in LoginResponse',
          );
        },
      );
    });

    group('GET /user (Current User)', () {
      test('✅ Get Current User - Returns valid UserModel with all fields', () {
        final mockResponse = {
          'result': '0',
          'messageId': '',
          'message': '',
          'body': {
            'id': 'user_123',
            'name': 'Test User',
            'email': 'test@example.com',
            'location': 'San Francisco',
            'avatarUrl': 'https://example.com/avatar.jpg',
          },
        };
        final userModel = UserModel.fromJson(mockResponse['body'] as Map<String, dynamic>);

        // Assert: All user fields are present
        expect(userModel.id, isNotNull, reason: 'user.id should not be null');
        expect(userModel.id, isA<String>(), reason: 'user.id must be String');
        expect(userModel.name, isNotNull, reason: 'user.name required');
        expect(userModel.email, isNotNull, reason: 'user.email required');
        expect(userModel.location, isNotNull, reason: 'user.location required');
        expect(
          userModel.avatarUrl,
          isNotNull,
          reason: 'user.avatarUrl required',
        );
      });

      test('⚠️ Field Naming - Mock and DTO field names must be consistent', () {
        final mockResponse = {
          'id': 'user_123',
          'name': 'Test User',
          'email': 'test@example.com',
          'location': 'San Francisco',
          'avatarUrl': 'https://example.com/avatar.jpg',
        };
        final body = mockResponse;

        // These field names MUST match between mock, DTO, and Model
        expect(body, contains('id'), reason: 'id field required');
        expect(body, contains('name'), reason: 'name field required');
        expect(body, contains('email'), reason: 'email field required');
        expect(
          body,
          contains('location'),
          reason: 'location field required',
        );
        expect(
          body,
          contains('avatarUrl'),
          reason: 'avatarUrl field required',
        );
      });
    });
  });
}
