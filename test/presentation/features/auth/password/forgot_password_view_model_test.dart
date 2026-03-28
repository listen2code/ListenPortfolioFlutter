import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_view_model.dart';
import 'package:listen_portfolio_flutter/shared/base/navigation_provider_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Initialize test binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ForgotPasswordViewModel Tests', () {
    late ProviderContainer container;
    late ForgotPasswordViewModel viewModel;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      // 2. Mock SharedPreferences for SpUtil initialization
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      // 3. Create a ProviderContainer for testing
      container = ProviderContainer();
      viewModel = container.read(forgotPasswordViewModelProvider.notifier);

      // 4. Record emitted effects for verification
      emittedEffects.clear();
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));
    });

    tearDown(() {
      container.dispose();
    });

    test('Should update email when emailChanged intent is handled', () async {
      const email = 'test@example.com';

      // When - Update email via intent
      await viewModel.handleIntent(const ForgotPasswordIntent.emailChanged(email));

      // Then - State should be updated correctly
      expect(viewModel.state.email, email);
      expect(viewModel.state.emailError, isNull);
    });

    test('Should show error for invalid email format on submit', () async {
      // Given - Invalid email format
      await viewModel.handleIntent(const ForgotPasswordIntent.emailChanged('invalid-email'));

      // When - Submit reset request intent
      await viewModel.handleIntent(const ForgotPasswordIntent.submitReset());

      // Then - State should contain email validation error
      expect(viewModel.state.emailError, isNotNull);
    });

    test('Should emit NavigationEffect.back when navigateToLogin is handled', () async {
      // When - Trigger navigate back intent
      await viewModel.handleIntent(const ForgotPasswordIntent.navigateToLogin());

      // Then - Verify NavigationEffect.back was emitted using correct property
      expect(emittedEffects.any((e) => e is NavigationEffect && e.isBack == true), isTrue);
    });

    test('Initial state should be empty', () {
      final state = viewModel.state;
      expect(state.email, isEmpty);
      expect(state.emailError, isNull);
    });
  });
}
