import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../shared/utils/playback_registry_init.dart';
import '../../domain/models/fault_injection_scenario.dart';

part 'fault_injection_intent.freezed.dart';

@freezed
class FaultInjectionIntent extends BaseIntent with _$FaultInjectionIntent {
  const factory FaultInjectionIntent.init() = _Init;
  const factory FaultInjectionIntent.selectCategory(FaultCategory category) = _SelectCategory;
  const factory FaultInjectionIntent.runScenario(FaultScenarioType type) = _RunScenario;
  const factory FaultInjectionIntent.clearConsole() = _ClearConsole;
  const factory FaultInjectionIntent.copyTraceId(String traceId) = _CopyTraceId;
  const factory FaultInjectionIntent.drillTrace(String traceId) = _DrillTrace;
  const factory FaultInjectionIntent.resetAll() = _ResetAll;

  const FaultInjectionIntent._();

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
