import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/delete_account_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/delete_account_use_case.dart';
import 'package:mocktail/mocktail.dart';

// Mock repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late DeleteAccountUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = DeleteAccountUseCase(mockRepository);
  });

  group('DeleteAccountUseCase', () {
    const testUserId = 'user_123';
    final testParam = DeleteAccountRequestModel(userId: testUserId);

    test('should return Right(void) on successful account deletion', () async {
      // Arrange
      when(
        () => mockRepository.deleteAccount(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockRepository.deleteAccount(param: testParam)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when deletion fails on server', () async {
      // Arrange
      const failure = ServerFailure('Failed to delete account');
      when(
        () => mockRepository.deleteAccount(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, const Left<Failure, void>(failure));
      verify(() => mockRepository.deleteAccount(param: testParam)).called(1);
    });

    test('should return AuthFailure when user is not authenticated', () async {
      // Arrange
      const failure = AuthFailure('Not authorized to delete this account');
      when(
        () => mockRepository.deleteAccount(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, const Left<Failure, void>(failure));
    });

    test('should return NetworkFailure on network error', () async {
      // Arrange
      const failure = NetworkFailure('No internet connection');
      when(
        () => mockRepository.deleteAccount(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, const Left<Failure, void>(failure));
    });

    test('should pass null param directly to repository', () async {
      // Arrange — validation is the ViewModel's responsibility
      const failure = ServerFailure('Missing user ID');
      when(() => mockRepository.deleteAccount(param: null)).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, void>(failure));
      verify(() => mockRepository.deleteAccount(param: null)).called(1);
    });
  });
}
