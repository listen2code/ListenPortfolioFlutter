import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ArchitectureViewModel Tests', () {
    late ProviderContainer container;
    late ArchitectureViewModel viewModel;
    late ProviderSubscription<ArchitectureState> subscription;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      container = ProviderContainer();
      // Keep provider alive during async delays by holding a subscription
      subscription = container.listen(architectureViewModelProvider, (_, __) {}, fireImmediately: false);
      viewModel = container.read(architectureViewModelProvider.notifier);
      emittedEffects.clear();
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));
    });

    tearDown(() {
      subscription.close();
      container.dispose();
    });

    group('Initial State', () {
      test('should have correct default initial state', () {
        final state = container.read(architectureViewModelProvider);
        expect(state.isInitialLoaded, isFalse);
        expect(state.sections, isEmpty);
        expect(state.header, isNull);
      });
    });

    group('Refresh Intent', () {
      test('should populate sections and set isInitialLoaded after refresh', () async {
        // Act — architecture ViewModel has an 800ms internal delay
        await viewModel.handleIntent(const ArchitectureIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(architectureViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.sections, isNotEmpty);
        expect(state.header, isNotNull);
      });

      test('should emit LoadingEffect(true) then LoadingEffect(false) during refresh', () async {
        // Act
        await viewModel.handleIntent(const ArchitectureIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
        expect(loadingEffects.length, greaterThanOrEqualTo(2));
        expect(loadingEffects.first.show, isTrue);
        expect(loadingEffects.last.show, isFalse);
      });

      test('onVisible should trigger refresh when not initially loaded', () async {
        // Arrange
        expect(container.read(architectureViewModelProvider).isInitialLoaded, isFalse);

        // Act — onVisible fires handleIntent internally (fire-and-forget)
        viewModel.onVisible();
        // Wait longer than the 800ms internal delay
        await Future.delayed(const Duration(milliseconds: 1100));

        // Assert
        final state = container.read(architectureViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.sections, isNotEmpty);
      });

      test('onVisible should NOT re-trigger refresh when already loaded', () async {
        // Arrange — load once
        await viewModel.handleIntent(const ArchitectureIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 100));

        final sectionsAfterFirstLoad = container.read(architectureViewModelProvider).sections.length;
        emittedEffects.clear();

        // Act
        viewModel.onVisible();
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert — no new loading effects emitted
        expect(emittedEffects.whereType<LoadingEffect>().toList(), isEmpty);
        expect(container.read(architectureViewModelProvider).sections.length, sectionsAfterFirstLoad);
      });

      test('should produce at least 4 architecture sections', () async {
        // Act
        await viewModel.handleIntent(const ArchitectureIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(architectureViewModelProvider);
        expect(state.sections.length, greaterThanOrEqualTo(4));
      });
    });
  });
}
