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
      capturedEffects.clear();
      MviPlaybackObserver.onEffectEmitted = (tag, effect) {
        if (effect is ReferralWelcomeEffect) {
          capturedEffects.add(effect);
        }
      };
    });

    tearDown(() async {
      MviPlaybackObserver.onEffectEmitted = null;
      await Future.delayed(const Duration(milliseconds: 50));
      container.dispose();
    });

    test('should emit ReferralWelcomeEffect when valid referral exists on first launch', () async {
      mockReferrerService.mockData = InstallReferrerData.fromRawReferrer('refer=ListenVIP&target=projects');
      mockReferrerService.processed = false;

      container = ProviderContainer(
        overrides: [
          installReferrerServiceProvider.overrideWithValue(mockReferrerService),
        ],
      );

      final viewModel = container.read(homeViewModelProvider.notifier);
      await viewModel.handleIntent(const HomeIntent.checkDeferredDeepLink());

      expect(mockReferrerService.processed, isTrue);
      expect(mockReferrerService.savedData?.refer, 'ListenVIP');
      expect(capturedEffects.length, 1);

      final effect = capturedEffects.first;
      expect(effect.data.refer, 'ListenVIP');
      expect(effect.data.targetRoute, 'projects');

      // Test onConfirm tab switch
      effect.onConfirm?.call();
      expect(container.read(homeViewModelProvider).currentTab, HomeTab.projects);
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

      expect(mockReferrerService.processed, isTrue);
      expect(capturedEffects, isEmpty);
    });
  });
}
