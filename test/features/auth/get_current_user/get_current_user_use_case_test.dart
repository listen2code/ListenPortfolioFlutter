import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/get_current_user_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

// Mock repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentUserUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
  });

  group('GetCurrentUserUseCase', () {
    const testUserId = 'user_123';
    final testParam = GetCurrentUserRequestModel(userId: testUserId);
    final testUser = UserModel(id: testUserId, name: 'Test User', email: 'test@example.com');

    test('should return UserModel on success', () async {
      // Arrange
      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, Right<Failure, UserModel?>(testUser));
      verify(() => mockRepository.getCurrentUser(param: testParam)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when user not found', () async {
      // Arrange
      const failure = ServerFailure('User not found');
      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, const Left<Failure, UserModel?>(failure));
      verify(() => mockRepository.getCurrentUser(param: testParam)).called(1);
    });

    test('should return AuthFailure when token is invalid', () async {
      // Arrange
      const failure = AuthFailure('Invalid or expired token');
      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, const Left<Failure, UserModel?>(failure));
    });

    test('should return NetworkFailure on network error', () async {
      // Arrange
      const failure = NetworkFailure('No internet connection');
      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, const Left<Failure, UserModel?>(failure));
    });

    test('should pass null param directly to repository', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser(param: null)).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Right<Failure, UserModel?>(null));
      verify(() => mockRepository.getCurrentUser(param: null)).called(1);
    });

    test('should return Right(null) when repository returns null user', () async {
      // Arrange — server may return empty profile for guest-like states
      when(
        () => mockRepository.getCurrentUser(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, const Right<Failure, UserModel?>(null));
    });
  });
}
