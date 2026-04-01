import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/signup_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/signup_use_case.dart';
import 'package:mocktail/mocktail.dart';

// Mock repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignupUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignupUseCase(mockRepository);
  });

  group('SignupUseCase', () {
    final validParam = SignupRequestModel(
      userName: 'testuser',
      email: 'test@example.com',
      password: 'password123',
    );

    test('should return Right(void) on successful signup', () async {
      // Arrange
      when(
        () => mockRepository.signUp(param: any(named: 'param')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(param: validParam);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockRepository.signUp(param: validParam)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when server rejects signup', () async {
      // Arrange
      const failure = ServerFailure('Username already taken');
      when(
        () => mockRepository.signUp(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: validParam);

      // Assert
      expect(result, const Left<Failure, void>(failure));
      verify(() => mockRepository.signUp(param: validParam)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure on network error', () async {
      // Arrange
      const failure = NetworkFailure('No internet connection');
      when(
        () => mockRepository.signUp(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: validParam);

      // Assert
      expect(result, const Left<Failure, void>(failure));
      verify(() => mockRepository.signUp(param: validParam)).called(1);
    });

    test('should return ServerFailure for duplicate email', () async {
      // Arrange
      const failure = ServerFailure('Email already in use');
      final duplicateEmailParam = SignupRequestModel(
        userName: 'newuser',
        email: 'existing@example.com',
        password: 'password123',
      );
      when(
        () => mockRepository.signUp(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: duplicateEmailParam);

      // Assert
      expect(result, const Left<Failure, void>(failure));
    });

    test('should pass null param directly to repository', () async {
      // Arrange — validation belongs to ViewModel layer, not UseCase
      const failure = ServerFailure('Invalid request');
      when(() => mockRepository.signUp(param: null)).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, void>(failure));
      verify(() => mockRepository.signUp(param: null)).called(1);
    });

    test('should propagate AuthFailure from repository', () async {
      // Arrange
      const failure = AuthFailure('Unauthorized signup attempt');
      when(
        () => mockRepository.signUp(param: any(named: 'param')),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(param: validParam);

      // Assert
      expect(result, const Left<Failure, void>(failure));
    });
  });
}
