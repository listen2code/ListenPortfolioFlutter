import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsViewModel Tests', () {
    late ProviderContainer container;
    late SettingsViewModel viewModel;
    late ProviderSubscription<SettingsState> subscription;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      container = ProviderContainer();
      subscription = container.listen(settingsViewModelProvider, (_, __) {}, fireImmediately: false);
      viewModel = container.read(settingsViewModelProvider.notifier);
      emittedEffects.clear();
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));
    });

    tearDown(() {
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
      test('should emit LoadingEffect(true) then LoadingEffect(false)', () async {
        // Act
        await viewModel.handleIntent(const SettingsIntent.resetSettings());
        
        // Wait for async operations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
        expect(loadingEffects.length, greaterThanOrEqualTo(2));
        expect(loadingEffects.first.show, isTrue);
        expect(loadingEffects.last.show, isFalse);
      });

      test('should emit a MessageEffect after resetting settings', () async {
        // Act
        await viewModel.handleIntent(const SettingsIntent.resetSettings());
        
        // Wait for async operations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
        expect(messageEffects, isNotEmpty);
        expect(messageEffects.last.message, I18nKeys.settingsResetSuccess.tr);
      });
    });
  });
}
