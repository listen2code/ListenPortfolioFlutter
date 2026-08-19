import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../domain/models/fault_injection_scenario.dart';

part 'fault_injection_state.freezed.dart';

@freezed
abstract class FaultInjectionState extends BaseState with _$FaultInjectionState {
  const factory FaultInjectionState({
    @Default(FaultCategory.all) FaultCategory selectedCategory,
    @Default([]) List<FaultScenarioModel> scenarios,
    FaultScenarioType? runningType,
    String? activeTraceId,
    @Default([]) List<ExecutionStepLog> consoleLogs,
    @Default(false) bool isSafeModeTriggered,
    @Default(0) int totalRuns,
    @Default(0) int recoveredCount,
  }) = _FaultInjectionState;

  const FaultInjectionState._();
}
