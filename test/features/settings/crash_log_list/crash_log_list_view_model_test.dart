import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_view_model.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/view_log_effect.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
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

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory' ||
            methodCall.method == 'getTemporaryDirectory') {
          return 'temp_docs';
        }
        return null;
      },
    );
  });

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
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));
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

    test('Should delete log on confirmation', () async {
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/crash_1.log');
      when(() => mockFile.exists()).thenAnswer((_) async => true);
      when(() => mockFile.delete()).thenAnswer((_) async => mockFile);

      emittedEffects.clear();

      await viewModel.handleIntent(CrashLogListIntent.deleteLog(mockFile));

      final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
      expect(confirmEffects, isNotEmpty);

      // Simulate confirmation
      confirmEffects.last.onResult(true);
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockFile.exists()).called(1);
      verify(() => mockFile.delete()).called(1);

      final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
      expect(loadingEffects.any((e) => e.show == true), isTrue);
    });

    test('Should not delete log if cancelled', () async {
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/crash_1.log');

      emittedEffects.clear();

      await viewModel.handleIntent(CrashLogListIntent.deleteLog(mockFile));

      final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
      expect(confirmEffects, isNotEmpty);

      // Simulate cancellation
      confirmEffects.last.onResult(false);
      await Future.delayed(const Duration(milliseconds: 100));

      verifyNever(() => mockFile.exists());
    });

    test('Should delete all logs on confirmation', () async {
      emittedEffects.clear();

      await viewModel.handleIntent(const CrashLogListIntent.deleteAll());

      final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
      expect(confirmEffects, isNotEmpty);

      // Simulate confirmation
      confirmEffects.last.onResult(true);
      await Future.delayed(const Duration(milliseconds: 100));

      final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
      expect(loadingEffects.any((e) => e.show == true), isTrue);

      final infoEffects = emittedEffects.whereType<MessageEffect>().toList();
      expect(infoEffects.any((e) => e.message == I18nKeys.cacheCleared.tr), isTrue);
    });

    test('Should not delete all logs if cancelled', () async {
      emittedEffects.clear();

      await viewModel.handleIntent(const CrashLogListIntent.deleteAll());

      final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
      expect(confirmEffects, isNotEmpty);

      // Simulate cancellation
      confirmEffects.last.onResult(false);
      await Future.delayed(const Duration(milliseconds: 100));

      final loadingEffects = emittedEffects.whereType<LoadingEffect>().toList();
      expect(loadingEffects.any((e) => e.show == true), isFalse);
    });

    test('Should schedule random crash on confirmation', () async {
      emittedEffects.clear();

      await viewModel.handleIntent(const CrashLogListIntent.triggerCrash());

      final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
      expect(confirmEffects, isNotEmpty);

      // Simulate confirmation
      confirmEffects.last.onResult(true);
      await Future.delayed(const Duration(milliseconds: 100));

      final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
      expect(messageEffects, isNotEmpty);
      expect(messageEffects.last.message, I18nKeys.crashScheduled.tr);
    });

    test('Should not schedule random crash if cancelled', () async {
      emittedEffects.clear();

      await viewModel.handleIntent(const CrashLogListIntent.triggerCrash());

      final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
      expect(confirmEffects, isNotEmpty);

      // Simulate cancellation
      confirmEffects.last.onResult(false);
      await Future.delayed(const Duration(milliseconds: 100));

      final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
      expect(messageEffects, isEmpty);
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
