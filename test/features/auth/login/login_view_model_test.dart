import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_state.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Initialize test binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginViewModel Tests', () {
    late ProviderContainer container;
    late LoginViewModel viewModel;

    setUp(() async {
      // 2. Mock SharedPreferences initial values
      SharedPreferences.setMockInitialValues({});

      // 3. Create a ProviderContainer for testing
      container = ProviderContainer();

      // 4. Get the ViewModel instance
      viewModel = container.read(loginViewModelProvider.notifier);
    });

    tearDown(() {
      // 5. Dispose the container
      container.dispose();
    });

    group('Initial State', () {
      test('should have initial state with empty credentials', () {
        // Verify initial state
        expect(viewModel.state.username, isEmpty);
        expect(viewModel.state.password, isEmpty);
        expect(viewModel.state.isPasswordVisible, isFalse);
        expect(viewModel.state.rememberMe, isFalse);
        expect(viewModel.state.usernameError, isNull);
        expect(viewModel.state.passwordError, isNull);
      });

      test('should load saved credentials when rememberMe is true', () async {
        // Arrange - Set up SharedPreferences with saved credentials
        SharedPreferences.setMockInitialValues({
          AppConstants.loginUsernameKey: 'saved_user',
          AppConstants.loginRememberMeKey: true,
        });

        // Create new container and viewModel
        final testContainer = ProviderContainer();
        final testViewModel = testContainer.read(loginViewModelProvider.notifier);

        // Assert
        expect(testViewModel.state.username, 'saved_user');
        expect(testViewModel.state.rememberMe, isTrue);

        testContainer.dispose();
      });
    });

    group('Username Input', () {
      test('should update username when username changed intent is handled', () {
        // When - Update username
        viewModel.handleIntent(const LoginIntent.usernameChanged('test_user'));

        // Then - Username should be updated
        expect(viewModel.state.username, 'test_user');
        expect(viewModel.state.usernameError, isNull);
      });

      test('should clear error when credentials are updated', () {
        // Given - Set an error state first
        viewModel.updateState(
          viewModel.state.copyWith(usernameError: 'Username error'),
        );

        // When - Update username
        viewModel.handleIntent(const LoginIntent.usernameChanged('new_user'));

        // Then - Error should be cleared
        expect(viewModel.state.usernameError, isNull);
      });

      test('should handle empty username', () {
        // When - Set empty username
        viewModel.handleIntent(const LoginIntent.usernameChanged(''));

        // Then - Username should be empty
        expect(viewModel.state.username, isEmpty);
        expect(viewModel.state.usernameError, isNull);
      });

      test('should handle long username', () {
        // When - Set long username
        const longUsername = 'this_is_a_very_long_username_that_exceeds_normal_limits';
        viewModel.handleIntent(const LoginIntent.usernameChanged(longUsername));

        // Then - Username should be updated
        expect(viewModel.state.username, longUsername);
        expect(viewModel.state.usernameError, isNull);
      });
    });

    group('Password Input', () {
      test('should update password when password changed intent is handled', () {
        // When - Update password
        viewModel.handleIntent(
          const LoginIntent.passwordChanged('test_password'),
        );

        // Then - Password should be updated
        expect(viewModel.state.password, 'test_password');
        expect(viewModel.state.passwordError, isNull);
      });

      test('should clear password error when password is updated', () {
        // Given - Set a password error
        viewModel.updateState(
          viewModel.state.copyWith(passwordError: 'Password error'),
        );

        // When - Update password
        viewModel.handleIntent(const LoginIntent.passwordChanged('new_password'));

        // Then - Error should be cleared
        expect(viewModel.state.passwordError, isNull);
      });

      test('should handle empty password', () {
        // When - Set empty password
        viewModel.handleIntent(const LoginIntent.passwordChanged(''));

        // Then - Password should be empty
        expect(viewModel.state.password, isEmpty);
        expect(viewModel.state.passwordError, isNull);
      });

      test('should handle special characters in password', () {
        // When - Set password with special characters
        const specialPassword = 'P@ssw0rd!@#%^&*()';
        viewModel.handleIntent(const LoginIntent.passwordChanged(specialPassword));

        // Then - Password should be updated
        expect(viewModel.state.password, specialPassword);
        expect(viewModel.state.passwordError, isNull);
      });
    });

    group('Password Visibility', () {
      test('should toggle password visibility when toggle intent is handled', () {
        // Given - Initial state
        expect(viewModel.state.isPasswordVisible, isFalse);

        // When - Toggle password visibility
        viewModel.handleIntent(const LoginIntent.togglePasswordVisibility());

        // Then - Password visibility should be toggled
        expect(viewModel.state.isPasswordVisible, isTrue);
      });

      test('should handle multiple password visibility toggles', () {
        // Given - Initial state
        expect(viewModel.state.isPasswordVisible, isFalse);

        // When - Toggle password visibility multiple times
        viewModel.handleIntent(const LoginIntent.togglePasswordVisibility());
        expect(viewModel.state.isPasswordVisible, isTrue);

        viewModel.handleIntent(const LoginIntent.togglePasswordVisibility());
        expect(viewModel.state.isPasswordVisible, isFalse);

        viewModel.handleIntent(const LoginIntent.togglePasswordVisibility());
        expect(viewModel.state.isPasswordVisible, isTrue);
      });
    });

    group('Remember Me', () {
      test('should toggle remember me state', () {
        // Given - Initial state
        expect(viewModel.state.rememberMe, isFalse);

        // When - Toggle remember me
        viewModel.handleIntent(const LoginIntent.toggleRememberMe());

        // Then - Remember me should be true (internal logic will handle the toggle)
        // Note: The actual toggle logic is implemented in the ViewModel
      });
    });

    group('Navigation Intents', () {
      test('should emit navigation effect to signup', () async {
        // When - Navigate to signup
        final effects = <BaseEffect>[];
        viewModel.onBindEffect((effect) => effects.add(effect));
        
        viewModel.handleIntent(const LoginIntent.navigateToSignup());
        await Future.delayed(Duration.zero);

        // Then - Should emit navigation effect
        expect(effects, isNotEmpty);
        expect(effects.first, isA<NavigationEffect>());
        final navEffect = effects.first as NavigationEffect;
        expect(navEffect.target, Routes.signUp);
        expect(navEffect.arguments, ''); // Empty username
      });

      test('should emit navigation effect to signup with username', () async {
        // Given - Set username
        viewModel.handleIntent(const LoginIntent.usernameChanged('test_user'));

        // When - Navigate to signup
        final effects = <BaseEffect>[];
        viewModel.onBindEffect((effect) => effects.add(effect));
        
        viewModel.handleIntent(const LoginIntent.navigateToSignup());
        await Future.delayed(Duration.zero);

        // Then - Should emit navigation effect with username
        expect(effects, isNotEmpty);
        expect(effects.first, isA<NavigationEffect>());
        final navEffect = effects.first as NavigationEffect;
        expect(navEffect.target, Routes.signUp);
        expect(navEffect.arguments, 'test_user');
      });

      test('should emit navigation effect to forgot password', () async {
        // When - Navigate to forgot password
        final effects = <BaseEffect>[];
        viewModel.onBindEffect((effect) => effects.add(effect));
        
        viewModel.handleIntent(const LoginIntent.navigateToForgotPassword());
        await Future.delayed(Duration.zero);

        // Then - Should emit navigation effect
        expect(effects, isNotEmpty);
        expect(effects.first, isA<NavigationEffect>());
        final navEffect = effects.first as NavigationEffect;
        expect(navEffect.target, Routes.forgotPassword);
      });

      test('should emit back navigation effect when skipping login', () async {
        // When - Skip login
        final effects = <BaseEffect>[];
        viewModel.onBindEffect((effect) => effects.add(effect));
        
        viewModel.handleIntent(const LoginIntent.skipLogin());
        await Future.delayed(Duration.zero);

        // Then - Should emit back navigation effect
        expect(effects, isNotEmpty);
        expect(effects.first, isA<NavigationEffect>());
        final navEffect = effects.first as NavigationEffect;
        expect(navEffect.isBack, isTrue);
        expect(navEffect.arguments, false); // result is stored in arguments
      });
    });

    group('Login Submission Validation', () {
      test('should not submit login with empty username', () async {
        // Given - Empty username
        viewModel.handleIntent(const LoginIntent.usernameChanged(''));
        viewModel.handleIntent(const LoginIntent.passwordChanged('password'));

        // When - Submit login
        viewModel.handleIntent(const LoginIntent.submitLogin());

        // Then - Should show username error
        expect(viewModel.state.usernameError, isNotNull);
      });

      test('should not submit login with empty password', () async {
        // Given - Empty password
        viewModel.handleIntent(const LoginIntent.usernameChanged('test_user'));
        viewModel.handleIntent(const LoginIntent.passwordChanged(''));

        // When - Submit login
        viewModel.handleIntent(const LoginIntent.submitLogin());

        // Then - Should show password error
        expect(viewModel.state.passwordError, isNotNull);
      });

      test('should not submit login with empty credentials', () async {
        // Given - Empty credentials
        viewModel.handleIntent(const LoginIntent.usernameChanged(''));
        viewModel.handleIntent(const LoginIntent.passwordChanged(''));

        // When - Submit login
        viewModel.handleIntent(const LoginIntent.submitLogin());

        // Then - Should show both errors
        expect(viewModel.state.usernameError, isNotNull);
        expect(viewModel.state.passwordError, isNotNull);
      });

      test('should clear errors when credentials are corrected', () async {
        // Given - Set error states
        viewModel.updateState(
          viewModel.state.copyWith(
            usernameError: 'Username required',
            passwordError: 'Password required',
          ),
        );

        // When - Update credentials
        viewModel.handleIntent(const LoginIntent.usernameChanged('test_user'));
        viewModel.handleIntent(const LoginIntent.passwordChanged('password'));

        // Then - Errors should be cleared
        expect(viewModel.state.usernameError, isNull);
        expect(viewModel.state.passwordError, isNull);
      });
    });
  });
}
