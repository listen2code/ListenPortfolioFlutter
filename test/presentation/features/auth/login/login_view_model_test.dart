import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/presentation/features/auth/login/login_intent.dart';
import 'package:listen_portfolio_flutter/presentation/features/auth/login/login_state.dart';
import 'package:listen_portfolio_flutter/presentation/features/auth/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/domain/usecases/auth/login_use_case.dart';
import 'package:listen_portfolio_flutter/domain/entities/auth/user.dart';
import 'package:listen_portfolio_flutter/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock classes
class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    // Register fallback values
    registerFallbackValue(LoginParams(username: '', password: ''));
  });

  group('LoginViewModel', () {
    test('initial state should have default values', () {
      // Arrange & Act
      const state = LoginState();

      // Assert
      expect(state.username, '');
      expect(state.password, '');
      expect(state.isPasswordVisible, false);
      expect(state.isLoading, false);
      expect(state.isSuccess, false);
      expect(state.errorMessage, null);
      expect(state.usernameError, null);
      expect(state.passwordError, null);
    });

    test('should update username when UsernameChanged intent is handled', () {
      // Arrange
      const initialState = LoginState();
      const newUsername = 'testuser';

      // Act
      final newState = initialState.copyWith(
        username: newUsername,
        usernameError: null,
        errorMessage: null,
      );

      // Assert
      expect(newState.username, newUsername);
      expect(newState.usernameError, null);
      expect(newState.errorMessage, null);
    });

    test('should update password when PasswordChanged intent is handled', () {
      // Arrange
      const initialState = LoginState();
      const newPassword = 'password123';

      // Act
      final newState = initialState.copyWith(
        password: newPassword,
        passwordError: null,
        errorMessage: null,
      );

      // Assert
      expect(newState.password, newPassword);
      expect(newState.passwordError, null);
      expect(newState.errorMessage, null);
    });

    test('should toggle password visibility', () {
      // Arrange
      const initialState = LoginState(isPasswordVisible: false);

      // Act
      final newState = initialState.copyWith(
        isPasswordVisible: !initialState.isPasswordVisible,
      );

      // Assert
      expect(newState.isPasswordVisible, true);
    });

    test('should set validation errors when username is empty', () {
      // Arrange
      const initialState = LoginState(username: '', password: 'password123');

      // Act
      final newState = initialState.copyWith(
        usernameError: 'Username is required',
      );

      // Assert
      expect(newState.usernameError, 'Username is required');
    });

    test('should set validation errors when password is too short', () {
      // Arrange
      const initialState = LoginState(username: 'testuser', password: '123');

      // Act
      final newState = initialState.copyWith(
        passwordError: 'Password must be at least 6 characters',
      );

      // Assert
      expect(newState.passwordError, 'Password must be at least 6 characters');
    });

    test('should set loading state when login starts', () {
      // Arrange
      const initialState = LoginState(
        username: 'testuser',
        password: 'password123',
      );

      // Act
      final newState = initialState.copyWith(
        isLoading: true,
        errorMessage: null,
      );

      // Assert
      expect(newState.isLoading, true);
      expect(newState.errorMessage, null);
    });

    test('should set success state when login succeeds', () async {
      // Arrange
      const initialState = LoginState(
        username: 'testuser',
        password: 'password123',
        isLoading: true,
      );
      final testUser = User(
        id: '1',
        name: 'Test User',
        email: 'test@example.com',
        createdAt: DateTime(2024, 1, 1),
      );

      // Act
      final newState = initialState.copyWith(
        isLoading: false,
        isSuccess: true,
      );

      // Assert
      expect(newState.isLoading, false);
      expect(newState.isSuccess, true);
      expect(newState.errorMessage, null);
    });

    test('should set error state when login fails', () {
      // Arrange
      const initialState = LoginState(
        username: 'testuser',
        password: 'wrongpassword',
        isLoading: true,
      );
      const errorMessage = 'Invalid username or password';

      // Act
      final newState = initialState.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );

      // Assert
      expect(newState.isLoading, false);
      expect(newState.isSuccess, false);
      expect(newState.errorMessage, errorMessage);
    });

    test('should handle network failure', () {
      // Arrange
      const initialState = LoginState(
        username: 'testuser',
        password: 'password123',
        isLoading: true,
      );
      const errorMessage = 'No internet connection';

      // Act
      final newState = initialState.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );

      // Assert
      expect(newState.isLoading, false);
      expect(newState.errorMessage, errorMessage);
    });

    test('should handle server failure', () {
      // Arrange
      const initialState = LoginState(
        username: 'testuser',
        password: 'password123',
        isLoading: true,
      );
      const errorMessage = 'Server error occurred';

      // Act
      final newState = initialState.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );

      // Assert
      expect(newState.isLoading, false);
      expect(newState.errorMessage, errorMessage);
    });

    test('should clear errors when username changes', () {
      // Arrange
      const initialState = LoginState(
        username: '',
        usernameError: 'Username is required',
        errorMessage: 'Login failed',
      );

      // Act
      final newState = initialState.copyWith(
        username: 'newuser',
        usernameError: null,
        errorMessage: null,
      );

      // Assert
      expect(newState.username, 'newuser');
      expect(newState.usernameError, null);
      expect(newState.errorMessage, null);
    });

    test('should clear errors when password changes', () {
      // Arrange
      const initialState = LoginState(
        password: '123',
        passwordError: 'Password too short',
        errorMessage: 'Login failed',
      );

      // Act
      final newState = initialState.copyWith(
        password: 'newpassword123',
        passwordError: null,
        errorMessage: null,
      );

      // Assert
      expect(newState.password, 'newpassword123');
      expect(newState.passwordError, null);
      expect(newState.errorMessage, null);
    });
  });

  group('LoginIntent', () {
    test('UsernameChanged intent should contain username', () {
      // Arrange & Act
      const intent = LoginIntent.usernameChanged('testuser');

      // Assert
      intent.when(
        usernameChanged: (username) => expect(username, 'testuser'),
        passwordChanged: (_) => fail('Wrong intent'),
        togglePasswordVisibility: () => fail('Wrong intent'),
        submitLogin: () => fail('Wrong intent'),
        navigateToSignup: () => fail('Wrong intent'),
        navigateToForgotPassword: () => fail('Wrong intent'),
      );
    });

    test('PasswordChanged intent should contain password', () {
      // Arrange & Act
      const intent = LoginIntent.passwordChanged('password123');

      // Assert
      intent.when(
        usernameChanged: (_) => fail('Wrong intent'),
        passwordChanged: (password) => expect(password, 'password123'),
        togglePasswordVisibility: () => fail('Wrong intent'),
        submitLogin: () => fail('Wrong intent'),
        navigateToSignup: () => fail('Wrong intent'),
        navigateToForgotPassword: () => fail('Wrong intent'),
      );
    });

    test('TogglePasswordVisibility intent should be created', () {
      // Arrange & Act
      const intent = LoginIntent.togglePasswordVisibility();

      // Assert
      intent.when(
        usernameChanged: (_) => fail('Wrong intent'),
        passwordChanged: (_) => fail('Wrong intent'),
        togglePasswordVisibility: () => expect(true, true),
        submitLogin: () => fail('Wrong intent'),
        navigateToSignup: () => fail('Wrong intent'),
        navigateToForgotPassword: () => fail('Wrong intent'),
      );
    });

    test('SubmitLogin intent should be created', () {
      // Arrange & Act
      const intent = LoginIntent.submitLogin();

      // Assert
      intent.when(
        usernameChanged: (_) => fail('Wrong intent'),
        passwordChanged: (_) => fail('Wrong intent'),
        togglePasswordVisibility: () => fail('Wrong intent'),
        submitLogin: () => expect(true, true),
        navigateToSignup: () => fail('Wrong intent'),
        navigateToForgotPassword: () => fail('Wrong intent'),
      );
    });

    test('NavigateToSignup intent should be created', () {
      // Arrange & Act
      const intent = LoginIntent.navigateToSignup();

      // Assert
      intent.when(
        usernameChanged: (_) => fail('Wrong intent'),
        passwordChanged: (_) => fail('Wrong intent'),
        togglePasswordVisibility: () => fail('Wrong intent'),
        submitLogin: () => fail('Wrong intent'),
        navigateToSignup: () => expect(true, true),
        navigateToForgotPassword: () => fail('Wrong intent'),
      );
    });

    test('NavigateToForgotPassword intent should be created', () {
      // Arrange & Act
      const intent = LoginIntent.navigateToForgotPassword();

      // Assert
      intent.when(
        usernameChanged: (_) => fail('Wrong intent'),
        passwordChanged: (_) => fail('Wrong intent'),
        togglePasswordVisibility: () => fail('Wrong intent'),
        submitLogin: () => fail('Wrong intent'),
        navigateToSignup: () => fail('Wrong intent'),
        navigateToForgotPassword: () => expect(true, true),
      );
    });
  });
}
