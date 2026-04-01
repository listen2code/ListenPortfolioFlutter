import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/terms_of_service/terms_of_service_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/terms_of_service/terms_of_service_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/terms_of_service/terms_of_service_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TermsOfServiceViewModel Tests', () {
    late ProviderContainer container;
    late TermsOfServiceViewModel viewModel;
    late ProviderSubscription<TermsOfServiceState> subscription;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      container = ProviderContainer();
      subscription = container.listen(termsOfServiceViewModelProvider, (_, __) {}, fireImmediately: false);
      viewModel = container.read(termsOfServiceViewModelProvider.notifier);
    });

    tearDown(() {
      subscription.close();
      container.dispose();
    });

    group('Initial State', () {
      test('should start with empty sections and empty lastUpdated', () {
        final state = container.read(termsOfServiceViewModelProvider);
        expect(state.sections, isEmpty);
        expect(state.lastUpdated, isEmpty);
      });
    });

    group('Init Intent', () {
      test('should populate sections after init', () async {
        // Act
        await viewModel.handleIntent(const TermsOfServiceIntent.init());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(termsOfServiceViewModelProvider);
        expect(state.sections, isNotEmpty);
      });

      test('should set lastUpdated after init', () async {
        // Act
        await viewModel.handleIntent(const TermsOfServiceIntent.init());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(termsOfServiceViewModelProvider);
        expect(state.lastUpdated, isNotEmpty);
      });

      test('should populate at least 6 terms sections', () async {
        // Act
        await viewModel.handleIntent(const TermsOfServiceIntent.init());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert — ViewModel defines 7 sections
        final state = container.read(termsOfServiceViewModelProvider);
        expect(state.sections.length, greaterThanOrEqualTo(6));
      });

      test('each section should have non-empty title and content', () async {
        // Act
        await viewModel.handleIntent(const TermsOfServiceIntent.init());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(termsOfServiceViewModelProvider);
        for (final section in state.sections) {
          expect(section.title, isNotEmpty);
          expect(section.content, isNotEmpty);
        }
      });
    });

    group('onReady Lifecycle', () {
      test('onReady should trigger init when sections are empty', () async {
        // Arrange — initial state has empty sections
        expect(container.read(termsOfServiceViewModelProvider).sections, isEmpty);

        // Act
        viewModel.onReady();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(termsOfServiceViewModelProvider);
        expect(state.sections, isNotEmpty);
      });

      test('onReady should NOT re-trigger init when sections are already loaded', () async {
        // Arrange — load once
        await viewModel.handleIntent(const TermsOfServiceIntent.init());
        await Future.delayed(const Duration(milliseconds: 100));

        final countAfterFirstLoad = container.read(termsOfServiceViewModelProvider).sections.length;

        // Act — trigger onReady again
        viewModel.onReady();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert — sections count unchanged
        final state = container.read(termsOfServiceViewModelProvider);
        expect(state.sections.length, countAfterFirstLoad);
      });
    });
  });
}
