import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_view_model.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/repositories/settings_repository.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/provider/settings_provider.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/version_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
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
      await AppEnv.setEnvironment(AppEnvironment.mock);

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
      // (e.g., checkUpdates use case execution, notification service calls)
      await Future.delayed(Duration(milliseconds: 300));
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
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
        final confirmEffect = confirmEffects.last;
        expect(confirmEffect.title, I18nKeys.resetConfirmTitle.tr);

        // Simulate confirmation (result: true)
        await (confirmEffect.onResult as dynamic)(true);
        await Future.delayed(const Duration(milliseconds: 300));

        final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
        expect(loadingEffects.length, greaterThanOrEqualTo(2));
        expect(loadingEffects.first.show, isTrue);
        expect(loadingEffects.last.show, isFalse);
      });

      test('should emit a MessageEffect after resetting settings is confirmed', () async {
        // Act
        viewModel.handleIntent(const SettingsIntent.resetSettings());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
        await (confirmEffects.last.onResult as dynamic)(true);
        await Future.delayed(const Duration(milliseconds: 300));

        final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
        expect(messageEffects, isNotEmpty);
        expect(messageEffects.last.message, I18nKeys.settingsResetSuccess.tr);
      });

      test('should NOT reset settings or emit loading/success message when cancelled', () async {
        // Act
        viewModel.handleIntent(const SettingsIntent.resetSettings());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
        await (confirmEffects.last.onResult as dynamic)(false);
        await Future.delayed(const Duration(milliseconds: 300));

        final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
        expect(loadingEffects, isEmpty);
        final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
        expect(messageEffects, isEmpty);
      });
    });

    group('Switch Env Intent', () {
      test('should prompt with confirm dialog when logged in, switch env and logout on confirmation, but stay on settings screen', () async {
        // Arrange - mock login state
        authManager.login(const UserModel(id: 'test_user', email: 'test@email.com'));
        expect(authManager.state.isGuest, isFalse);

        // Act - try to switch to dev
        viewModel.handleIntent(const SettingsIntent.switchEnv(AppEnvironment.dev));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - should NOT have switched yet because we haven't confirmed
        expect(container.read(settingsViewModelProvider).currentEnv, AppEnvironment.mock);
        expect(authManager.state.isGuest, isFalse);

        // Assert - a ConfirmEffect was emitted
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
        final confirmEffect = confirmEffects.last;
        expect(confirmEffect.title, I18nKeys.switchEnv.tr);
        expect(confirmEffect.message, I18nKeys.switchEnvLogoutPrompt.tr);

        // Act - confirm the dialog
        confirmEffect.onResult(true);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - switch environment and logout successfully
        expect(container.read(settingsViewModelProvider).currentEnv, AppEnvironment.dev);
        expect(AppEnv.currentEnv, AppEnvironment.dev);
        expect(authManager.state.isGuest, isTrue); // Logged out!

        // Assert - success MessageEffect was emitted
        final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
        expect(messageEffects, isNotEmpty);
        final lastMsg = messageEffects.last;
        expect(lastMsg.message, I18nKeys.switchEnvLogoutSuccessTips.trArgs([I18nKeys.envDev.tr]));

        // Assert - no home navigation was emitted
        final navEffects = emittedEffects.whereType<NavigationEffect<void>>().toList();
        expect(navEffects.where((e) => e.target == Routes.home), isEmpty);
      });

      test('should not switch env, not logout, and emit back effect when confirmation is cancelled', () async {
        // Arrange - mock login state
        authManager.login(const UserModel(id: 'test_user', email: 'test@email.com'));
        expect(authManager.state.isGuest, isFalse);

        // Act - try to switch to dev
        viewModel.handleIntent(const SettingsIntent.switchEnv(AppEnvironment.dev));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - ConfirmEffect emitted
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
        final confirmEffect = confirmEffects.last;

        // Act - cancel/dismiss confirm dialog
        confirmEffect.onResult(false);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - did NOT switch env or logout
        expect(container.read(settingsViewModelProvider).currentEnv, AppEnvironment.mock);
        expect(AppEnv.currentEnv, AppEnvironment.mock);
        expect(authManager.state.isGuest, isFalse);

        // Assert - emitted back navigation effect to revert UI Dialog check state
        final navEffects = emittedEffects.whereType<NavigationEffect<void>>().toList();
        expect(navEffects, isNotEmpty);
        final lastNav = navEffects.last;
        expect(lastNav.isBack, isTrue);
      });

      test('should switch env directly without dialog when not logged in (guest)', () async {
        // Arrange - ensure guest state
        authManager.logout();
        expect(authManager.state.isGuest, isTrue);

        // Act - switch from mock (current) to dev
        await viewModel.handleIntent(const SettingsIntent.switchEnv(AppEnvironment.dev));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - switched directly
        expect(container.read(settingsViewModelProvider).currentEnv, AppEnvironment.dev);
        expect(AppEnv.currentEnv, AppEnvironment.dev);
        expect(emittedEffects.whereType<ConfirmEffect>(), isEmpty);
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
        try {
          Core.packageInfo = DummyPackageInfo('1.0.0');
        } catch (_) {
          DummyPackageInfo('1.0.0');
        }
      });

      test('should emit LoadingEffect(true) then LoadingEffect(false)', () async {
        // Arrange
        DummyPackageInfo('1.0.0', '1');
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

      test('should emit ConfirmEffect when remote version is newer (e.g. 1.0.98 to 1.1.0)', () async {
        // Arrange
        DummyPackageInfo('1.0.98', '1');
        when(() => mockSettingsRepository.getLatestVersion()).thenAnswer(
          (_) async => const Right(
            VersionModel(
              version: '1.1.0',
              buildNumber: 1,
              url: 'https://example.com',
              changelog: {'en': 'New features'},
            ),
          ),
        );

        // Act
        await viewModel.handleIntent(const SettingsIntent.checkUpdates());
        await Future.delayed(const Duration(milliseconds: 150));

        // Assert
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
        expect(confirmEffects.last.title, I18nKeys.checkUpdates.tr);
      });

      test('should emit ConfirmEffect when remote build number is newer (e.g. 1.1.0+2 vs 1.1.0+1)', () async {
        // Arrange
        DummyPackageInfo('1.1.0', '1');
        when(() => mockSettingsRepository.getLatestVersion()).thenAnswer(
          (_) async => const Right(
            VersionModel(
              version: '1.1.0',
              buildNumber: 2,
              url: 'https://example.com',
              changelog: {'en': 'Bug fixes'},
            ),
          ),
        );

        // Act
        await viewModel.handleIntent(const SettingsIntent.checkUpdates());
        await Future.delayed(const Duration(milliseconds: 150));

        // Assert
        final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
        expect(confirmEffects, isNotEmpty);
      });

      test('should emit MessageEffect (latest version) when remote version is older', () async {
        // Arrange
        DummyPackageInfo('1.1.0', '2');
        when(() => mockSettingsRepository.getLatestVersion()).thenAnswer(
          (_) async => const Right(
            VersionModel(
              version: '1.0.98',
              buildNumber: 1,
              url: 'https://example.com',
              changelog: {'en': 'Old release'},
            ),
          ),
        );

        // Act
        await viewModel.handleIntent(const SettingsIntent.checkUpdates());
        await Future.delayed(const Duration(milliseconds: 150));

        // Assert
        final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
        expect(messageEffects, isNotEmpty);
        expect(messageEffects.last.title, I18nKeys.checkUpdates.tr);
        expect(messageEffects.last.message, I18nKeys.latestVersion.tr);
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
        expect(effect.files, isNull);
        expect(effect.text, contains(AppConstants.storeShare));
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
        AppNav.currentArgs = const SettingsArguments(checkUpdate: true);
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

    group('Developer Mode Tests', () {
      test('should initialize developer mode to false', () {
        expect(container.read(settingsViewModelProvider).isDeveloperMode, isFalse);
      });

      test('should enable developer mode when enableDeveloperMode intent is received', () async {
        // Act
        await viewModel.onIntent(const SettingsIntent.enableDeveloperMode());
        // Allow async broadcast stream to deliver effect events
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(container.read(settingsViewModelProvider).isDeveloperMode, isTrue);
        expect(SpUtil.getBool('developer_mode'), isTrue);
        expect(
          emittedEffects.any(
            (effect) => effect is MessageEffect && effect.message == I18nKeys.developerModeEnabled.tr,
          ),
          isTrue,
        );
      });
    });
  });
}

class DummyPackageInfo implements IPackageInfo {
  static String mockVersion = '1.0.0';
  static String mockBuildNumber = '1';

  DummyPackageInfo([String? version, String? buildNumber]) {
    if (version != null) mockVersion = version;
    if (buildNumber != null) mockBuildNumber = buildNumber;
  }

  @override
  String get appName => 'dummy_app';

  @override
  String get packageName => 'com.dummy.app';

  @override
  String get version => mockVersion;

  @override
  String get buildNumber => mockBuildNumber;

  @override
  String get fullVersion => '$version+$buildNumber';

  @override
  Map<String, String> toHeaderMap() => {};
}
