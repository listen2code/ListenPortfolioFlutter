import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Initialize test binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginViewModel Tests', () {
    late ProviderContainer container;
    late LoginViewModel viewModel;

    setUp(() {
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

    test('Should have initial state with empty credentials', () {
      // Verify initial state
      expect(viewModel.state.username, isEmpty);
      expect(viewModel.state.password, isEmpty);
      expect(viewModel.state.isPasswordVisible, isFalse);
      expect(viewModel.state.rememberMe, isFalse);
      expect(viewModel.state.usernameError, isNull);
      expect(viewModel.state.passwordError, isNull);
    });

    test('Should update username when username changed intent is handled', () {
      // When - Update username
      viewModel.handleIntent(const LoginIntent.usernameChanged('test_user'));

      // Then - Username should be updated
      expect(viewModel.state.username, 'test_user');
      expect(viewModel.state.usernameError, isNull);
    });

    test('Should update password when password changed intent is handled', () {
      // When - Update password
      viewModel.handleIntent(
        const LoginIntent.passwordChanged('test_password'),
      );

      // Then - Password should be updated
      expect(viewModel.state.password, 'test_password');
      expect(viewModel.state.passwordError, isNull);
    });

    test('Should clear error when credentials are updated', () {
      // Given - Set an error state first
      viewModel.updateState(
        viewModel.state.copyWith(usernameError: 'Username error'),
      );

      // When - Update username
      viewModel.handleIntent(const LoginIntent.usernameChanged('new_user'));

      // Then - Error should be cleared
      expect(viewModel.state.usernameError, isNull);
    });

    test('Should toggle password visibility when toggle intent is handled', () {
      // Given - Initial state
      expect(viewModel.state.isPasswordVisible, isFalse);

      // When - Toggle password visibility
      viewModel.handleIntent(const LoginIntent.togglePasswordVisibility());

      // Then - Password visibility should be toggled
      expect(viewModel.state.isPasswordVisible, isTrue);
    });

    test('Should handle multiple password visibility toggles', () {
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
}
