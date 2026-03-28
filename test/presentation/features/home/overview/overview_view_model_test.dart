import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Initialize test binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OverviewViewModel Tests', () {
    late ProviderContainer container;
    late OverviewViewModel viewModel;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      // 2. Mock SharedPreferences for SpUtil
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      // 3. Create a ProviderContainer for testing
      container = ProviderContainer();
      viewModel = container.read(overviewViewModelProvider.notifier);

      // 4. Record effects
      emittedEffects.clear();
      viewModel.onBindEffect((effect) {
        emittedEffects.add(effect);
      });
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be empty and not loaded', () {
      final state = container.read(overviewViewModelProvider);
      expect(state.isInitialLoaded, isFalse);
      expect(state.featuredProjects, isEmpty);
      expect(state.aboutMe, isNull);
    });

    test('Should handle refresh intent and emit LoadingEffect', () async {
      // When - Trigger refresh
      // Note: Since real UseCases are used, this will attempt network/local calls.
      // In a real MVI test, we would override useCaseProviders with Mocks.
      await viewModel.handleIntent(const OverviewIntent.refresh());

      // Then - Verify loading effect was emitted
      final hasLoading = emittedEffects.any((e) => e is LoadingEffect && e.show == true);
      expect(hasLoading, isTrue);
    });

    test('Should respect onVisible lifecycle', () {
      // Given - Not loaded
      expect(viewModel.state.isInitialLoaded, isFalse);

      // When - Component becomes visible
      viewModel.onVisible();

      // Then - Should have triggered a refresh (checked via loading effect)
      expect(emittedEffects.any((e) => e is LoadingEffect), isTrue);
    });
  });
}
