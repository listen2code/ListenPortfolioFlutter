import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/get_current_user_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
import 'package:mocktail/mocktail.dart';

///
/// LoginUseCase 单元测试
///
/// 测试覆盖范围：
/// 1. 正常登录流程（成功场景）
/// 2. 各种失败场景（空用户名、空密码、网络错误、认证失败等）
/// 3. 边界情况（特殊字符、Unicode、超长字符串、null参数等）
/// 4. 错误处理（缺失userId、getCurrentUser失败等）
///
/// 架构原则：
/// - UseCase层不负责验证，只负责协调Repository调用
/// - 所有验证逻辑应在ViewModel层处理
/// - UseCase直接返回Repository的失败结果
///

// Mock repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    const testUsername = 'testuser';
    const testPassword = 'password123';
    const testUserId = 'user_123';

    final testUser = UserModel(id: testUserId, name: 'Test UserModel', email: 'test@example.com');

    final testLoginResponse = LoginModel(token: 'token_abc', userId: testUserId);

    test('should return UserModel when login and getCurrentUser are successful', () async {
      // Arrange: Mock both login and subsequent profile fetch
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testLoginResponse));

      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: testUsername, password: testPassword),
      );

      // Assert
      expect(result, Right<Failure, UserModel?>(testUser));

      // Verify the sequence of calls
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: testUsername, password: testPassword),
        ),
      ).called(1);
      verify(
        () => mockRepository.getCurrentUser(param: GetCurrentUserRequestModel(userId: testUserId)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when username is empty', () async {
      // Arrange: Mock repository to return validation error for empty username
      const validationFailure = ServerFailure('Username cannot be empty');
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(validationFailure));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: '', password: testPassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(validationFailure));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: '', password: testPassword),
        ),
      ).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });

    test('should return ServerFailure when password is empty', () async {
      // Arrange: Mock repository to return validation error for empty password
      const validationFailure = ServerFailure('Password cannot be empty');
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(validationFailure));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: testUsername, password: ''),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(validationFailure));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: testUsername, password: ''),
        ),
      ).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });

    test('should return ServerFailure when both username and password are empty', () async {
      // Arrange: Mock repository to return validation error for empty credentials
      const validationFailure = ServerFailure('Username cannot be empty');
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(validationFailure));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: '', password: ''),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(validationFailure));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: '', password: ''),
        ),
      ).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      const serverFailure = ServerFailure('Invalid Credentials');
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: testUsername, password: testPassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(serverFailure));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: testUsername, password: testPassword),
        ),
      ).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });

    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const networkFailure = NetworkFailure('No internet connection');
      ;
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(networkFailure));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: testUsername, password: testPassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(networkFailure));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: testUsername, password: testPassword),
        ),
      ).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });

    test('should return AuthFailure when authentication fails', () async {
      // Arrange
      const authFailure = AuthFailure('Authentication failed');
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(authFailure));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: testUsername, password: testPassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(authFailure));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: testUsername, password: testPassword),
        ),
      ).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });

    test('should return ServerFailure when userId is missing in login response', () async {
      // Arrange
      final emptyUserIdResponse = LoginModel(token: 'token_abc', userId: '');
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(emptyUserIdResponse));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: testUsername, password: testPassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(ServerFailure('User ID is missing in response')));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: testUsername, password: testPassword),
        ),
      ).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });

    test('should return ServerFailure when getCurrentUser fails', () async {
      // Arrange
      const getCurrentUserFailure = ServerFailure('Failed to fetch user profile');
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testLoginResponse));

      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(getCurrentUserFailure));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: testUsername, password: testPassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(getCurrentUserFailure));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: testUsername, password: testPassword),
        ),
      ).called(1);
      verify(
        () => mockRepository.getCurrentUser(param: GetCurrentUserRequestModel(userId: testUserId)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle null login response gracefully', () async {
      // Arrange
      when(() => mockRepository.login(param: any(named: 'param'))).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: testUsername, password: testPassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(ServerFailure('User ID is missing in response')));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: testUsername, password: testPassword),
        ),
      ).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });

    test('should handle edge case with special characters in credentials', () async {
      // Arrange
      const specialUsername = 'user@#\$%^&*()';
      const specialPassword = 'pass!@#\$%^&*()_+';

      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testLoginResponse));

      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: specialUsername, password: specialPassword),
      );

      // Assert
      expect(result, Right<Failure, UserModel?>(testUser));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: specialUsername, password: specialPassword),
        ),
      ).called(1);
      verify(
        () => mockRepository.getCurrentUser(param: GetCurrentUserRequestModel(userId: testUserId)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle very long username and password', () async {
      // Arrange
      const longUsername = 'very_long_username_with_many_characters_12345678901234567890';
      const longPassword = 'very_long_password_with_many_characters_123456789012345678901234567890';

      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testLoginResponse));

      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: longUsername, password: longPassword),
      );

      // Assert
      expect(result, Right<Failure, UserModel?>(testUser));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: longUsername, password: longPassword),
        ),
      ).called(1);
      verify(
        () => mockRepository.getCurrentUser(param: GetCurrentUserRequestModel(userId: testUserId)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle unicode characters in credentials', () async {
      // Arrange
      const unicodeUsername = 'Ã§â€Â¨Ã¦Ë†Â·Ã¥ÂÂ_Ã‘â€šÃÂµÃ‘ÂÃ‘â€š_Ã°Å¸Å¡â‚¬';
      const unicodePassword = 'Ã¥Â¯â€ Ã§Â Â_ÃÂ¿ÃÂ°Ã‘â‚¬ÃÂ¾ÃÂ»Ã‘Å’_Ã°Å¸â€â€˜';

      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testLoginResponse));

      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: unicodeUsername, password: unicodePassword),
      );

      // Assert
      expect(result, Right<Failure, UserModel?>(testUser));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: unicodeUsername, password: unicodePassword),
        ),
      ).called(1);
      verify(
        () => mockRepository.getCurrentUser(param: GetCurrentUserRequestModel(userId: testUserId)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle null param gracefully', () async {
      // Arrange: Mock repository to handle null param
      when(
        () => mockRepository.login(param: null),
      ).thenAnswer((_) async => const Left(ServerFailure('Invalid request parameters')));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, UserModel?>(ServerFailure('Invalid request parameters')));
      verify(() => mockRepository.login(param: null)).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });

    test('should handle whitespace-only username and password', () async {
      // Arrange
      const whitespaceUsername = '   ';
      const whitespacePassword = '   ';

      const validationFailure = ServerFailure('Username cannot be empty');
      when(
        () => mockRepository.login(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(validationFailure));

      // Act
      final result = await useCase(
        param: LoginRequestModel(userName: whitespaceUsername, password: whitespacePassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(validationFailure));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(userName: whitespaceUsername, password: whitespacePassword),
        ),
      ).called(1);
      verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
    });
  });
}
