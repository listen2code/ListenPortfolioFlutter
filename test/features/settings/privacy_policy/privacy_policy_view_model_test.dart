import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/privacy_policy/privacy_policy_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/privacy_policy/privacy_policy_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/privacy_policy/privacy_policy_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrivacyPolicyViewModel Tests', () {
    late ProviderContainer container;
    late PrivacyPolicyViewModel viewModel;
    late ProviderSubscription<PrivacyPolicyState> subscription;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      container = ProviderContainer();
      subscription = container.listen(privacyPolicyViewModelProvider, (_, __) {}, fireImmediately: false);
      viewModel = container.read(privacyPolicyViewModelProvider.notifier);
    });

    tearDown(() async {
      // Wait for any pending async operations before disposing
      await Future.delayed(Duration(milliseconds: 100));
      subscription.close();
      container.dispose();
    });

    group('Initial State', () {
      test('should start with empty sections and empty lastUpdated', () {
        final state = container.read(privacyPolicyViewModelProvider);
        expect(state.sections, isEmpty);
        expect(state.lastUpdated, isEmpty);
      });
    });

    group('Refresh Intent', () {
      test('should populate sections after refresh', () async {
        // Act
        await viewModel.handleIntent(const PrivacyPolicyIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(privacyPolicyViewModelProvider);
        expect(state.sections, isNotEmpty);
      });

      test('should set lastUpdated after refresh', () async {
        // Act
        await viewModel.handleIntent(const PrivacyPolicyIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(privacyPolicyViewModelProvider);
        expect(state.lastUpdated, isNotEmpty);
      });

      test('should populate at least 5 privacy sections', () async {
        // Act
        await viewModel.handleIntent(const PrivacyPolicyIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert — ViewModel defines 6 sections
        final state = container.read(privacyPolicyViewModelProvider);
        expect(state.sections.length, greaterThanOrEqualTo(5));
      });

      test('each section should have non-empty title and content', () async {
        // Act
        await viewModel.handleIntent(const PrivacyPolicyIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(privacyPolicyViewModelProvider);
        for (final section in state.sections) {
          expect(section.title, isNotEmpty);
          expect(section.content, isNotEmpty);
        }
      });
    });

    group('onReady Lifecycle', () {
      test('onReady should trigger refresh when sections are empty', () async {
        // Arrange — initial state has empty sections
        expect(container.read(privacyPolicyViewModelProvider).sections, isEmpty);

        // Act
        viewModel.onReady();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(privacyPolicyViewModelProvider);
        expect(state.sections, isNotEmpty);
      });
    });
  });
}
