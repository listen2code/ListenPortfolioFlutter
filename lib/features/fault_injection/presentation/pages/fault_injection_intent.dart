import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../shared/utils/playback_registry_init.dart';
import '../../domain/models/fault_injection_scenario.dart';

part 'fault_injection_intent.freezed.dart';

/// User and system intents driving the Fault Injection Playground MVI state machine.
///
/// Encapsulates all interactions possible within the playground:
/// initializing scenarios, switching category filters, triggering chaos executions,
/// managing the terminal console, inspecting distributed trace IDs, and global resets.
@freezed
class FaultInjectionIntent extends BaseIntent with _$FaultInjectionIntent {
  /// Initializes or re-initializes default fault scenario items.
  const factory FaultInjectionIntent.init() = _Init;

  /// Filters the visible list of scenarios by the specified [FaultCategory].
  const factory FaultInjectionIntent.selectCategory(FaultCategory category) = _SelectCategory;

  /// Executes the simulated fault sequence for the given [FaultScenarioType].
  const factory FaultInjectionIntent.runScenario(FaultScenarioType type) = _RunScenario;

  /// Clears the real-time execution step logs from the interactive console.
  const factory FaultInjectionIntent.clearConsole() = _ClearConsole;

  /// Copies the provided [traceId] to the system clipboard and emits a confirmation Toast.
  const factory FaultInjectionIntent.copyTraceId(String traceId) = _CopyTraceId;

  /// Deep-links the current [traceId] into the global [LogOverlayManager] to filter logs.
  const factory FaultInjectionIntent.drillTrace(String traceId) = _DrillTrace;

  /// Resets all scenario execution counters, status badges, and terminal logs back to baseline.
  const factory FaultInjectionIntent.resetAll() = _ResetAll;

  const FaultInjectionIntent._();

  /// Registers all intent constructors with the [MviPlaybackRegistry].
  ///
  /// This enables deterministic JSON serialization and deserialization of user actions,
  /// allowing full playback, regression replay, and telemetry reproduction of chaos sessions.
  static void registerPlayback() {
    MviPlaybackRegistry.register(
      'FaultInjectionIntent',
      'init',
      (args) => const FaultInjectionIntent.init(),
    );
    MviPlaybackRegistry.register(
      'FaultInjectionIntent',
      'selectCategory',
      (args) {
        final catStr = args['category'] ?? '';
        final cat = FaultCategory.values.firstWhere(
          (e) => e.name == catStr || e.toString() == catStr,
          orElse: () => FaultCategory.all,
        );
        return FaultInjectionIntent.selectCategory(cat);
      },
    );
    MviPlaybackRegistry.register(
      'FaultInjectionIntent',
      'runScenario',
      (args) {
        final typeStr = args['type'] ?? '';
        final type = FaultScenarioType.values.firstWhere(
          (e) => e.name == typeStr || e.toString() == typeStr,
          orElse: () => FaultScenarioType.concurrent401,
        );
        return FaultInjectionIntent.runScenario(type);
      },
    );
    MviPlaybackRegistry.register(
      'FaultInjectionIntent',
      'clearConsole',
      (args) => const FaultInjectionIntent.clearConsole(),
    );
    MviPlaybackRegistry.register(
      'FaultInjectionIntent',
      'copyTraceId',
      (args) => FaultInjectionIntent.copyTraceId(args['traceId'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'FaultInjectionIntent',
      'drillTrace',
      (args) => FaultInjectionIntent.drillTrace(args['traceId'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'FaultInjectionIntent',
      'resetAll',
      (args) => const FaultInjectionIntent.resetAll(),
    );
  }
}
