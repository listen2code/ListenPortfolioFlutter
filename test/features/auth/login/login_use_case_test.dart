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

    group('Successful Login', () {
      test('should return UserModel when login and getCurrentUser are successful', () async {
        // Arrange: Mock both login and subsequent profile fetch
        when(
          () => mockRepository.login(param: any(named: 'param')),
        ).thenAnswer((_) async => right(testLoginResponse));

        when(
          () => mockRepository.getCurrentUser(param: any(named: 'param')),
        ).thenAnswer((_) async => right(testUser));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isRight(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(testUser));

        // Verify the correct calls were made
        verify(() => mockRepository.login(param: request)).called(1);
        verify(
          () => mockRepository.getCurrentUser(
            param: GetCurrentUserRequestModel(userId: testUserId),
          ),
        ).called(1);
      });

      test('should handle login with special characters in credentials', () async {
        // Arrange
        const specialUsername = 'user@domain.com';
        const specialPassword = 'P@ssw0rd!@#%^&*()';

        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => right(testLoginResponse));

        when(() => mockRepository.getCurrentUser(param: any(named: 'param')))
            .thenAnswer((_) async => right(testUser));

        final request = LoginRequestModel(userName: specialUsername, password: specialPassword);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isRight(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(testUser));
      });

      test('should handle login with Unicode characters', () async {
        // Arrange
        const unicodeUsername = '用户测试';
        const unicodePassword = '密码123！@#';

        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => right(testLoginResponse));

        when(() => mockRepository.getCurrentUser(param: any(named: 'param')))
            .thenAnswer((_) async => right(testUser));

        final request = LoginRequestModel(userName: unicodeUsername, password: unicodePassword);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isRight(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(testUser));
      });
    });

    group('Login Failures', () {
      test('should return failure when login fails', () async {
        // Arrange
        const loginFailure = NetworkFailure('Network error');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => left(loginFailure));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(loginFailure));

        // Verify getCurrentUser was not called
        verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
      });

      test('should return failure when login returns null response', () async {
        // Arrange
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => right(null));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(
          result.fold((l) => l, (r) => r),
          isA<ServerFailure>(),
        );

        // Verify getCurrentUser was not called
        verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
      });

      test('should return failure when login response has empty userId', () async {
        // Arrange
        final emptyUserIdResponse = LoginModel(token: 'token_abc', userId: '');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => right(emptyUserIdResponse));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(
          result.fold((l) => l, (r) => r),
          isA<ServerFailure>(),
        );
      });

      test('should return failure when getCurrentUser fails', () async {
        // Arrange
        const userFailure = ServerFailure('User not found');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => right(testLoginResponse));

        when(() => mockRepository.getCurrentUser(param: any(named: 'param')))
            .thenAnswer((_) async => left(userFailure));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(userFailure));
      });

      test('should handle network timeout during login', () async {
        // Arrange
        const timeoutFailure = NetworkFailure('Request timeout');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => left(timeoutFailure));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(timeoutFailure));
      });

      test('should handle authentication failure', () async {
        // Arrange
        const authFailure = AuthFailure('Invalid credentials');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => left(authFailure));

        final request = LoginRequestModel(userName: testUsername, password: 'wrong_password');

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(authFailure));
      });
    });

    group('Edge Cases', () {
      test('should handle null parameters gracefully', () async {
        // Arrange
        const validationFailure = ValidationFailure('Invalid input');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => left(validationFailure));

        // Act
        final result = await useCase.call(param: null);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(validationFailure));
      });

      test('should handle very long username and password', () async {
        // Arrange
        final longString = 'a' * 1000; // 1000 characters
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => right(testLoginResponse));

        when(() => mockRepository.getCurrentUser(param: any(named: 'param')))
            .thenAnswer((_) async => right(testUser));

        final request = LoginRequestModel(userName: longString, password: longString);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isRight(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(testUser));
      });

      test('should handle empty request model', () async {
        // Arrange
        const validationFailure = ValidationFailure('Empty credentials');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => left(validationFailure));

        final request = const LoginRequestModel(userName: '', password: '');

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(validationFailure));
      });

      test('should handle whitespace-only credentials', () async {
        // Arrange
        const validationFailure = ValidationFailure('Empty credentials');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => left(validationFailure));

        final request = const LoginRequestModel(userName: '   ', password: '   ');

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l, (r) => r), equals(validationFailure));
      });
    });

    group('Repository Call Verification', () {
      test('should call login with correct parameters', () async {
        // Arrange
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => right(testLoginResponse));

        when(() => mockRepository.getCurrentUser(param: any(named: 'param')))
            .thenAnswer((_) async => right(testUser));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        await useCase.call(param: request);

        // Assert
        verify(() => mockRepository.login(param: request)).called(1);
      });

      test('should call getCurrentUser with correct userId', () async {
        // Arrange
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => right(testLoginResponse));

        when(() => mockRepository.getCurrentUser(param: any(named: 'param')))
            .thenAnswer((_) async => right(testUser));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        await useCase.call(param: request);

        // Assert
        verify(
          () => mockRepository.getCurrentUser(
            param: GetCurrentUserRequestModel(userId: testUserId),
          ),
        ).called(1);
      });

      test('should not call getCurrentUser when login fails', () async {
        // Arrange
        const loginFailure = NetworkFailure('Network error');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => left(loginFailure));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        await useCase.call(param: request);

        // Assert
        verifyNever(() => mockRepository.getCurrentUser(param: any(named: 'param')));
      });
    });

    group('Error Propagation', () {
      test('should propagate repository errors without modification', () async {
        // Arrange
        const serverFailure = ServerFailure('Custom error message');
        when(() => mockRepository.login(param: any(named: 'param')))
            .thenAnswer((_) async => left(serverFailure));

        final request = LoginRequestModel(userName: testUsername, password: testPassword);

        // Act
        final result = await useCase.call(param: request);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => r);
        expect(failure, isA<ServerFailure>());
        expect(failure, equals(serverFailure));
      });

      test('should handle multiple error types correctly', () async {
        // Test different failure types to ensure they're all handled correctly
        final failures = [
          const NetworkFailure('Network error'),
          const AuthFailure('Authentication failed'),
          const ServerFailure('Server error'),
          const ValidationFailure('Validation error'),
        ];

        for (final failure in failures) {
          // Arrange
          when(() => mockRepository.login(param: any(named: 'param')))
              .thenAnswer((_) async => left(failure));

          final request = LoginRequestModel(userName: testUsername, password: testPassword);

          // Act
          final result = await useCase.call(param: request);

          // Assert
          expect(result.isLeft(), isTrue, reason: 'Failed for failure type: ${failure.runtimeType}');
          expect(result.fold((l) => l, (r) => r), equals(failure));

          // Reset mock for next iteration
          reset(mockRepository);
        }
      });
    });
  });
}
