import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/domain/models/fault_injection_scenario.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/fault_injection_intent.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/fault_injection_state.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/fault_injection_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall methodCall) async {
        if (methodCall.method == 'Clipboard.setData') {
          return null;
        }
        return null;
      },
    );
  });

  group('FaultInjectionViewModel Tests', () {
    late ProviderContainer container;
    late FaultInjectionViewModel viewModel;
    late ProviderSubscription<FaultInjectionState> subscription;
    final List<BaseEffect> emittedEffects = [];

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');
      container = ProviderContainer();
      subscription = container.listen(
        faultInjectionViewModelProvider,
        (_, __) {},
        fireImmediately: false,
      );
      viewModel = container.read(faultInjectionViewModelProvider.notifier);
      emittedEffects.clear();
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));
    });

    tearDown(() {
      subscription.close();
      container.dispose();
    });

    test('initial state contains 7 default scenarios and 0 runs', () {
      final state = container.read(faultInjectionViewModelProvider);
      expect(state.scenarios.length, 7);
      expect(state.selectedCategory, FaultCategory.all);
      expect(state.runningType, isNull);
      expect(state.totalRuns, 0);
      expect(state.recoveredCount, 0);
      expect(state.isSafeModeTriggered, isFalse);
      expect(state.consoleLogs, isEmpty);
    });

    test('selectCategory updates selectedCategory correctly', () {
      viewModel.handleIntent(const FaultInjectionIntent.selectCategory(FaultCategory.network));
      var state = container.read(faultInjectionViewModelProvider);
      expect(state.selectedCategory, FaultCategory.network);

      viewModel.handleIntent(const FaultInjectionIntent.selectCategory(FaultCategory.stability));
      state = container.read(faultInjectionViewModelProvider);
      expect(state.selectedCategory, FaultCategory.stability);
    });

    test('runScenario concurrent401 executes and recovers successfully', () async {
      await viewModel.handleIntent(
        const FaultInjectionIntent.runScenario(FaultScenarioType.concurrent401),
      );

      final state = container.read(faultInjectionViewModelProvider);
      expect(state.runningType, isNull);
      expect(state.totalRuns, 1);
      expect(state.recoveredCount, 1);
      expect(state.activeTraceId, isNotNull);
      expect(state.consoleLogs.isNotEmpty, isTrue);

      final scenario = state.scenarios.firstWhere((s) => s.type == FaultScenarioType.concurrent401);
      expect(scenario.status, ScenarioStatus.recovered);
      expect(scenario.lastExecutionDurationMs, isNotNull);
      expect(scenario.traceId, state.activeTraceId);
    });

    test('runScenario serverError500 executes and records failure mapping steps', () async {
      await viewModel.handleIntent(
        const FaultInjectionIntent.runScenario(FaultScenarioType.serverError500),
      );

      final state = container.read(faultInjectionViewModelProvider);
      expect(state.totalRuns, 1);
      final scenario = state.scenarios.firstWhere((s) => s.type == FaultScenarioType.serverError500);
      expect(scenario.status, ScenarioStatus.recovered);
    });

    test('runScenario networkTimeout executes and falls back to offline cache', () async {
      await viewModel.handleIntent(
        const FaultInjectionIntent.runScenario(FaultScenarioType.networkTimeout),
      );

      final state = container.read(faultInjectionViewModelProvider);
      expect(state.totalRuns, 1);
      final scenario = state.scenarios.firstWhere((s) => s.type == FaultScenarioType.networkTimeout);
      expect(scenario.status, ScenarioStatus.recovered);
    });

    test('runScenario malformedGateway executes and verifies type guard without crash', () async {
      await viewModel.handleIntent(
        const FaultInjectionIntent.runScenario(FaultScenarioType.malformedGateway),
      );

      final state = container.read(faultInjectionViewModelProvider);
      expect(state.totalRuns, 1);
      final scenario = state.scenarios.firstWhere((s) => s.type == FaultScenarioType.malformedGateway);
      expect(scenario.status, ScenarioStatus.recovered);
    });

    test('runScenario zoneAsyncCrash captures unhandled async error and saves log', () async {
      await viewModel.handleIntent(
        const FaultInjectionIntent.runScenario(FaultScenarioType.zoneAsyncCrash),
      );

      final state = container.read(faultInjectionViewModelProvider);
      expect(state.totalRuns, 1);
      final scenario = state.scenarios.firstWhere((s) => s.type == FaultScenarioType.zoneAsyncCrash);
      expect(scenario.status, ScenarioStatus.recovered);
    });

    test('runScenario consecutiveSafeMode triggers Safe Mode protection', () async {
      await viewModel.handleIntent(
        const FaultInjectionIntent.runScenario(FaultScenarioType.consecutiveSafeMode),
      );

      final state = container.read(faultInjectionViewModelProvider);
      expect(state.totalRuns, 1);
      expect(state.isSafeModeTriggered, isTrue);
      final scenario = state.scenarios.firstWhere((s) => s.type == FaultScenarioType.consecutiveSafeMode);
      expect(scenario.status, ScenarioStatus.recovered);
    });

    test('runScenario mainThreadJank executes and records APM jank warning', () async {
      await viewModel.handleIntent(
        const FaultInjectionIntent.runScenario(FaultScenarioType.mainThreadJank),
      );

      final state = container.read(faultInjectionViewModelProvider);
      expect(state.totalRuns, 1);
      final scenario = state.scenarios.firstWhere((s) => s.type == FaultScenarioType.mainThreadJank);
      expect(scenario.status, ScenarioStatus.recovered);
    });

    test('clearConsole clears all logs and activeTraceId', () async {
      await viewModel.handleIntent(
        const FaultInjectionIntent.runScenario(FaultScenarioType.concurrent401),
      );

      var state = container.read(faultInjectionViewModelProvider);
      expect(state.consoleLogs.isNotEmpty, isTrue);

      viewModel.handleIntent(const FaultInjectionIntent.clearConsole());

      state = container.read(faultInjectionViewModelProvider);
      expect(state.consoleLogs, isEmpty);
      expect(state.activeTraceId, isNull);
    });

    test('resetAll restores initial scenario statuses and statistics', () async {
      await viewModel.handleIntent(
        const FaultInjectionIntent.runScenario(FaultScenarioType.consecutiveSafeMode),
      );

      var state = container.read(faultInjectionViewModelProvider);
      expect(state.totalRuns, 1);
      expect(state.isSafeModeTriggered, isTrue);

      viewModel.handleIntent(const FaultInjectionIntent.resetAll());

      state = container.read(faultInjectionViewModelProvider);
      expect(state.totalRuns, 0);
      expect(state.recoveredCount, 0);
      expect(state.isSafeModeTriggered, isFalse);
      expect(state.consoleLogs, isEmpty);
      for (final scenario in state.scenarios) {
        expect(scenario.status, ScenarioStatus.idle);
      }
    });

    test('copyTraceId and drillTrace emit appropriate effects', () async {
      await viewModel.handleIntent(const FaultInjectionIntent.copyTraceId('test-trace-id'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(emittedEffects.length, 1);
      expect(emittedEffects.first, isA<MessageEffect>());

      await viewModel.handleIntent(const FaultInjectionIntent.drillTrace('test-trace-id'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(emittedEffects.length, 2);
      expect(LogOverlayManager.traceFilterNotifier.value, 'test-trace-id');
    });
  });
}
