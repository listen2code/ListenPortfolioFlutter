import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

import '../../test_helpers/test_setup.dart';

class MockInstallReferrerService implements IInstallReferrerService {
  bool processed = false;
  InstallReferrerData mockData = InstallReferrerData.empty;
  InstallReferrerData? savedData;

  @override
  Future<InstallReferrerData> fetchInstallReferrer() async => mockData;

  @override
  Future<bool> hasProcessedReferrer() async => processed;

  @override
  Future<void> markReferrerProcessed() async {
    processed = true;
  }

  @override
  Future<void> resetReferrerProcessed() async {
    processed = false;
  }

  @override
  Future<void> saveReferrerData(InstallReferrerData data) async {
    savedData = data;
  }

  @override
  Future<InstallReferrerData?> getSavedReferrerData() async => savedData;

  @override
  Future<InstallReferrerData> simulateReferrer(String mockReferrer) async {
    mockData = InstallReferrerData.fromRawReferrer(mockReferrer);
    savedData = mockData;
    return mockData;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeViewModel Deferred Deep Link Tests', () {
    late ProviderContainer container;
    late MockInstallReferrerService mockReferrerService;
    final List<ReferralWelcomeEffect> capturedEffects = [];

    setUpAll(() async {
      await setupTestEnvironment();
    });

    setUp(() {
      mockReferrerService = MockInstallReferrerService();
      InstallReferrerServiceImpl.mockInstance = mockReferrerService;
      capturedEffects.clear();
      MviPlaybackObserver.onEffectEmitted = (tag, effect) {
        if (effect is ReferralWelcomeEffect) {
          capturedEffects.add(effect);
        }
      };
    });

    tearDown(() async {
      InstallReferrerServiceImpl.mockInstance = null;
      MviPlaybackObserver.onEffectEmitted = null;
      await Future.delayed(const Duration(milliseconds: 50));
      container.dispose();
    });

    test('should emit ReferralWelcomeEffect and mark processed when confirmed with doNotShowAgain=true', () async {
      mockReferrerService.mockData = InstallReferrerData.fromRawReferrer('refer=ListenVIP&target=projects');
      mockReferrerService.processed = false;

      container = ProviderContainer(
        overrides: [
          installReferrerServiceProvider.overrideWithValue(mockReferrerService),
        ],
      );
      final subscription = container.listen(homeViewModelProvider, (_, __) {});

      final viewModel = container.read(homeViewModelProvider.notifier);
      await viewModel.handleIntent(const HomeIntent.checkDeferredDeepLink());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(mockReferrerService.savedData?.refer, 'ListenVIP');
      expect(capturedEffects.length, greaterThanOrEqualTo(1));

      final effect = capturedEffects.first;
      expect(effect.data.refer, 'ListenVIP');
      expect(effect.data.targetRoute, 'projects');

      // Test onConfirm with doNotShowAgain = true
      effect.onConfirm?.call(true);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(mockReferrerService.processed, isTrue);
      expect(container.read(homeViewModelProvider).currentTab, HomeTab.projects);

      subscription.close();
    });

    test('should NOT mark processed when confirmed with doNotShowAgain=false', () async {
      mockReferrerService.mockData = InstallReferrerData.fromRawReferrer('refer=ListenVIP&target=projects');
      mockReferrerService.processed = false;

      container = ProviderContainer(
        overrides: [
          installReferrerServiceProvider.overrideWithValue(mockReferrerService),
        ],
      );
      final subscription = container.listen(homeViewModelProvider, (_, __) {});

      final viewModel = container.read(homeViewModelProvider.notifier);
      await viewModel.handleIntent(const HomeIntent.checkDeferredDeepLink());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(capturedEffects.length, greaterThanOrEqualTo(1));
      final effect = capturedEffects.first;

      // Test onConfirm with doNotShowAgain = false
      effect.onConfirm?.call(false);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(mockReferrerService.processed, isFalse);

      subscription.close();
    });

    test('should NOT emit ReferralWelcomeEffect if already processed', () async {
      mockReferrerService.mockData = InstallReferrerData.fromRawReferrer('refer=ListenVIP');
      mockReferrerService.processed = true; // Already processed

      container = ProviderContainer(
        overrides: [
          installReferrerServiceProvider.overrideWithValue(mockReferrerService),
        ],
      );

      final viewModel = container.read(homeViewModelProvider.notifier);
      await viewModel.handleIntent(const HomeIntent.checkDeferredDeepLink());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(capturedEffects, isEmpty);
    });

    test('should NOT emit ReferralWelcomeEffect if referral data is empty', () async {
      mockReferrerService.mockData = InstallReferrerData.empty;
      mockReferrerService.processed = false;

      container = ProviderContainer(
        overrides: [
          installReferrerServiceProvider.overrideWithValue(mockReferrerService),
        ],
      );

      final viewModel = container.read(homeViewModelProvider.notifier);
      await viewModel.handleIntent(const HomeIntent.checkDeferredDeepLink());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(capturedEffects, isEmpty);
    });
  });
}
