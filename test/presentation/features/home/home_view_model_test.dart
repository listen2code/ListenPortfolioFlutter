import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_view_model.dart';

void main() {
  group('HomeViewModel Tests', () {
    late HomeViewModel viewModel;

    setUp(() {
      viewModel = HomeViewModel();
    });

    test('Should have initial state with overview tab', () {
      // Verify initial state
      expect(viewModel.state.currentTab, HomeTab.overview);
      expect(viewModel.state.title, isNotEmpty);
      expect(viewModel.state.isLoading, isFalse);
    });

    test('Should update tab when tab changed intent is handled', () {
      // Given
      const newTab = HomeTab.aboutMe;
      const intent = HomeIntent.tabChanged(newTab);

      // When
      viewModel.handleIntent(intent);

      // Then
      expect(viewModel.state.currentTab, newTab);
    });

    test('Should update title when tab is changed', () {
      // Given
      const newTab = HomeTab.projects;
      const intent = HomeIntent.tabChanged(newTab);

      // When
      viewModel.handleIntent(intent);

      // Then - Title should be updated based on tab
      expect(viewModel.state.title, isNotEmpty);
      expect(viewModel.state.currentTab, newTab);
    });

    test('Should handle all tab changes correctly', () {
      // Test all tabs
      final tabs = [HomeTab.overview, HomeTab.aboutMe, HomeTab.projects, HomeTab.architecture];

      for (final tab in tabs) {
        // When
        viewModel.handleIntent(HomeIntent.tabChanged(tab));

        // Then
        expect(viewModel.state.currentTab, tab);
      }
    });

    test('Should handle logout intent', () {
      // Given - Change tab first
      viewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.aboutMe));
      expect(viewModel.state.currentTab, HomeTab.aboutMe);

      // When - Handle logout
      viewModel.handleIntent(const HomeIntent.logout());

      // Then - Tab should remain the same (logout logic handled elsewhere)
      expect(viewModel.state.currentTab, HomeTab.aboutMe);
    });
  });
}
