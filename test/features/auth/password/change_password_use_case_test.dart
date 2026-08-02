import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/change_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/change_password_use_case.dart';
import 'package:mocktail/mocktail.dart';

///
/// ChangePasswordUseCase 单元测试
///
/// 测试覆盖范围：
/// 1. 正常密码修改流程（成功场景）
/// 2. 业务逻辑验证（新旧密码不能相同）
/// 3. 各种失败场景（空密码、网络错误、服务器错误等）
/// 4. 边界情况（特殊字符、Unicode、超长密码等）
///
/// 架构原则：
/// - UseCase层负责业务逻辑验证（如新旧密码不能相同）
/// - 其他验证逻辑应在ViewModel层处理
/// - UseCase直接返回Repository的失败结果或业务验证失败
///

// Mock repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ChangePasswordUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ChangePasswordUseCase(mockRepository);
  });

  group('ChangePasswordUseCase', () {
    const testUserId = 'user_123';
    const testOldPassword = 'oldPassword123';
    const testNewPassword = 'newPassword123';

    test('should return success when changePassword is successful', () async {
      // Arrange: Mock repository to return success
      when(
        () => mockRepository.changePassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: testOldPassword,
          newPassword: testNewPassword,
        ),
      );

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.changePassword(
          param: const ChangePasswordRequestModel(
            userId: testUserId,
            oldPassword: testOldPassword,
            newPassword: testNewPassword,
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when new password is same as old password', () async {
      // Arrange - Same password for old and new
      const samePassword = 'password123';

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: samePassword,
          newPassword: samePassword,
        ),
      );

      // Assert - Should return validation failure without calling repository
      expect(
        result,
        const Left<Failure, void>(ValidationFailure('New password cannot be the same as the old one')),
      );
      verifyNever(() => mockRepository.changePassword(param: any(named: 'param')));
    });

    test('should return ServerFailure when repository returns ServerFailure', () async {
      // Arrange
      const serverFailure = ServerFailure('Server error occurred');
      when(
        () => mockRepository.changePassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: testOldPassword,
          newPassword: testNewPassword,
        ),
      );

      // Assert
      expect(result, const Left<Failure, void>(serverFailure));
      verify(
        () => mockRepository.changePassword(
          param: const ChangePasswordRequestModel(
            userId: testUserId,
            oldPassword: testOldPassword,
            newPassword: testNewPassword,
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const networkFailure = NetworkFailure('Network connection failed');
      when(
        () => mockRepository.changePassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(networkFailure));

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: testOldPassword,
          newPassword: testNewPassword,
        ),
      );

      // Assert
      expect(result, const Left<Failure, void>(networkFailure));
      verify(
        () => mockRepository.changePassword(
          param: const ChangePasswordRequestModel(
            userId: testUserId,
            oldPassword: testOldPassword,
            newPassword: testNewPassword,
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when authentication fails', () async {
      // Arrange
      const authFailure = AuthFailure('Invalid old password');
      when(
        () => mockRepository.changePassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(authFailure));

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: testOldPassword,
          newPassword: testNewPassword,
        ),
      );

      // Assert
      expect(result, const Left<Failure, void>(authFailure));
      verify(
        () => mockRepository.changePassword(
          param: const ChangePasswordRequestModel(
            userId: testUserId,
            oldPassword: testOldPassword,
            newPassword: testNewPassword,
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle edge case with special characters in passwords', () async {
      // Arrange
      const specialOldPassword = 'old@#\$%^&*()Pass123';
      const specialNewPassword = 'new@#\$%^&*()Pass456';
      when(
        () => mockRepository.changePassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: specialOldPassword,
          newPassword: specialNewPassword,
        ),
      );

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.changePassword(
          param: const ChangePasswordRequestModel(
            userId: testUserId,
            oldPassword: specialOldPassword,
            newPassword: specialNewPassword,
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle very long passwords', () async {
      // Arrange
      const longOldPassword = 'very_long_old_password_with_many_characters_12345678901234567890';
      const longNewPassword = 'very_long_new_password_with_many_characters_12345678901234567890';
      when(
        () => mockRepository.changePassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: longOldPassword,
          newPassword: longNewPassword,
        ),
      );

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.changePassword(
          param: const ChangePasswordRequestModel(
            userId: testUserId,
            oldPassword: longOldPassword,
            newPassword: longNewPassword,
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle unicode characters in passwords', () async {
      // Arrange
      const unicodeOldPassword = '旧密码_старый_🔑';
      const unicodeNewPassword = '新密码_новый_🔒';
      when(
        () => mockRepository.changePassword(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: unicodeOldPassword,
          newPassword: unicodeNewPassword,
        ),
      );

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.changePassword(
          param: const ChangePasswordRequestModel(
            userId: testUserId,
            oldPassword: unicodeOldPassword,
            newPassword: unicodeNewPassword,
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle null param gracefully', () async {
      // Act
      final result = await useCase(param: null);

      // Assert - When param is null, both old and new password are null, so they are considered "the same"
      expect(
        result,
        const Left<Failure, void>(ValidationFailure('New password cannot be the same as the old one')),
      );
      verifyNever(() => mockRepository.changePassword(param: any(named: 'param')));
    });

    test('should handle empty passwords', () async {
      // Arrange
      const emptyOldPassword = '';
      const emptyNewPassword = '';
      // When both passwords are empty strings, they are considered "the same"
      // so UseCase should return ValidationFailure without calling repository

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: emptyOldPassword,
          newPassword: emptyNewPassword,
        ),
      );

      // Assert - Should return validation failure because empty strings are equal
      expect(
        result,
        const Left<Failure, void>(ValidationFailure('New password cannot be the same as the old one')),
      );
      verifyNever(() => mockRepository.changePassword(param: any(named: 'param')));
    });

    test('should handle whitespace-only passwords', () async {
      // Arrange
      const whitespaceOldPassword = '   ';
      const whitespaceNewPassword = '   ';
      // When both passwords are whitespace-only strings, they are considered "the same"
      // so UseCase should return ValidationFailure without calling repository

      // Act
      final result = await useCase(
        param: const ChangePasswordRequestModel(
          userId: testUserId,
          oldPassword: whitespaceOldPassword,
          newPassword: whitespaceNewPassword,
        ),
      );

      // Assert - Should return validation failure because whitespace strings are equal
      expect(
        result,
        const Left<Failure, void>(ValidationFailure('New password cannot be the same as the old one')),
      );
      verifyNever(() => mockRepository.changePassword(param: any(named: 'param')));
    });
  });
}
