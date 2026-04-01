import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Initialize test binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChangePasswordViewModel Tests', () {
    late ProviderContainer container;
    late ChangePasswordViewModel viewModel;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      // 2. Mock SharedPreferences for SpUtil
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      // 3. Setup container and VM
      container = ProviderContainer();
      viewModel = container.read(changePasswordViewModelProvider.notifier);

      // 4. Record emitted effects
      emittedEffects.clear();
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));
    });

    tearDown(() => container.dispose());

    test('Initial state should have empty passwords', () {
      final state = viewModel.state;
      expect(state.oldPassword, isEmpty);
      expect(state.newPassword, isEmpty);
      expect(state.confirmPassword, isEmpty);
    });

    test('Should update password fields via intents', () async {
      // When - Update password fields via intents
      await viewModel.handleIntent(const ChangePasswordIntent.oldPasswordChanged('old123'));
      await viewModel.handleIntent(const ChangePasswordIntent.newPasswordChanged('new123'));
      await viewModel.handleIntent(const ChangePasswordIntent.confirmPasswordChanged('new123'));

      // Then - State should be updated correctly
      expect(viewModel.state.oldPassword, 'old123');
      expect(viewModel.state.newPassword, 'new123');
      expect(viewModel.state.confirmPassword, 'new123');
    });

    test('Should show error when passwords do not match on submit', () async {
      // Given - Passwords that do not match
      await viewModel.handleIntent(const ChangePasswordIntent.oldPasswordChanged('old123'));
      await viewModel.handleIntent(const ChangePasswordIntent.newPasswordChanged('new123'));
      await viewModel.handleIntent(const ChangePasswordIntent.confirmPasswordChanged('different123'));

      // When - Submit change intent
      await viewModel.handleIntent(const ChangePasswordIntent.submitChange());

      // Then - confirmPasswordError should be set
      expect(viewModel.state.confirmPasswordError, isNotNull);
    });

    test('Should show error for empty old password on submit', () async {
      // When - Submit without old password
      await viewModel.handleIntent(const ChangePasswordIntent.submitChange());

      // Then - oldPasswordError should be set
      expect(viewModel.state.oldPasswordError, isNotNull);
    });

    test('Should show error for short new password', () async {
      // Given - New password less than 6 chars
      await viewModel.handleIntent(const ChangePasswordIntent.newPasswordChanged('123'));

      // When - Submit
      await viewModel.handleIntent(const ChangePasswordIntent.submitChange());

      // Then - newPasswordError should be set
      expect(viewModel.state.newPasswordError, isNotNull);
    });
  });
}
