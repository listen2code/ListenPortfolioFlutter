import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../domain/models/fault_injection_scenario.dart';

part 'fault_injection_state.freezed.dart';

/// Immutable UI state representing the Fault Injection Playground.
///
/// Holds the active scenario models, current category filter, active execution type,
/// distributed trace ID, real-time console log buffer, and resilience statistics.
@freezed
abstract class FaultInjectionState extends BaseState with _$FaultInjectionState {
  /// Default factory constructor for [FaultInjectionState].
  const factory FaultInjectionState({
    /// Currently active category filter used to filter visible scenario cards.
    @Default(FaultCategory.all) FaultCategory selectedCategory,

    /// Full list of available fault scenarios and their current statuses.
    @Default([]) List<FaultScenarioModel> scenarios,

    /// The [FaultScenarioType] currently being executed, or null if idle.
    FaultScenarioType? runningType,

    /// Distributed trace ID generated for the ongoing or most recent execution run.
    String? activeTraceId,

    /// Chronological list of execution step logs displayed in the terminal console.
    @Default([]) List<ExecutionStepLog> consoleLogs,

    /// Indicates whether CrashManager's Safe Mode protection was activated during the session.
    @Default(false) bool isSafeModeTriggered,

    /// Total number of scenario runs executed during the current session.
    @Default(0) int totalRuns,

    /// Total number of scenarios that recovered successfully through defensive mechanisms.
    @Default(0) int recoveredCount,
  }) = _FaultInjectionState;

  const FaultInjectionState._();
}
