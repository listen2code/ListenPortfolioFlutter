import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Initialize test binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeleteAccountViewModel Tests', () {
    late ProviderContainer container;
    late DeleteAccountViewModel viewModel;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      // 2. Mock SharedPreferences initial values for SpUtil initialization
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      // 3. Create a ProviderContainer for testing
      container = ProviderContainer();
      viewModel = container.read(deleteAccountViewModelProvider.notifier);

      // 4. Record all emitted effects for verification
      emittedEffects.clear();
      viewModel.onBindEffect((effect) {
        emittedEffects.add(effect);
      });
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should have isConfirmed as false', () {
      final state = container.read(deleteAccountViewModelProvider);
      expect(state.isConfirmed, isFalse);
    });

    test('Should toggle isConfirmed state when toggleConfirm intent is handled', () async {
      // When - Trigger toggleConfirm intent
      await viewModel.handleIntent(const DeleteAccountIntent.toggleConfirm());

      // Then - State should be toggled to true
      expect(viewModel.state.isConfirmed, isTrue);

      // When - Toggle again
      await viewModel.handleIntent(const DeleteAccountIntent.toggleConfirm());

      // Then - State should be toggled back to false
      expect(viewModel.state.isConfirmed, isFalse);
    });

    test('Should not proceed with deletion request if isConfirmed is false', () async {
      // Given - State is confirmed: false (initial)
      expect(viewModel.state.isConfirmed, isFalse);

      // When - Attempt to delete account
      await viewModel.handleIntent(const DeleteAccountIntent.deleteAccount());

      // Then - No effects (like LoadingEffect) should be emitted because it returns early
      expect(emittedEffects.whereType<LoadingEffect>(), isEmpty);
    });

    test('Should handle deleteAccount intent without crashing when confirmed', () async {
      // Given - State is confirmed: true
      await viewModel.handleIntent(const DeleteAccountIntent.toggleConfirm());

      // When - Trigger deleteAccount (CommonDialog.showConfirm returns null in test context)
      await viewModel.handleIntent(const DeleteAccountIntent.deleteAccount());

      // Then - ViewModel handles the cancellation/null result gracefully
      expect(viewModel.state.isConfirmed, isTrue);
    });
  });
}
