import 'package:flutter/foundation.dart';

enum FaultCategory {
  all,
  network,
  stability,
  performance,
}

enum FaultScenarioType {
  concurrent401,
  serverError500,
  networkTimeout,
  malformedGateway,
  zoneAsyncCrash,
  consecutiveSafeMode,
  mainThreadJank,
}

enum ScenarioStatus {
  idle,
  running,
  success,
  recovered,
  failed,
}

@immutable
class ExecutionStepLog {
  final DateTime timestamp;
  final String message;
  final bool isError;
  final bool isSuccess;
  final int elapsedMs;

  const ExecutionStepLog({
    required this.timestamp,
    required this.message,
    this.isError = false,
    this.isSuccess = false,
    this.elapsedMs = 0,
  });
}

@immutable
class FaultScenarioModel {
  final FaultScenarioType type;
  final FaultCategory category;
  final String titleKey;
  final String descKey;
  final ScenarioStatus status;
  final int? lastExecutionDurationMs;
  final String? traceId;
  final List<ExecutionStepLog> steps;

  const FaultScenarioModel({
    required this.type,
    required this.category,
    required this.titleKey,
    required this.descKey,
    this.status = ScenarioStatus.idle,
    this.lastExecutionDurationMs,
    this.traceId,
    this.steps = const [],
  });

  FaultScenarioModel copyWith({
    FaultScenarioType? type,
    FaultCategory? category,
    String? titleKey,
    String? descKey,
    ScenarioStatus? status,
    int? lastExecutionDurationMs,
    String? traceId,
    List<ExecutionStepLog>? steps,
  }) {
    return FaultScenarioModel(
      type: type ?? this.type,
      category: category ?? this.category,
      titleKey: titleKey ?? this.titleKey,
      descKey: descKey ?? this.descKey,
      status: status ?? this.status,
      lastExecutionDurationMs: lastExecutionDurationMs ?? this.lastExecutionDurationMs,
      traceId: traceId ?? this.traceId,
      steps: steps ?? this.steps,
    );
  }
}
