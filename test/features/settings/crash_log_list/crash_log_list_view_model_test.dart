import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_view_model.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/view_log_effect.dart';
import 'package:listen_portfolio_flutter/shared/base/navigation_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/share_provider_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFile extends Mock implements File {}

/// [CrashLogListViewModel.onReady] 内部调用 [handleIntent] 但不 await，测试中需额外等待异步结束。
Future<void> waitForAsyncInit() async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
}

void main() {
  // 1. Initialize test binding to support platform channels and plugins in tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CrashLogListViewModel Tests', () {
    late ProviderContainer container;
    late CrashLogListViewModel viewModel;
    late ProviderSubscription<CrashLogListState> subscription;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      // 2. Mock SharedPreferences initial values for SpUtil initialization
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      // 3. Create a ProviderContainer for testing
      container = ProviderContainer();
      // Keep provider alive during async operations to prevent auto-dispose
      subscription = container.listen(crashLogListViewModelProvider, (_, __) {}, fireImmediately: false);
      viewModel = container.read(crashLogListViewModelProvider.notifier);

      // 4. Record all emitted effects for verification
      emittedEffects.clear();
      viewModel.onBindEffect((effect) {
        emittedEffects.add(effect);
      });
    });

    tearDown(() async {
      // Wait for any pending async operations before disposing
      await Future.delayed(Duration(milliseconds: 100));
      subscription.close();
      container.dispose();
    });

    test('Should have initial state with empty logs', () {
      final state = container.read(crashLogListViewModelProvider);
      expect(state.logs, isEmpty);
    });

    test('Should emit LoadingEffect during refresh intent', () async {
      // When - Trigger refresh intent to reload crash logs
      await viewModel.handleIntent(const CrashLogListIntent.refresh());
      // Yield to event loop for async stream delivery
      await Future.delayed(Duration.zero);

      // Then - Should show and then hide loading status
      final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
      expect(loadingEffects.any((e) => e.show == true), isTrue);
      expect(loadingEffects.last.show, isFalse);
    });

    test('Should emit ViewLogEffect when viewLog intent is handled', () async {
      // Given - A mock log file instance
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/crash.log');

      // When - Trigger viewLog intent with mock file
      await viewModel.handleIntent(CrashLogListIntent.viewLog(mockFile));
      await Future.delayed(Duration.zero);

      // Then - Should emit ViewLogEffect targeting the correct file
      expect(emittedEffects.any((e) => e is ViewLogEffect && e.file == mockFile), isTrue);
    });

    test('Should emit ShareEffect when shareLog intent is handled', () async {
      // Given - A mock log file instance
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/crash.log');

      // When - Trigger shareLog intent
      await viewModel.handleIntent(CrashLogListIntent.shareLog(mockFile));

      // Then - Should emit ShareEffect with correct file paths
      final shareEffect = emittedEffects.whereType<ShareEffect>().first;
      expect(shareEffect.files, contains(mockFile.path));
    });

    test('Should handle deleteLog intent and verify stability', () async {
      // Given - A mock log file instance
      final mockFile = MockFile();

      // When - Delete log (CommonDialog returns null in test context, so it should cancel gracefully)
      await viewModel.handleIntent(CrashLogListIntent.deleteLog(mockFile));

      // Then - ViewModel handles the cancellation/null result gracefully
      expect(viewModel.state, isNotNull);
      if (emittedEffects.isNotEmpty) {
        expect(emittedEffects.last.toString(), contains('show: false'));
      }
    });

    test('Should handle deleteAll intent gracefully without crashing', () async {
      // When - Trigger delete all crash reports intent
      await viewModel.handleIntent(const CrashLogListIntent.deleteAll());

      // Then - ViewModel handles the interaction flow gracefully
      expect(viewModel.state, isNotNull);
    });

    test('Should handle triggerCrash intent gracefully', () async {
      // 无 Navigator 时 CommonDialog.showConfirm 立即返回 null，不会调度 CrashManager.scheduleRandomCrash
      emittedEffects.clear();
      await viewModel.handleIntent(const CrashLogListIntent.triggerCrash());
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state, isNotNull);
      // 未确认对话框时不应发出“已调度崩溃”等信息类 effect
      expect(emittedEffects.whereType<MessageEffect>(), isEmpty);
    });

    test('Should trigger init process automatically via onReady lifecycle', () async {
      emittedEffects.clear();
      viewModel.onReady();
      await waitForAsyncInit();

      final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
      expect(loadingEffects.any((e) => e.show == true), isTrue);
      expect(loadingEffects.last.show, isFalse);
      expect(container.read(crashLogListViewModelProvider).logs, isA<List<File>>());
    });

    test('Should handle init intent and manage loading state sequence', () async {
      emittedEffects.clear();
      await viewModel.handleIntent(const CrashLogListIntent.init());
      await Future<void>.delayed(Duration.zero);

      final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
      expect(loadingEffects.any((e) => e.show == true), isTrue);
      expect(loadingEffects.last.show, isFalse);
      expect(container.read(crashLogListViewModelProvider).logs, isA<List<File>>());
    });
  });
}
