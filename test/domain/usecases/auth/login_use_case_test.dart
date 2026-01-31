import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/errors/failures.dart';
import 'package:listen_portfolio_flutter/domain/entities/auth/user.dart';
import 'package:listen_portfolio_flutter/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/domain/usecases/auth/login_use_case.dart';
import 'package:mocktail/mocktail.dart';

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
    final testUser = User(id: '1', name: 'Test User', email: 'test@example.com', createdAt: DateTime(2024, 1, 1));

    test('should return User when login is successful', () async {
      // Arrange
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(LoginParams(username: testUsername, password: testPassword));

      // Assert
      expect(result, Right<Failure, User>(testUser));
      verify(() => mockRepository.login(username: testUsername, password: testPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when username is empty', () async {
      // Arrange
      const emptyUsername = '';

      // Act
      final result = await useCase(LoginParams(username: emptyUsername, password: testPassword));

      // Assert
      expect(result, const Left<Failure, User>(ValidationFailure('Username cannot be empty')));
      verifyNever(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    test('should return ValidationFailure when password is less than 6 characters', () async {
      // Arrange
      const shortPassword = '12345';

      // Act
      final result = await useCase(LoginParams(username: testUsername, password: shortPassword));

      // Assert
      expect(result, const Left<Failure, User>(ValidationFailure('Password must be at least 6 characters')));
      verifyNever(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    test('should return ServerFailure when repository returns server error', () async {
      // Arrange
      const serverFailure = ServerFailure('Server error occurred');
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await useCase(LoginParams(username: testUsername, password: testPassword));

      // Assert
      expect(result, const Left<Failure, User>(serverFailure));
      verify(() => mockRepository.login(username: testUsername, password: testPassword)).called(1);
    });

    test('should return NetworkFailure when there is no internet connection', () async {
      // Arrange
      const networkFailure = NetworkFailure('No internet connection');
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(networkFailure));

      // Act
      final result = await useCase(LoginParams(username: testUsername, password: testPassword));

      // Assert
      expect(result, const Left<Failure, User>(networkFailure));
      verify(() => mockRepository.login(username: testUsername, password: testPassword)).called(1);
    });

    test('should return AuthFailure when credentials are invalid', () async {
      // Arrange
      const authFailure = AuthFailure('Invalid username or password');
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(authFailure));

      // Act
      final result = await useCase(LoginParams(username: testUsername, password: 'wrongpassword'));

      // Assert
      expect(result, const Left<Failure, User>(authFailure));
      verify(() => mockRepository.login(username: testUsername, password: 'wrongpassword')).called(1);
    });

    test('should pass correct parameters to repository', () async {
      // Arrange
      const username = 'john_doe';
      const password = 'securePass123';
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      await useCase(LoginParams(username: username, password: password));

      // Assert
      verify(() => mockRepository.login(username: username, password: password)).called(1);
    });
  });
}
