import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/get_current_user_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
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
    const testUserId = 'user_123';

    final testUser = UserModel(id: testUserId, name: 'Test UserModel', email: 'test@example.com');

    final testLoginResponse = LoginModel(token: 'token_abc', userId: testUserId);

    test('should return UserModel when login and getCurrentUser are successful', () async {
      // Arrange: Mock both login and subsequent profile fetch
      when(
        () => mockRepository.login(
          param: LoginRequestModel(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ),
      ).thenAnswer((_) async => Right(testLoginResponse));

      when(
        () => mockRepository.getCurrentUser(
          param: GetCurrentUserRequestModel(userId: any(named: 'userId')),
        ),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(
        param: LoginRequestModel(username: testUsername, password: testPassword),
      );

      // Assert
      expect(result, Right<Failure, UserModel?>(testUser));

      // Verify the sequence of calls
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(username: testUsername, password: testPassword),
        ),
      ).called(1);
      verify(
        () => mockRepository.getCurrentUser(param: GetCurrentUserRequestModel(userId: testUserId)),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when username is empty', () async {
      // Act
      final result = await useCase(
        param: LoginRequestModel(username: '', password: testPassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(ValidationFailure('Username cannot be empty')));
      verifyNever(
        () => mockRepository.login(
          param: LoginRequestModel(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ),
      );
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      const serverFailure = ServerFailure('Invalid Credentials');
      when(
        () => mockRepository.login(
          param: LoginRequestModel(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ),
      ).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await useCase(
        param: LoginRequestModel(username: testUsername, password: testPassword),
      );

      // Assert
      expect(result, const Left<Failure, UserModel?>(serverFailure));
      verify(
        () => mockRepository.login(
          param: LoginRequestModel(username: testUsername, password: testPassword),
        ),
      ).called(1);
      verifyNever(
        () => mockRepository.getCurrentUser(
          param: GetCurrentUserRequestModel(userId: any(named: 'userId')),
        ),
      );
    });
  });
}
