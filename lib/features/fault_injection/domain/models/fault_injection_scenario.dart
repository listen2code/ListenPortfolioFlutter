import 'package:flutter/foundation.dart';

/// Categorization of chaos engineering fault injection scenarios.
///
/// Scenarios are divided into three high-level architectural categories
/// to facilitate focused testing and UI filtering:
/// - [network]: Dio interceptors, HTTP status codes, timeouts, and gateway corruption.
/// - [stability]: Zone error sandboxing, unhandled asynchronous crashes, and Safe Mode circuit breakers.
/// - [performance]: UI main thread jank, frame drop detection, and APM alerting.
enum FaultCategory {
  /// Displays all available fault injection scenarios regardless of domain.
  all,

  /// Scenarios simulating transport-level, authentication, or gateway anomalies.
  network,

  /// Scenarios simulating fatal runtime errors, escaping async crashes, or reboot loops.
  stability,

  /// Scenarios simulating UI thread blocking, heavy computations, or vsync frame drops.
  performance,
}

/// Enumeration of all discrete fault injection scenarios supported by the playground.
///
/// Each scenario simulates a specific real-world failure mode and tests
/// a corresponding defensive mechanism in the application architecture.
enum FaultScenarioType {
  /// Simulates 5 simultaneous authenticated API requests after token expiry,
  /// testing the `AuthInterceptor` concurrency queue and single-flight token refresh.
  concurrent401,

  /// Simulates an upstream HTTP 500 Internal Server Error, testing `BaseRepository.safeCall()`
  /// and functional `Either<Failure, T>` error mapping without throwing unhandled exceptions.
  serverError500,

  /// Simulates an aggressive 100ms connection timeout, testing timeout mapping
  /// to `NetworkException` and offline cache fallback strategies.
  networkTimeout,

  /// Simulates an edge gateway or Nginx proxy returning an HTML error page (e.g. 413 or 502)
  /// instead of expected JSON, testing `BaseResponseModel.fromJson` Map type guards.
  malformedGateway,

  /// Simulates an unhandled asynchronous error escaping standard try-catch inside a Dart Zone,
  /// testing `ZoneManager` root error trapping and sandbox crash log persistence.
  zoneAsyncCrash,

  /// Simulates 3 fatal crashes within a 30-second window, testing the `CrashManager`
  /// consecutive crash threshold and automated Safe Mode activation.
  consecutiveSafeMode,

  /// Simulates an intensive synchronous calculation blocking the UI main thread for 250ms,
  /// testing `FrameMonitor` vsync budget violation detection and APM jank reporting.
  mainThreadJank,
}

/// Lifecycle status of an individual fault injection scenario during execution.
enum ScenarioStatus {
  /// Scenario has not been executed in the current session.
  idle,

  /// Scenario is actively executing its fault injection sequence.
  running,

  /// Scenario completed normally (used when an error was expected and caught cleanly).
  success,

  /// Scenario successfully self-healed, recovered, or degraded gracefully via architectural defenses.
  recovered,

  /// Scenario failed its resilience contract or encountered an unhandled crash.
  failed,
}

/// Represents a single chronological log entry recorded during scenario execution.
///
/// Rendered in the real-time [FaultExecutionConsole] widget to provide millisecond-level
/// visibility into the fault injection and self-healing phases.
@immutable
class ExecutionStepLog {
  /// Wall-clock timestamp when this execution step occurred.
  final DateTime timestamp;

  /// Human-readable diagnostic description of the step (e.g. '[Step 1] Invaliding token...').
  final String message;

  /// Indicates whether this step represents a detected or injected error condition.
  final bool isError;

  /// Indicates whether this step represents a successful recovery or assertion.
  final bool isSuccess;

  /// Elapsed milliseconds since the scenario started.
  final int elapsedMs;

  /// Creates an immutable [ExecutionStepLog] instance.
  const ExecutionStepLog({
    required this.timestamp,
    required this.message,
    this.isError = false,
    this.isSuccess = false,
    this.elapsedMs = 0,
  });
}

/// Domain model representing a fault injection scenario and its interactive state.
///
/// Encapsulates scenario metadata, internationalized title and description keys,
/// current execution status, execution duration, associated trace ID, and step logs.
@immutable
class FaultScenarioModel {
  /// The unique type identifier of this fault scenario.
  final FaultScenarioType type;

  /// The domain category this scenario belongs to.
  final FaultCategory category;

  /// Translation key for the user-facing scenario title.
  final String titleKey;

  /// Translation key for the detailed technical description of the scenario.
  final String descKey;

  /// Current execution and recovery status.
  final ScenarioStatus status;

  /// Duration of the most recent execution in milliseconds, or null if never run.
  final int? lastExecutionDurationMs;

  /// Distributed trace identifier generated for the latest execution run.
  final String? traceId;

  /// Chronological sequence of step logs generated during scenario execution.
  final List<ExecutionStepLog> steps;

  /// Creates an immutable [FaultScenarioModel] instance.
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

  /// Creates a copy of this scenario model with the specified fields replaced.
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
