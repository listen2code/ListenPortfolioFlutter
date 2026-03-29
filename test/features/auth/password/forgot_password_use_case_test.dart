import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/forgot_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:mocktail/mocktail.dart';

///
/// ForgotPasswordUseCase 单元测试
///
/// 测试覆盖范围：
/// 1. 正常密码重置流程（成功场景）
/// 2. 各种失败场景（空邮箱、无效邮箱格式、网络错误、服务器错误等）
/// 3. 边界情况（特殊字符、Unicode、超长邮箱地址等）
/// 4. 错误处理（Repository层错误传递）
///
/// 架构原则：
/// - UseCase层不负责验证，只负责协调Repository调用
/// - 所有验证逻辑应在ViewModel层处理
/// - UseCase直接返回Repository的失败结果
///

// Mock repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ForgotPasswordUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ForgotPasswordUseCase(mockRepository);
  });

  group('ForgotPasswordUseCase', () {
    const testEmail = 'test@example.com';

    test('should return success when forgotPassword is successful', () async {
      // Arrange: Mock repository to return success
      when(
        () => mockRepository.forgotPassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(param: const ForgotPasswordRequestModel(email: testEmail));

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.forgotPassword(param: const ForgotPasswordRequestModel(email: testEmail)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository returns ServerFailure', () async {
      // Arrange
      const serverFailure = ServerFailure('Server error occurred');
      when(
        () => mockRepository.forgotPassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await useCase(param: const ForgotPasswordRequestModel(email: testEmail));

      // Assert
      expect(result, const Left<Failure, void>(serverFailure));
      verify(
        () => mockRepository.forgotPassword(param: const ForgotPasswordRequestModel(email: testEmail)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const networkFailure = NetworkFailure('Network connection failed');
      when(
        () => mockRepository.forgotPassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(networkFailure));

      // Act
      final result = await useCase(param: const ForgotPasswordRequestModel(email: testEmail));

      // Assert
      expect(result, const Left<Failure, void>(networkFailure));
      verify(
        () => mockRepository.forgotPassword(param: const ForgotPasswordRequestModel(email: testEmail)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when authentication fails', () async {
      // Arrange
      const authFailure = AuthFailure('User not found');
      when(
        () => mockRepository.forgotPassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(authFailure));

      // Act
      final result = await useCase(param: const ForgotPasswordRequestModel(email: testEmail));

      // Assert
      expect(result, const Left<Failure, void>(authFailure));
      verify(
        () => mockRepository.forgotPassword(param: const ForgotPasswordRequestModel(email: testEmail)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle edge case with special characters in email', () async {
      // Arrange
      const specialEmail = 'user+tag@sub.domain.com';
      when(
        () => mockRepository.forgotPassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(param: const ForgotPasswordRequestModel(email: specialEmail));

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.forgotPassword(param: const ForgotPasswordRequestModel(email: specialEmail)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle very long email address', () async {
      // Arrange
      const longEmail = 'very.long.username.with.many.characters.123456789@very-long-domain-name.com';
      when(
        () => mockRepository.forgotPassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(param: const ForgotPasswordRequestModel(email: longEmail));

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.forgotPassword(param: const ForgotPasswordRequestModel(email: longEmail)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle unicode characters in email', () async {
      // Arrange
      const unicodeEmail = '测试用户@例子.测试';
      when(
        () => mockRepository.forgotPassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(param: const ForgotPasswordRequestModel(email: unicodeEmail));

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.forgotPassword(param: const ForgotPasswordRequestModel(email: unicodeEmail)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle null param gracefully', () async {
      // Arrange: Mock repository to handle null param
      when(
        () => mockRepository.forgotPassword(param: null),
      ).thenAnswer((_) async => const Left(ServerFailure('Invalid request parameters')));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, void>(ServerFailure('Invalid request parameters')));
      verify(() => mockRepository.forgotPassword(param: null)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty email string', () async {
      // Arrange
      const emptyEmail = '';
      const serverFailure = ServerFailure('Email cannot be empty');
      when(
        () => mockRepository.forgotPassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await useCase(param: const ForgotPasswordRequestModel(email: emptyEmail));

      // Assert
      expect(result, const Left<Failure, void>(serverFailure));
      verify(
        () => mockRepository.forgotPassword(param: const ForgotPasswordRequestModel(email: emptyEmail)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle whitespace-only email', () async {
      // Arrange
      const whitespaceEmail = '   ';
      const serverFailure = ServerFailure('Invalid email format');
      when(
        () => mockRepository.forgotPassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await useCase(param: const ForgotPasswordRequestModel(email: whitespaceEmail));

      // Assert
      expect(result, const Left<Failure, void>(serverFailure));
      verify(
        () => mockRepository.forgotPassword(param: const ForgotPasswordRequestModel(email: whitespaceEmail)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
