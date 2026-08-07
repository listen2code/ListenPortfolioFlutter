import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

import '../../test_helpers/test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeViewModel Tests', () {
    late ProviderContainer container;
    late HomeViewModel viewModel;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      await setupTestEnvironment();
      container = ProviderContainer();
      // 1. Get the ViewModel instance
      viewModel = container.read(homeViewModelProvider.notifier);

      // 2. Listen to effects for verification
      emittedEffects.clear();
      viewModel.onBindEffect((effect) {
        emittedEffects.add(effect);
      });
    });

    tearDown(() async {
      ViewModelMixin.isUserAuthenticated = null;
      ViewModelMixin.triggerLogin = null;
      // Wait for any pending async operations before disposing
      await Future.delayed(Duration(milliseconds: 100));
      container.dispose();
    });

    test('Should have initial state with overview tab', () {
      final state = container.read(homeViewModelProvider);
      expect(state.currentTab, HomeTab.overview);
    });

    test('Should update tab when tab changed intent is handled', () async {
      const newTab = HomeTab.aboutMe;

      // When - Change tab
      await viewModel.handleIntent(const HomeIntent.tabChanged(newTab));

      // Then - State updated, no effects expected for simple tab change
      final state = container.read(homeViewModelProvider);
      expect(state.currentTab, newTab);
      expect(emittedEffects, isEmpty);
    });

    test('Should handle all tab changes correctly in sequence', () async {
      final tabs = [HomeTab.aboutMe, HomeTab.projects, HomeTab.architecture, HomeTab.overview];

      for (final tab in tabs) {
        await viewModel.handleIntent(HomeIntent.tabChanged(tab));
        expect(container.read(homeViewModelProvider).currentTab, tab);
      }
    });

    test('Should emit RateAppEffect when init intent is handled', () async {
      await viewModel.handleIntent(const HomeIntent.init());
      expect(emittedEffects.length, 1);
      expect(emittedEffects.first, isA<RateAppEffect>());
      expect((emittedEffects.first as RateAppEffect).action, RateAppAction.checkAndPrompt);
    });

    test('Should handle lifecycle events without crashing', () {
      // Verify base lifecycle methods from ViewModelMixin
      viewModel.onInit();
      viewModel.onReady();
      viewModel.onVisible();
      viewModel.onInVisible();

      expect(container.read(homeViewModelProvider), isNotNull);
    });

    test('Should handle deep link tab change event fired through EventBus', () async {
      // Keep provider alive by listening to it
      final sub = container.listen(homeViewModelProvider, (_, __) {});

      // Given
      viewModel.onReady(); // Subscribes to events

      // When - Fire a sticky tab change deep link
      final testUri = Routes.makeHomeTabDeepLink(HomeTab.aboutMe.name);
      EventBus().fire(CommonEvent<Uri>(
        DeepLinkManager.deepLinkEventKey,
        data: testUri,
        sticky: true,
        autoClear: true,
      ));

      // Allow event stream to process
      await Future<void>.delayed(Duration.zero);

      // Then - Tab should update to aboutMe
      expect(container.read(homeViewModelProvider).currentTab, HomeTab.aboutMe);
      sub.close();
    });

    test('Should intercept tabChanged(aboutMe) when not authenticated, and resume on success', () async {
      // Given - Not authenticated
      bool isAuthenticated = false;
      ViewModelMixin.isUserAuthenticated = () => isAuthenticated;

      bool triggerLoginCalled = false;
      void Function()? loginSuccessCallback;

      ViewModelMixin.triggerLogin = ({required onSuccess, onFail}) {
        triggerLoginCalled = true;
        loginSuccessCallback = onSuccess;
      };

      // When - Change tab to aboutMe
      await viewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.aboutMe));

      // Then - Should be intercepted, triggerLogin called, and state unchanged (still overview)
      expect(triggerLoginCalled, isTrue);
      expect(container.read(homeViewModelProvider).currentTab, HomeTab.overview);
      expect(loginSuccessCallback, isNotNull);

      // And When - Login succeeds
      isAuthenticated = true;
      loginSuccessCallback!();

      // Then - Intent resumes, tab updates to aboutMe
      expect(container.read(homeViewModelProvider).currentTab, HomeTab.aboutMe);
    });
  });
}
