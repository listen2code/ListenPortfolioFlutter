import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_view_model.dart';
import 'package:listen_portfolio_flutter/shared/base/navigation_provider_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Initialize test binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SignUpViewModel Tests', () {
    late ProviderContainer container;
    late SignUpViewModel viewModel;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      // 2. Mock SharedPreferences for SpUtil
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      // 3. Setup container and VM
      container = ProviderContainer();
      viewModel = container.read(signUpViewModelProvider.notifier);

      // 4. Record emitted effects for verification
      emittedEffects.clear();
      viewModel.onBindEffect((effect) {
        emittedEffects.add(effect);
      });
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be empty', () {
      final state = viewModel.state;
      expect(state.fullName, isEmpty);
      expect(state.email, isEmpty);
      expect(state.password, isEmpty);
      expect(state.confirmPassword, isEmpty);
    });

    test('Should update fields when changed intents are handled', () async {
      // When - Update fields via intents
      await viewModel.handleIntent(const SignUpIntent.fullNameChanged('John Doe'));
      await viewModel.handleIntent(const SignUpIntent.emailChanged('john@example.com'));
      await viewModel.handleIntent(const SignUpIntent.passwordChanged('password123'));
      await viewModel.handleIntent(const SignUpIntent.confirmPasswordChanged('password123'));

      // Then - State should be updated correctly
      expect(viewModel.state.fullName, 'John Doe');
      expect(viewModel.state.email, 'john@example.com');
      expect(viewModel.state.password, 'password123');
      expect(viewModel.state.confirmPassword, 'password123');
    });

    test('Should show validation errors when fields are empty on submit', () async {
      // When - Submit with empty data
      await viewModel.handleIntent(const SignUpIntent.submitSignUp());

      // Then - Validation errors should be present in state
      expect(viewModel.state.fullNameError, isNotNull);
      expect(viewModel.state.emailError, isNotNull);
      expect(viewModel.state.passwordError, isNotNull);
      expect(viewModel.state.confirmPasswordError, isNotNull);
    });

    test('Should show password mismatch error', () async {
      // Given - Passwords that do not match
      await viewModel.handleIntent(const SignUpIntent.passwordChanged('password123'));
      await viewModel.handleIntent(const SignUpIntent.confirmPasswordChanged('password456'));

      // When - Submit sign up
      await viewModel.handleIntent(const SignUpIntent.submitSignUp());

      // Then - confirmPasswordError should be set
      expect(viewModel.state.confirmPasswordError, isNotNull);
    });

    test('Should emit NavigationEffect.back when navigateToLogin is handled', () async {
      // When - Trigger navigate to login intent
      await viewModel.handleIntent(const SignUpIntent.navigateToLogin());

      // Then - NavigationEffect (back) should be emitted (check isBack flag)
      expect(emittedEffects.any((e) => e is NavigationEffect && e.isBack == true), isTrue);
    });
  });
}
