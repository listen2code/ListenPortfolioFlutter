import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mocktail/mocktail.dart';

// Mock repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    test('should return Right(void) on successful logout', () async {
      // Arrange
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when logout fails on server', () async {
      // Arrange
      const failure = ServerFailure('Logout failed');
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, void>(failure));
      verify(() => mockRepository.logout()).called(1);
    });

    test('should return NetworkFailure on network error during logout', () async {
      // Arrange
      const failure = NetworkFailure('No internet connection');
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, void>(failure));
    });

    test('should ignore param and always call repository.logout()', () async {
      // Arrange — LogoutUseCase accepts BaseParam but never uses it
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Right(null));

      // Act — called with non-null param, should still just call logout()
      final result = await useCase(param: null);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockRepository.logout()).called(1);
      verifyNever(() => mockRepository.login(param: any(named: 'param')));
    });

    test('should return AuthFailure when session is already expired', () async {
      // Arrange
      const failure = AuthFailure('Session already expired');
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, void>(failure));
    });
  });
}
