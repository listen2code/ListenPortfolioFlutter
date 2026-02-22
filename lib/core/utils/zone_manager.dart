import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:listen_portfolio_flutter/core/utils/log_manager.dart';
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

  /// Specialized runner for Page Rendering performance tracking.
  static Widget runPage(String pageName, Widget Function() builder) {
    final String id = "page-$pageName-${const Uuid().v4().substring(0, 8)}";
    final perf = _PerfTrace();

    return _ZonePageWrapper(id: id, perf: perf, builder: builder);
  }

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
                    if (!silent) _logSummary(id, perf, label: 'Intent');
                    return value;
                  },
                  onError: (e, s) {
                    if (!silent) _logError(id, perf);
                    throw e;
                  },
                )
                as T;
          }
          if (!silent) _logSummary(id, perf, label: 'Intent');
          return result;
        } catch (e) {
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
          if (!silent) _logSummary(id, perf, label: 'Task');
        } catch (e) {
          if (!silent) _logError(id, perf);
          rethrow;
        }
      },
      (error, stack) {
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

  static String _resolveId(String? providedId) {
    if (providedId != null) return providedId;
    final String? parentId = Zone.current[_traceKey];
    if (parentId != null && parentId.isNotEmpty && parentId != mainTraceId) {
      return parentId;
    }
    return const Uuid().v4();
  }

  static void _logSummary(String id, _PerfTrace perf, {String label = 'Performance'}) {
    final summary = perf._summary();
    if (summary.isNotEmpty) {
      // Use LogManager.summaryTag instead of hardcoded ':'
      appLogger.d('$label ${LogManager.summaryTag}$summary');
    }
  }

  static void _logError(String id, _PerfTrace perf) {
    final summary = perf._summary();
    // Use LogManager.termTag for identifying termination due to error
    appLogger.d('${LogManager.termTag}.${summary.isNotEmpty ? summary : ""}');
  }
}

class _ZonePageWrapper extends StatelessWidget {
  final String id;
  final _PerfTrace perf;
  final Widget Function() builder;

  const _ZonePageWrapper({required this.id, required this.perf, required this.builder});

  @override
  Widget build(BuildContext context) {
    return runZoned(() {
      final pageZone = Zone.current;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageZone.run(() {
          perf._mark('First Frame Rendered');
          ZoneManager._logSummary(id, perf, label: 'Page Render');
        });
      });

      return builder();
    }, zoneValues: {ZoneManager._traceKey: id, ZoneManager._perfKey: perf});
  }
}

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
