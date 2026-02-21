import 'dart:async';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// Manages data stored in the current [Zone].
/// This handles both distributed tracing (Trace ID) and request cancellation (CancelToken).
class ZoneManager {
  ZoneManager._();

  static const Symbol _traceKey = Symbol('trace_id_key');

  /// Public key for Dio CancelToken to be used in zoneValues map.
  static const Symbol _cancelTokenKey = Symbol('dio_cancel_token_key');

  /// Gets the current Trace ID from the Zone.
  static String get currentTraceId => Zone.current[_traceKey] ?? 'no-trace-id';

  /// Gets the current [CancelToken] from the Zone.
  static CancelToken? get currentCancelToken => Zone.current[_cancelTokenKey];

  /// Runs the [body] in a new Zone with a Trace ID and optional additional [zoneValues].
  static T run<T>(
    T Function() body, {
    String? traceId,
    CancelToken? cancelToken,
    Map<Object?, Object?>? zoneValues,
  }) {
    // Use UUID V4 for high uniqueness and distributed tracing standards.
    final id = traceId ?? const Uuid().v4();
    return runZoned(body, zoneValues: {_traceKey: id, _cancelTokenKey: cancelToken, ...?zoneValues});
  }
}
