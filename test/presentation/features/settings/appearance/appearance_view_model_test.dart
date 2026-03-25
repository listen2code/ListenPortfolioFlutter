import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/appearance_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/appearance_view_model.dart';

void main() {
  group('AppearanceViewModel Tests', () {
    late AppearanceViewModel viewModel;

    setUp(() {
      viewModel = AppearanceViewModel();
    });

    test('Should have initial state with system theme mode', () {
      // Verify initial state
      expect(viewModel.state.themeMode, ThemeMode.system);
      expect(viewModel.state.accentColor, isNotNull);
      expect(viewModel.state.fontSize, greaterThan(0));
      expect(viewModel.state.fontFamily, isNotEmpty);
    });

    test('Should update theme mode when theme changed intent is handled', () {
      // Given
      const newThemeMode = ThemeMode.dark;
      const intent = AppearanceIntent.themeModeChanged(newThemeMode);

      // When
      viewModel.handleIntent(intent);

      // Then
      expect(viewModel.state.themeMode, newThemeMode);
    });

    test('Should update accent color when color changed intent is handled', () {
      // Given
      const newColor = Colors.blue;
      const intent = AppearanceIntent.accentColorChanged(newColor);

      // When
      viewModel.handleIntent(intent);

      // Then
      expect(viewModel.state.accentColor, newColor);
    });

    test(
      'Should update font size when font size changed intent is handled',
      () {
        // Given
        const newFontSize = 18.0;
        const intent = AppearanceIntent.fontSizeChanged(newFontSize);

        // When
        viewModel.handleIntent(intent);

        // Then
        expect(viewModel.state.fontSize, newFontSize);
      },
    );

    test(
      'Should update font family when font family changed intent is handled',
      () {
        // Given
        const newFontFamily = 'Roboto';
        const intent = AppearanceIntent.fontFamilyChanged(newFontFamily);

        // When
        viewModel.handleIntent(intent);

        // Then
        expect(viewModel.state.fontFamily, newFontFamily);
      },
    );

    test('Should handle multiple appearance changes correctly', () {
      // Given - Initial state
      expect(viewModel.state.themeMode, ThemeMode.system);

      // When - Change multiple appearance settings
      viewModel.handleIntent(
        const AppearanceIntent.themeModeChanged(ThemeMode.dark),
      );
      viewModel.handleIntent(
        const AppearanceIntent.accentColorChanged(Colors.red),
      );
      viewModel.handleIntent(const AppearanceIntent.fontSizeChanged(20.0));
      viewModel.handleIntent(
        const AppearanceIntent.fontFamilyChanged('Open Sans'),
      );

      // Then - All changes should be applied
      expect(viewModel.state.themeMode, ThemeMode.dark);
      expect(viewModel.state.accentColor, Colors.red);
      expect(viewModel.state.fontSize, 20.0);
      expect(viewModel.state.fontFamily, 'Open Sans');
    });
  });
}
