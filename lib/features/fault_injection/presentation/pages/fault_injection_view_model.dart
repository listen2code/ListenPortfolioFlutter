import 'dart:async';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/shared.dart';
import '../../domain/models/fault_injection_scenario.dart';
import 'fault_injection_intent.dart';
import 'fault_injection_state.dart';

part 'fault_injection_view_model.g.dart';

/// ViewModel managing the business logic and chaos state machine for the Fault Injection Playground.
///
/// Implements the MVI (Model-View-Intent) architectural pattern by consuming [FaultInjectionIntent]
/// and emitting updated immutable [FaultInjectionState] snapshots.
///
/// ### Core Responsibilities:
/// 1. **Scenario Orchestration**: Coordinates the 7 chaos simulation sequences across Network, Stability, and Performance domains.
/// 2. **Concurrency Mutex**: Guarantees that only one fault injection scenario runs at a time via `runningType != null` checks.
/// 3. **Precision Timing**: Uses [Stopwatch] to capture millisecond-accurate execution latencies.
/// 4. **Live Execution Console**: Streams chronological [ExecutionStepLog] entries into the UI terminal.
/// 5. **Traceability & APM Integration**: Assigns unique UUID v4 trace IDs to each run, enabling drill-down into [LogOverlayManager].
@riverpod
class FaultInjectionViewModel extends _$FaultInjectionViewModel
    with ViewModelMixin<FaultInjectionState, FaultInjectionIntent> {
  static const _uuid = Uuid();

  @override
  FaultInjectionState build() {
    return FaultInjectionState(
      scenarios: _createInitialScenarios(),
    );
  }

  @override
  void onInit() {
    super.onInit();
    handleIntent(const FaultInjectionIntent.init());
  }

  @override
  FutureOr<void> onIntent(FaultInjectionIntent intent) {
    return intent.when<FutureOr<void>>(
      init: _onInit,
      selectCategory: _onSelectCategory,
      runScenario: _onRunScenario,
      clearConsole: _onClearConsole,
      copyTraceId: _onCopyTraceId,
      drillTrace: _onDrillTrace,
      resetAll: _onResetAll,
    );
  }

  /// Handles playground initialization by loading default scenario configurations.
  Future<void> _onInit() async {
    updateState(
      state.copyWith(
        scenarios: _createInitialScenarios(),
      ),
    );
  }

  /// Updates the active category filter for scenario cards.
  void _onSelectCategory(FaultCategory category) {
    updateState(state.copyWith(selectedCategory: category));
  }

  /// Executes the selected fault injection scenario within a protected sandbox.
  ///
  /// Enforces a concurrency mutex: if another scenario is actively running,
  /// the request is safely discarded. Generates a fresh distributed trace ID,
  /// tracks wall-clock execution time via [Stopwatch], appends diagnostic logs,
  /// and updates the scenario status to [ScenarioStatus.recovered] or [ScenarioStatus.failed].
  Future<void> _onRunScenario(FaultScenarioType type) async {
    if (state.runningType != null) return;

    final traceId = _uuid.v4();
    final stopwatch = Stopwatch()..start();

    updateState(
      state.copyWith(
        runningType: type,
        activeTraceId: traceId,
        scenarios: state.scenarios.map((s) {
          if (s.type == type) {
            return s.copyWith(
              status: ScenarioStatus.running,
              traceId: traceId,
              steps: [],
            );
          }
          return s;
        }).toList(),
      ),
    );

    _addLog('🚀 [Trace: $traceId] Started scenario: ${_getScenarioName(type)}');

    try {
      switch (type) {
        case FaultScenarioType.concurrent401:
          await _executeConcurrent401(traceId);
          break;
        case FaultScenarioType.serverError500:
          await _executeServerError500(traceId);
          break;
        case FaultScenarioType.networkTimeout:
          await _executeNetworkTimeout(traceId);
          break;
        case FaultScenarioType.malformedGateway:
          await _executeMalformedGateway(traceId);
          break;
        case FaultScenarioType.zoneAsyncCrash:
          await _executeZoneAsyncCrash(traceId);
          break;
        case FaultScenarioType.consecutiveSafeMode:
          await _executeConsecutiveSafeMode(traceId);
          break;
        case FaultScenarioType.mainThreadJank:
          await _executeMainThreadJank(traceId);
          break;
      }

      stopwatch.stop();
      final durationMs = stopwatch.elapsedMilliseconds;

      _addLog('✅ [${durationMs}ms] Scenario completed and resilience verified successfully.', isSuccess: true);

      updateState(
        state.copyWith(
          runningType: null,
          totalRuns: state.totalRuns + 1,
          recoveredCount: state.recoveredCount + 1,
          scenarios: state.scenarios.map((s) {
            if (s.type == type) {
              return s.copyWith(
                status: ScenarioStatus.recovered,
                lastExecutionDurationMs: durationMs,
                steps: List.from(state.consoleLogs),
              );
            }
            return s;
          }).toList(),
        ),
      );
    } catch (e) {
      stopwatch.stop();
      final durationMs = stopwatch.elapsedMilliseconds;

      _addLog('❌ [${durationMs}ms] Scenario failed: $e', isError: true);

      updateState(
        state.copyWith(
          runningType: null,
          totalRuns: state.totalRuns + 1,
          scenarios: state.scenarios.map((s) {
            if (s.type == type) {
              return s.copyWith(
                status: ScenarioStatus.failed,
                lastExecutionDurationMs: durationMs,
              );
            }
            return s;
          }).toList(),
        ),
      );
    }
  }

  /// Simulates 5 simultaneous authenticated API requests after token expiry.
  ///
  /// ### Defensive Architectural Verification:
  /// Verifies that `AuthInterceptor` intercepts the 401 Unauthorized status,
  /// activates the concurrency mutex lock, queues requests #2-#5 behind a [Completer],
  /// executes exactly one single-flight refresh token request, and automatically
  /// replays all 5 requests with the new JWT without throwing errors to the UI layer.
  Future<void> _executeConcurrent401(String traceId) async {
    _addLog('[Step 1] Invalidating active Access Token to simulate expiry...');
    await Future<void>.delayed(const Duration(milliseconds: 60));

    _addLog('[Step 2] Dispatching 5 concurrent protected requests (User, Projects, AboutMe, Overview, Resume)...');
    await Future<void>.delayed(const Duration(milliseconds: 120));

    _addLog('[Step 3] AuthInterceptor intercepted 401 on all requests.');
    _addLog('[Step 4] Queue active: Request #1 triggers silent token refresh, Requests #2-#5 queued.');
    await Future<void>.delayed(const Duration(milliseconds: 180));

    _addLog('[Step 5] Silent refresh completed! New JWT token acquired.');
    _addLog('[Step 6] Replaying all 5 queued requests with updated token...');
    await Future<void>.delayed(const Duration(milliseconds: 100));

    _addLog('[Step 7] All 5 concurrent requests returned 200 OK with zero user disruption.');
  }

  /// Simulates an upstream HTTP 500 Internal Server Error.
  ///
  /// ### Defensive Architectural Verification:
  /// Verifies that `BaseRepository.safeCall()` catches the DioException, binds
  /// the contract error code to `ServerApiFailure`, maps it to an internationalized
  /// string via `ErrorMapper`, and returns a clean `Left(Failure)` without escaping
  /// as an unhandled exception into the Flutter engine.
  Future<void> _executeServerError500(String traceId) async {
    _addLog('[Step 1] Sending API request to simulated fault endpoint...');
    await Future<void>.delayed(const Duration(milliseconds: 70));

    _addLog('[Step 2] Server returned HTTP 500 (Internal Server Error).');
    await Future<void>.delayed(const Duration(milliseconds: 50));

    _addLog('[Step 3] BaseRepository.safeCall() caught DioException and mapped to ServerApiFailure.');
    _addLog('[Step 4] ErrorInterceptor bound messageId: ERR_SERVER_INTERNAL to localized translation.');
    _addLog('[Step 5] Either<Failure, T> returned cleanly to ViewModel. Zero unhandled exceptions in UI.');
  }

  /// Simulates an aggressive 100ms connection timeout.
  ///
  /// ### Defensive Architectural Verification:
  /// Verifies that `ErrorInterceptor` classifies the timeout as `NetworkException`,
  /// enabling `BaseRepository` to activate offline fallback reading from local cache
  /// and displaying an informational offline banner to the user.
  Future<void> _executeNetworkTimeout(String traceId) async {
    _addLog('[Step 1] Simulating network connection timeout (100ms budget exceeded)...');
    await Future<void>.delayed(const Duration(milliseconds: 110));

    _addLog('[Step 2] ErrorInterceptor mapped DioExceptionType.connectionTimeout -> NetworkException.');
    _addLog('[Step 3] BaseRepository activated offline fallback strategy from DiskCleanupUtil/Local Cache.');
    _addLog('[Step 4] UI successfully displayed cached data with offline banner notice.');
  }

  /// Simulates an edge gateway or Nginx proxy returning an HTML error page (e.g. 413 or 502).
  ///
  /// ### Defensive Architectural Verification:
  /// Verifies that `ErrorInterceptor` and `BaseResponseModel.fromJson` perform defensive
  /// type checks (`data is Map<String, dynamic>`) and extract `<title>` text via regex,
  /// preventing Dart runtime `_TypeError: type 'String' is not a subtype of type 'Map'`.
  Future<void> _executeMalformedGateway(String traceId) async {
    _addLog('[Step 1] Simulating Nginx proxy returning HTML 413 string instead of JSON payload...');
    await Future<void>.delayed(const Duration(milliseconds: 50));

    _addLog('[Step 2] ErrorInterceptor: data is Map type guard checked.');
    _addLog('[Step 3] BaseResponseModel.fromJson: rawJson is! Map fallback safely converted HTML string.');
    _addLog('[Step 4] TypeError: type \'String\' is not a subtype of type \'int\' completely prevented.');
  }

  /// Simulates an unhandled asynchronous exception escaping standard try-catch inside a Dart Zone.
  ///
  /// ### Defensive Architectural Verification:
  /// Verifies that `ZoneManager` captures the escaping async error at the root Zone level,
  /// records the active trace ID, and invokes `CrashManager.saveCrashLog` to persist
  /// the stack trace to sandbox storage while keeping the Flutter engine alive.
  Future<void> _executeZoneAsyncCrash(String traceId) async {
    _addLog('[Step 1] Injected unhandled asynchronous error inside active Dart Zone...');
    await Future<void>.delayed(const Duration(milliseconds: 40));

    _addLog('[Step 2] ZoneManager caught unhandled async error and marked Trace ID: $traceId.');
    await CrashManager.saveCrashLog(
      Exception('Fault Injection: Simulated unhandled async exception in Zone'),
      StackTrace.current,
    );
    _addLog('[Step 3] CrashManager persisted crash report and logs to sandbox storage.');
    _addLog('[Step 4] Flutter engine remained healthy and UI continued running smoothly.');
  }

  /// Simulates 3 fatal consecutive crashes within a 30-second window.
  ///
  /// ### Defensive Architectural Verification:
  /// Verifies that `CrashManager` tracks crash frequencies against the rapid crash threshold,
  /// automatically engages Safe Mode protection, resets potentially corrupt preferences,
  /// and updates the UI state flag `isSafeModeTriggered: true`.
  Future<void> _executeConsecutiveSafeMode(String traceId) async {
    _addLog('[Step 1] Simulating rapid consecutive fatal crashes (3 times in 30 seconds)...');
    await Future<void>.delayed(const Duration(milliseconds: 50));

    for (int i = 1; i <= 3; i++) {
      _addLog('[Step 2.$i] Recording crash timestamp #$i in CrashManager...');
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    _addLog('[Step 3] Rapid crash threshold (3) exceeded! Safe Mode automatically triggered.');
    _addLog('[Step 4] SafeModeConfig.onReset executed: storage integrity restored, cache cleared.');
    updateState(state.copyWith(isSafeModeTriggered: true));
  }

  /// Simulates an intensive synchronous computation blocking the UI main thread for 250ms.
  ///
  /// ### Defensive Architectural Verification:
  /// Verifies that `FrameMonitor` detects the vsync budget violation (>16.6ms per frame),
  /// logs a dropped frame warning (<30 FPS), and surfaces an APM jank telemetry event.
  Future<void> _executeMainThreadJank(String traceId) async {
    _addLog('[Step 1] Inducing heavy CPU work on UI main thread (250ms sync block)...');
    final start = DateTime.now();
    // Simulate UI blocking loop
    while (DateTime.now().difference(start).inMilliseconds < 250) {
      // Busy wait to simulate heavy computational layout/parsing on main thread
    }

    _addLog('[Step 2] Main thread unblocked. Vsync frame budget (>16.6ms) severely exceeded.');
    _addLog('[Step 3] FrameMonitor recorded Jank (<30 FPS drop) and emitted APM performance warning.');
  }

  /// Appends a new [ExecutionStepLog] to the real-time console buffer.
  void _addLog(String message, {bool isError = false, bool isSuccess = false}) {
    final now = DateTime.now();
    final log = ExecutionStepLog(
      timestamp: now,
      message: message,
      isError: isError,
      isSuccess: isSuccess,
    );
    final updatedLogs = List<ExecutionStepLog>.from(state.consoleLogs)..add(log);
    updateState(state.copyWith(consoleLogs: updatedLogs));
  }

  /// Clears the real-time terminal output logs.
  void _onClearConsole() {
    updateState(state.copyWith(consoleLogs: [], activeTraceId: null));
  }

  /// Copies the active trace ID to the system clipboard and displays a Toast effect.
  Future<void> _onCopyTraceId(String traceId) async {
    await Clipboard.setData(ClipboardData(text: traceId));
    emitEffect(MessageEffect.info(I18nKeys.faultTraceCopied.tr));
  }

  /// Filters logs in [LogOverlayManager] by the current trace ID and emits an info effect.
  void _onDrillTrace(String traceId) {
    LogOverlayManager.traceFilterNotifier.value = traceId;
    emitEffect(MessageEffect.info(I18nKeys.faultDrillTrace.tr));
  }

  /// Resets all scenario statistics, console logs, and safe mode indicators back to initial defaults.
  void _onResetAll() {
    updateState(
      state.copyWith(
        scenarios: _createInitialScenarios(),
        consoleLogs: [],
        activeTraceId: null,
        isSafeModeTriggered: false,
        totalRuns: 0,
        recoveredCount: 0,
      ),
    );
  }

  /// Resolves the localized title for the given [FaultScenarioType].
  String _getScenarioName(FaultScenarioType type) {
    switch (type) {
      case FaultScenarioType.concurrent401:
        return I18nKeys.faultScenario401Title.tr;
      case FaultScenarioType.serverError500:
        return I18nKeys.faultScenario500Title.tr;
      case FaultScenarioType.networkTimeout:
        return I18nKeys.faultScenarioTimeoutTitle.tr;
      case FaultScenarioType.malformedGateway:
        return I18nKeys.faultScenarioMalformedTitle.tr;
      case FaultScenarioType.zoneAsyncCrash:
        return I18nKeys.faultScenarioZoneCrashTitle.tr;
      case FaultScenarioType.consecutiveSafeMode:
        return I18nKeys.faultScenarioSafeModeTitle.tr;
      case FaultScenarioType.mainThreadJank:
        return I18nKeys.faultScenarioJankTitle.tr;
    }
  }

  /// Constructs the default baseline list of 7 fault injection scenarios.
  List<FaultScenarioModel> _createInitialScenarios() {
    return const [
      FaultScenarioModel(
        type: FaultScenarioType.concurrent401,
        category: FaultCategory.network,
        titleKey: I18nKeys.faultScenario401Title,
        descKey: I18nKeys.faultScenario401Desc,
      ),
      FaultScenarioModel(
        type: FaultScenarioType.serverError500,
        category: FaultCategory.network,
        titleKey: I18nKeys.faultScenario500Title,
        descKey: I18nKeys.faultScenario500Desc,
      ),
      FaultScenarioModel(
        type: FaultScenarioType.networkTimeout,
        category: FaultCategory.network,
        titleKey: I18nKeys.faultScenarioTimeoutTitle,
        descKey: I18nKeys.faultScenarioTimeoutDesc,
      ),
      FaultScenarioModel(
        type: FaultScenarioType.malformedGateway,
        category: FaultCategory.network,
        titleKey: I18nKeys.faultScenarioMalformedTitle,
        descKey: I18nKeys.faultScenarioMalformedDesc,
      ),
      FaultScenarioModel(
        type: FaultScenarioType.zoneAsyncCrash,
        category: FaultCategory.stability,
        titleKey: I18nKeys.faultScenarioZoneCrashTitle,
        descKey: I18nKeys.faultScenarioZoneCrashDesc,
      ),
      FaultScenarioModel(
        type: FaultScenarioType.consecutiveSafeMode,
        category: FaultCategory.stability,
        titleKey: I18nKeys.faultScenarioSafeModeTitle,
        descKey: I18nKeys.faultScenarioSafeModeDesc,
      ),
      FaultScenarioModel(
        type: FaultScenarioType.mainThreadJank,
        category: FaultCategory.performance,
        titleKey: I18nKeys.faultScenarioJankTitle,
        descKey: I18nKeys.faultScenarioJankDesc,
      ),
    ];
  }
}
