import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/appearance_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/appearance_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/appearance_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Initialize Flutter binding for all tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppearanceViewModel Tests', () {
    late ProviderContainer container;
    late AppearanceViewModel viewModel;

    setUp(() async {
      // Clear SharedPreferences and mock fresh values for each test
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      container = ProviderContainer();
      container.read(appearanceViewModelProvider);
      viewModel = container.read(appearanceViewModelProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('Should have initial state with system theme mode', () {
      final state = container.read(appearanceViewModelProvider);
      expect(state.themeMode, ThemeMode.system);
      expect(state.accentColor, isNotNull);
      expect(state.fontSize, isNotNull);
    });

    test('Should update theme mode when setThemeMode intent is handled', () {
      const newThemeMode = ThemeMode.dark;
      const intent = AppearanceIntent.setThemeMode(newThemeMode);

      viewModel.handleIntent(intent);

      final state = container.read(appearanceViewModelProvider);
      expect(state.themeMode, newThemeMode);
    });

    test('Should update accent color when setAccentColor intent is handled', () {
      const newColor = Colors.blue;
      const intent = AppearanceIntent.setAccentColor(newColor);

      viewModel.handleIntent(intent);

      final state = container.read(appearanceViewModelProvider);
      expect(state.accentColor, newColor);
    });

    test('Should update font size when setFontSize intent is handled', () {
      const newFontSize = AppFontSize.large;
      const intent = AppearanceIntent.setFontSize(newFontSize);

      viewModel.handleIntent(intent);

      final state = container.read(appearanceViewModelProvider);
      expect(state.fontSize, newFontSize);
    });

    test('Should handle multiple appearance changes correctly', () {
      final state0 = container.read(appearanceViewModelProvider);
      // Accept the current initial state (could be system or dark based on defaults)
      expect(state0.themeMode, isA<ThemeMode>());

      viewModel.handleIntent(const AppearanceIntent.setThemeMode(ThemeMode.dark));
      viewModel.handleIntent(const AppearanceIntent.setAccentColor(Colors.red));
      viewModel.handleIntent(const AppearanceIntent.setFontSize(AppFontSize.large));

      final state = container.read(appearanceViewModelProvider);
      expect(state.themeMode, ThemeMode.dark);
      expect(state.accentColor, Colors.red);
      expect(state.fontSize, AppFontSize.large);
    });
  });
}
