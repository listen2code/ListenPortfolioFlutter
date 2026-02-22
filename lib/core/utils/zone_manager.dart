import 'dart:async';

import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/utils/logger.dart';
import 'package:uuid/uuid.dart';

/// Manages data stored in the current [Zone].
/// This handles distributed tracing (Trace ID) and request cancellation (CancelToken).
class ZoneManager {
  ZoneManager._();

  static const Symbol _traceKey = Symbol('trace_id_key');
  static const Symbol _cancelTokenKey = Symbol('dio_cancel_token_key');

  /// Gets the current Trace ID from the Zone.
  static String get currentTraceId => Zone.current[_traceKey] ?? 'no-trace-id';

  /// Gets the current [CancelToken] from the Zone.
  static CancelToken? get currentCancelToken => Zone.current[_cancelTokenKey];

  /// Runs the [body] in a new Zone with a Trace ID and optional additional [zoneValues].
  ///
  /// If a [traceId] is not provided, it will attempt to inherit from the parent [Zone].
  /// If no parent Trace ID exists, a new UUID V4 will be generated.
  static T run<T>(
    T Function() body, {
    String? traceId,
    CancelToken? cancelToken,
    Map<Object?, Object?>? zoneValues,
  }) {
    // 1. Inherit Trace ID from parent if available, otherwise generate new.
    final String parentId = Zone.current[_traceKey] ?? '';
    final String id = traceId ?? (parentId.isNotEmpty ? parentId : const Uuid().v4());

    return runZoned(body, zoneValues: {_traceKey: id, _cancelTokenKey: ?cancelToken, ...?zoneValues});
  }

  /// Runs the [body] in a protected Zone that catches unhandled asynchronous errors.
  /// Every caught error will be logged with the current Trace ID automatically.
  /// Also measures and logs the execution duration for performance profiling.
  static Future<void> runGuarded(
    FutureOr<void> Function() body, {
    String? traceId,
    CancelToken? cancelToken,
    Map<Object?, Object?>? zoneValues,
    void Function(Object error, StackTrace stack)? onError,
  }) async {
    final String parentId = Zone.current[_traceKey] ?? '';
    final String id = traceId ?? (parentId.isNotEmpty ? parentId : const Uuid().v4());

    return runZonedGuarded(
      () async {
        final stopwatch = Stopwatch()..start();
        try {
          await body();
        } finally {
          stopwatch.stop();
          // Log performance data for monitoring
          appLogger.d('Trace [$id] finished. Total duration: ${stopwatch.elapsedMilliseconds}ms');
        }
      },
      (error, stack) {
        // Automatically associate unhandled async errors with the current Trace Context
        appLogger.e('Unhandled async error in Trace [$id]: $error', error: error, stackTrace: stack);

        // This is the ideal place to hook into crash reporting services like Sentry.
        // Sentry.captureException(error, stackTrace: stack, hint: 'TraceId: $id');

        onError?.call(error, stack);
      },
      zoneValues: {_traceKey: id, _cancelTokenKey: ?cancelToken, ...?zoneValues},
    );
  }
}
