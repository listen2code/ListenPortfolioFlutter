import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_view_model.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/repositories/settings_repository.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/provider/settings_provider.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/version_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import '../../../test_helpers/test_setup.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}
class MockNotificationService extends Mock implements INotificationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsViewModel Tests', () {
    late ProviderContainer container;
    late SettingsViewModel viewModel;
    late ProviderSubscription<SettingsState> subscription;
    late MockSettingsRepository mockSettingsRepository;
    late MockNotificationService mockNotificationService;
    late INotificationService originalNotificationService;
    final List<BaseEffect> emittedEffects = [];

    setUpAll(() {
      originalNotificationService = notificationService;
    });

    tearDownAll(() {
      notificationService = originalNotificationService;
    });

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');
      await setupTestEnvironment();

      mockSettingsRepository = MockSettingsRepository();
      mockNotificationService = MockNotificationService();

      // Stub default notification service behaviors
      when(() => mockNotificationService.requestPermission()).thenAnswer((_) async => true);
      when(() => mockNotificationService.subscribeToTopic(any())).thenAnswer((_) async {});
      when(() => mockNotificationService.unsubscribeFromTopic(any())).thenAnswer((_) async {});

      notificationService = mockNotificationService;

      container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(mockSettingsRepository),
        ],
      );
      subscription = container.listen(settingsViewModelProvider, (_, __) {}, fireImmediately: false);
      viewModel = container.read(settingsViewModelProvider.notifier);
      emittedEffects.clear();
      viewModel.onBindEffect((BaseEffect effect) => emittedEffects.add(effect));
    });

    tearDown(() async {
      // Wait for any pending async operations before disposing
      await Future.delayed(Duration(milliseconds: 100));
      subscription.close();
      container.dispose();
    });

    group('Initial State', () {
      test('should build with default cacheSize', () {
        final state = container.read(settingsViewModelProvider);
        expect(state.cacheSize, isNotNull);
        expect(state.cacheSize, isA<String>());
      });

      test('should default notificationsEnabled to true', () {
        final state = container.read(settingsViewModelProvider);
        expect(state.notificationsEnabled, isTrue);
      });

      test('should default isLogOverlayShowing to false', () {
        final state = container.read(settingsViewModelProvider);
        expect(state.isLogOverlayShowing, isFalse);
      });
    });

    group('Toggle Notifications Intent', () {
      test('should set notificationsEnabled to false when toggled off', () async {
        // Act
        viewModel.handleIntent(const SettingsIntent.toggleNotifications(false));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(container.read(settingsViewModelProvider).notificationsEnabled, isFalse);
      });

      test('should set notificationsEnabled to true when toggled on', () async {
        // Arrange — disable first
        viewModel.handleIntent(const SettingsIntent.toggleNotifications(false));
        await Future.delayed(const Duration(milliseconds: 100));

        // Act — re-enable
        viewModel.handleIntent(const SettingsIntent.toggleNotifications(true));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(container.read(settingsViewModelProvider).notificationsEnabled, isTrue);
      });
    });

    group('Switch Language Intent', () {
      test('should update currentLanguage to English', () async {
        // Act
        await viewModel.handleIntent(const SettingsIntent.switchLanguage(AppLanguage.english));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(container.read(settingsViewModelProvider).currentLanguage, AppLanguage.english);
      });

      test('should update currentLanguage to Chinese', () async {
        // Arrange — first switch to English
        await viewModel.handleIntent(const SettingsIntent.switchLanguage(AppLanguage.english));
        await Future.delayed(const Duration(milliseconds: 100));

        // Act — switch back to Chinese
        await viewModel.handleIntent(const SettingsIntent.switchLanguage(AppLanguage.chinese));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(container.read(settingsViewModelProvider).currentLanguage, AppLanguage.chinese);
      });
    });

    group('Toggle Log Overlay Intent', () {
      test('should enable log overlay', () async {
        // Act
        viewModel.handleIntent(const SettingsIntent.toggleLogOverlay(true));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(container.read(settingsViewModelProvider).isLogOverlayShowing, isTrue);
      });

      test('should disable log overlay', () async {
        // Arrange — enable first
        viewModel.handleIntent(const SettingsIntent.toggleLogOverlay(true));
        await Future.delayed(const Duration(milliseconds: 100));

        // Act — disable
        viewModel.handleIntent(const SettingsIntent.toggleLogOverlay(false));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(container.read(settingsViewModelProvider).isLogOverlayShowing, isFalse);
      });

      test('should sync state when LogOverlayManager.isShowingNotifier value changes', () async {
        // Arrange
        viewModel.onInit();
        LogOverlayManager.isShowingNotifier.value = false;
        await Future.delayed(const Duration(milliseconds: 50));

        // Act: simulate opening overlay
        LogOverlayManager.isShowingNotifier.value = true;
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(container.read(settingsViewModelProvider).isLogOverlayShowing, isTrue);

        // Act: simulate closing overlay
        LogOverlayManager.isShowingNotifier.value = false;
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(container.read(settingsViewModelProvider).isLogOverlayShowing, isFalse);
      });
    });

    group('Clear Cache Intent', () {
      test('should emit LoadingEffect(true) then LoadingEffect(false)', () async {
        // Act
        await viewModel.handleIntent(const SettingsIntent.clearCache());
        
        // Wait for async operations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
        expect(loadingEffects.length, greaterThanOrEqualTo(2));
        expect(loadingEffects.first.show, isTrue);
        expect(loadingEffects.last.show, isFalse);
      });

      test('should emit a MessageEffect after clearing cache', () async {
        // Act
        await viewModel.handleIntent(const SettingsIntent.clearCache());
        
        // Wait for async operations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
        expect(messageEffects, isNotEmpty);
        expect(messageEffects.last.message, I18nKeys.cacheCleared.tr);
      });
    });

    group('Reset Settings Intent', () {
      test('should emit ConfirmEffect first, and emit LoadingEffect(true)/LoadingEffect(false) on confirmation', () async {
        // Act
        viewModel.handleIntent(const SettingsIntent.resetSettings());
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
        final confirmEffect = confirmEffects.last;
        expect(confirmEffect.title, I18nKeys.resetConfirmTitle.tr);

        // Simulate confirmation (result: true)
        confirmEffect.onResult(true);
        await Future.delayed(const Duration(milliseconds: 100));

        final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
        expect(loadingEffects.length, greaterThanOrEqualTo(2));
        expect(loadingEffects.first.show, isTrue);
        expect(loadingEffects.last.show, isFalse);
      });

      test('should emit a MessageEffect after resetting settings is confirmed', () async {
        // Act
        viewModel.handleIntent(const SettingsIntent.resetSettings());
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
        confirmEffects.last.onResult(true);
        await Future.delayed(const Duration(milliseconds: 100));

        final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
        expect(messageEffects, isNotEmpty);
        expect(messageEffects.last.message, I18nKeys.settingsResetSuccess.tr);
      });

      test('should NOT reset settings or emit loading/success message when cancelled', () async {
        // Act
        viewModel.handleIntent(const SettingsIntent.resetSettings());
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
        confirmEffects.last.onResult(false);
        await Future.delayed(const Duration(milliseconds: 100));

        final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
        expect(loadingEffects, isEmpty);
        final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
        expect(messageEffects, isEmpty);
      });
    });

    group('Switch Env Intent', () {
      test('should update currentEnv and verify AppEnv changes', () async {
        // Act
        await viewModel.handleIntent(const SettingsIntent.switchEnv(AppEnvironment.test));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(container.read(settingsViewModelProvider).currentEnv, AppEnvironment.test);
        expect(AppEnv.currentEnv, AppEnvironment.test);

        // Switch back to mock environment
        await viewModel.handleIntent(const SettingsIntent.switchEnv(AppEnvironment.mock));
        await Future.delayed(const Duration(milliseconds: 100));
        expect(container.read(settingsViewModelProvider).currentEnv, AppEnvironment.mock);
        expect(AppEnv.currentEnv, AppEnvironment.mock);
      });
    });

    group('Show Env Dialog Intent', () {
      test('should emit SwitchDialogEffect with environments', () async {
        // Act
        viewModel.handleIntent(const SettingsIntent.showEnvDialog());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final switchDialogEffects = emittedEffects.whereType<SwitchDialogEffect>().toList();
        expect(switchDialogEffects, isNotEmpty);
        final effect = switchDialogEffects.last;
        expect(effect.title, I18nKeys.switchEnv.tr);
        expect(effect.options.length, EnvConfigs.values.length);
        
        // Test onChanged callback triggers switchEnv intent
        final firstOption = effect.options.first;
        effect.onChanged(firstOption.value);
        await Future.delayed(const Duration(milliseconds: 100));
        
        expect(container.read(settingsViewModelProvider).currentEnv, firstOption.value);
      });
    });

    group('Show Language Dialog Intent', () {
      test('should emit SwitchDialogEffect with languages', () async {
        // Act
        viewModel.handleIntent(const SettingsIntent.showLanguageDialog());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final switchDialogEffects = emittedEffects.whereType<SwitchDialogEffect>().toList();
        expect(switchDialogEffects, isNotEmpty);
        final effect = switchDialogEffects.last;
        expect(effect.title, I18nKeys.selectLanguage.tr);
        expect(effect.options.length, AppLanguage.values.length);
        
        // Test onChanged callback triggers switchLanguage intent
        final langOption = effect.options.firstWhere((opt) => opt.value == AppLanguage.english);
        effect.onChanged(langOption.value);
        await Future.delayed(const Duration(milliseconds: 100));
        
        expect(container.read(settingsViewModelProvider).currentLanguage, AppLanguage.english);
      });
    });

    group('Check Updates Intent', () {
      setUp(() {
        Core.packageInfo = DummyPackageInfo('1.0.0');
      });

      test('should emit LoadingEffect(true) then LoadingEffect(false)', () async {
        // Arrange
        when(() => mockSettingsRepository.getLatestVersion()).thenAnswer(
          (_) async => const Right(
            VersionModel(
              version: '1.1.0',
              buildNumber: 2,
              url: 'https://example.com',
              changelog: {'en': 'Test update'},
            ),
          ),
        );

        // Act
        await viewModel.handleIntent(const SettingsIntent.checkUpdates());

        // Wait for async operations to complete
        await Future.delayed(const Duration(milliseconds: 150));

        // Assert
        final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
        expect(loadingEffects.length, greaterThanOrEqualTo(2));
        expect(loadingEffects.first.show, isTrue);
        expect(loadingEffects.first.message, I18nKeys.checkingUpdates.tr);
        expect(loadingEffects.last.show, isFalse);
      });
    });

    group('Share App Intent', () {
      test('should emit ShareEffect with app github link', () async {
        // Act
        await viewModel.handleIntent(const SettingsIntent.shareApp());

        // Assert
        final shareEffects = emittedEffects.whereType<ShareEffect>().toList();
        expect(shareEffects, isNotEmpty);
        final effect = shareEffects.last;
        expect(effect.files, isEmpty);
        expect(effect.text, contains(AppConstants.github));
      });
    });

    group('onInit and argCheckUpdate', () {
      setUp(() {
        try {
          Core.packageInfo = DummyPackageInfo('1.0.0');
        } catch (_) {}
      });

      tearDown(() {
        AppNav.currentArgs = null;
      });

      test('should NOT trigger checkUpdates when argCheckUpdate is not present or false', () async {
        // Arrange
        AppNav.currentArgs = null;

        // Act
        viewModel.onInit();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert: settingsRepository.getLatestVersion shouldn't be called
        verifyNever(() => mockSettingsRepository.getLatestVersion());
      });

      test('should trigger checkUpdates when argCheckUpdate is true', () async {
        // Arrange
        AppNav.currentArgs = {Routes.argCheckUpdate: true};
        when(() => mockSettingsRepository.getLatestVersion()).thenAnswer(
          (_) async => const Right(
            VersionModel(
              version: '1.1.0',
              buildNumber: 2,
              url: 'https://example.com',
              changelog: {'en': 'Test update'},
            ),
          ),
        );

        // Act
        viewModel.onInit();
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert: settingsRepository.getLatestVersion should be called
        verify(() => mockSettingsRepository.getLatestVersion()).called(1);
      });
    });
  });
}

class DummyPackageInfo implements IPackageInfo {
  final String _version;
  DummyPackageInfo([this._version = '1.0.0']);

  @override
  String get appName => 'dummy_app';

  @override
  String get packageName => 'com.dummy.app';

  @override
  String get version => _version;

  @override
  String get buildNumber => '1';

  @override
  String get fullVersion => '$_version+1';

  @override
  Map<String, String> toHeaderMap() => {};
}
