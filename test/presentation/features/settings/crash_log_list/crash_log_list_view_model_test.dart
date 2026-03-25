import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_view_model.dart';

void main() {
  group('CrashLogListViewModel Tests', () {
    late CrashLogListViewModel viewModel;

    setUp(() {
      viewModel = CrashLogListViewModel();
    });

    test('Should have initial state with empty logs', () {
      // Verify initial state
      expect(viewModel.state.logs, isEmpty);
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.error, isNull);
    });

    test('Should handle refresh intent', () {
      // Given - Initial state
      expect(viewModel.state.isLoading, isFalse);

      // When - Handle refresh intent
      viewModel.handleIntent(const CrashLogListIntent.refresh());

      // Then - Loading state should be updated
      expect(viewModel.state.isLoading, isTrue);
    });

    test('Should handle trigger crash intent', () {
      // Given - Initial state
      final initialLogCount = viewModel.state.logs.length;

      // When - Handle trigger crash intent
      viewModel.handleIntent(const CrashLogListIntent.triggerCrash());

      // Then - Log count should increase (crash log added)
      expect(viewModel.state.logs.length, greaterThan(initialLogCount));
    });

    test('Should handle delete all intent when logs exist', () {
      // Given - Add some logs first
      viewModel.handleIntent(const CrashLogListIntent.triggerCrash());
      viewModel.handleIntent(const CrashLogListIntent.triggerCrash());
      expect(viewModel.state.logs.length, greaterThan(0));

      // When - Handle delete all intent
      viewModel.handleIntent(const CrashLogListIntent.deleteAll());

      // Then - All logs should be deleted
      expect(viewModel.state.logs, isEmpty);
    });

    test('Should handle delete all intent when no logs exist', () {
      // Given - Ensure no logs exist
      expect(viewModel.state.logs, isEmpty);

      // When - Handle delete all intent
      viewModel.handleIntent(const CrashLogListIntent.deleteAll());

      // Then - Logs should remain empty
      expect(viewModel.state.logs, isEmpty);
    });

    test('Should handle view log intent', () {
      // Given - Add a log first
      viewModel.handleIntent(const CrashLogListIntent.triggerCrash());
      final logToView = viewModel.state.logs.first;

      // When - Handle view log intent
      viewModel.handleIntent(CrashLogListIntent.viewLog(logToView));

      // Then - Effect should be triggered (view log effect)
      // Note: The actual effect handling would be tested in integration tests
      expect(viewModel.state.logs.contains(logToView), isTrue);
    });
  });
}
