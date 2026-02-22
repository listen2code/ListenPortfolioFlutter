import 'dart:async';

import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/utils/logger.dart';
import 'package:uuid/uuid.dart';

/// Manages data stored in the current [Zone].
/// This handles distributed tracing, request cancellation, and performance profiling.
class ZoneManager {
  ZoneManager._();

  static const String mainTraceId = "app-init";
  static const Symbol _traceKey = Symbol('trace_id_key');
  static const Symbol _cancelTokenKey = Symbol('dio_cancel_token_key');
  static const Symbol _perfKey = Symbol('perf_trace_key');

  /// Gets the current Trace ID from the Zone.
  static String get currentTraceId => Zone.current[_traceKey] ?? 'no-trace-id';

  /// Gets the current [CancelToken] from the Zone.
  static CancelToken? get currentCancelToken => Zone.current[_cancelTokenKey];

  /// Internal helper to get performance tracker.
  static _PerfTrace? get _perf => Zone.current[_perfKey];

  /// Marks a specific stage in the current execution flow.
  /// It records the duration since the last mark.
  static void mark(String stage) => _perf?._mark(stage);

  /// Runs the [body] in a new Zone with a Trace ID and performance tracking.
  static T run<T>(
    T Function() body, {
    String? traceId,
    CancelToken? cancelToken,
    Map<Object?, Object?>? zoneValues,
    bool silent = false,
  }) {
    final id = _resolveId(traceId);
    final perf = _PerfTrace();

    return runZoned(
      () {
        try {
          final result = body();
          if (result is Future) {
            return result.then(
                  (value) {
                    if (!silent) _logSummary(id, perf);
                    return value;
                  },
                  onError: (e, s) {
                    if (!silent) _logError(id, perf);
                    throw e;
                  },
                )
                as T;
          }
          // Synchronous success
          if (!silent) _logSummary(id, perf);
          return result;
        } catch (e) {
          // Synchronous error or error during Future creation
          if (!silent) _logError(id, perf);
          rethrow;
        }
      },
      zoneValues: {
        _traceKey: id,
        if (cancelToken != null) _cancelTokenKey: cancelToken,
        _perfKey: perf,
        ...?zoneValues,
      },
    );
  }

  /// Runs the [body] in a protected Zone that catches unhandled asynchronous errors.
  static Future<void> runGuarded(
    FutureOr<void> Function() body, {
    String? traceId,
    CancelToken? cancelToken,
    Map<Object?, Object?>? zoneValues,
    void Function(Object error, StackTrace stack)? onError,
    bool silent = false,
  }) async {
    final id = _resolveId(traceId);
    final perf = _PerfTrace();

    return runZonedGuarded(
      () async {
        try {
          await body();
          if (!silent) _logSummary(id, perf);
        } catch (e) {
          // Handled errors within the async body
          if (!silent) _logError(id, perf);
          rethrow;
        }
      },
      (error, stack) {
        // Automatically associate unhandled async errors with the current Trace ID
        appLogger.e('Unhandled error in Zone [$id]: $error', error: error, stackTrace: stack);
        onError?.call(error, stack);
      },
      zoneValues: {
        _traceKey: id,
        if (cancelToken != null) _cancelTokenKey: cancelToken,
        _perfKey: perf,
        ...?zoneValues,
      },
    );
  }

  // --- Private Helpers ---

  static String _resolveId(String? providedId) {
    if (providedId != null) return providedId;
    final String? parentId = Zone.current[_traceKey];
    // If there is an existing trace ID (and it's not the default init one), reuse it.
    if (parentId != null && parentId.isNotEmpty && parentId != mainTraceId) {
      return parentId;
    }
    return const Uuid().v4();
  }

  static void _logSummary(String id, _PerfTrace perf) {
    final summary = perf._summary();
    if (summary.isNotEmpty) {
      appLogger.d('Performance Summary:$summary');
    }
  }

  static void _logError(String id, _PerfTrace perf) {
    final summary = perf._summary();
    appLogger.d('Execution Terminated by error.${summary.isNotEmpty ? summary : ""}');
  }
}

/// Internal class to track performance stages within a Zone.
class _PerfTrace {
  final Stopwatch _stopwatch = Stopwatch()..start();
  final List<({String name, int duration})> _stages = [];
  int _lastMarkTime = 0;

  void _mark(String stage) {
    final int now = _stopwatch.elapsedMilliseconds;
    _stages.add((name: stage, duration: now - _lastMarkTime));
    _lastMarkTime = now;
  }

  String _summary() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    }

    if (_stages.isEmpty && _stopwatch.elapsedMilliseconds < 5) return "";

    final int now = _stopwatch.elapsedMilliseconds;
    final int finalStageDuration = now - _lastMarkTime;

    final buffer = StringBuffer();
    int totalSum = 0;

    for (final s in _stages) {
      buffer.write('\n  - ${s.name}: ${s.duration}ms');
      totalSum += s.duration;
    }

    if (finalStageDuration > 0) {
      buffer.write('\n  - [Finalize]: ${finalStageDuration}ms');
      totalSum += finalStageDuration;
    }

    buffer.write('\n  => Total (Sum): ${totalSum}ms');
    return buffer.toString();
  }
}
