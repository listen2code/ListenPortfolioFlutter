import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_intent.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_state.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashViewModel Tests', () {
    late ProviderContainer container;
    late SplashViewModel viewModel;
    late ProviderSubscription<SplashState> subscription;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      container = ProviderContainer();
      // Keep provider alive during the 2s artificial delay
      subscription = container.listen(splashViewModelProvider, (_, __) {}, fireImmediately: false);
      viewModel = container.read(splashViewModelProvider.notifier);
      emittedEffects.clear();
      viewModel.onBindEffect((BaseEffect effect) => emittedEffects.add(effect));
    });

    tearDown(() {
      subscription.close();
      container.dispose();
    });

    group('Initial State', () {
      test('should build with default SplashState', () {
        // SplashState has no fields, so just verifying it can be read
        final state = container.read(splashViewModelProvider);
        expect(state, isA<SplashState>());
      });
    });

    group('Init Intent', () {
      test('should emit NavigationEffect to home after init delay', () async {
        // Act — await handleIntent which internally waits for the 2s delay
        await viewModel.handleIntent(const SplashIntent.init());
        // StreamController.broadcast() delivers events asynchronously; yield to event loop
        await Future.delayed(Duration.zero);

        // Assert — NavigationEffect must have been emitted after the delay
        final navEffects = emittedEffects.whereType<NavigationEffect>().toList();
        expect(navEffects, isNotEmpty);
        expect(navEffects.last.target, equals(Routes.home));
        expect(navEffects.last.isReplace, isTrue);
      });

      test('init intent should replace current route (not push)', () async {
        // Act
        await viewModel.handleIntent(const SplashIntent.init());
        await Future.delayed(Duration.zero);

        // Assert — isReplace must be true so the splash screen is removed from stack
        final navEffects = emittedEffects.whereType<NavigationEffect>().toList();
        expect(navEffects, isNotEmpty);
        expect(navEffects.last.isReplace, isTrue);
      });

      test('init intent should navigate to Routes.home specifically', () async {
        // Act
        await viewModel.handleIntent(const SplashIntent.init());
        await Future.delayed(Duration.zero);

        // Assert
        final navEffects = emittedEffects.whereType<NavigationEffect>().toList();
        expect(navEffects, isNotEmpty);
        expect(navEffects.last.target, equals(Routes.home));
      });
    });
  });
}
