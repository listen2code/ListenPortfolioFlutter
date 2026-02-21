import 'package:flutter/foundation.dart';
import 'package:listen_portfolio_flutter/core/utils/log_manager.dart';
import 'package:listen_portfolio_flutter/core/utils/zone_manager.dart';
import 'package:logger/logger.dart';

/// Global logger instance providing consistent logging and in-app log management.
/// Configured to capture logs even in Release builds for the internal UI viewer.
final appLogger = Logger(
  // Use ProductionFilter to ensure logs are processed in Release builds.
  filter: ProductionFilter(),
  printer: _TracePrinter(
    PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  ),
  output: MultiOutput([
    // Only output to system console in Debug mode to protect privacy and performance
    if (kDebugMode) ConsoleOutput(),
    // Always pipe logs to internal LogManager for the App's log viewer
    _LogManagerOutput(),
  ]),
);

/// A decorator printer that prepends the current Trace ID to every log message.
class _TracePrinter extends LogPrinter {
  final LogPrinter _inner;

  _TracePrinter(this._inner);

  @override
  List<String> log(LogEvent event) {
    final traceId = ZoneManager.currentTraceId;
    // Prepend traceId to the message. If it's a multi-line object, it will be stringified.
    final newMessage = '[$traceId] ${event.message}';

    return _inner.log(
      LogEvent(event.level, newMessage, error: event.error, stackTrace: event.stackTrace, time: event.time),
    );
  }
}

/// Custom output handler to populate the App's LogManager with formatted data.
class _LogManagerOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final traceId = ZoneManager.currentTraceId;
    // Extract message and prepend Trace ID for the internal UI viewer
    final rawMessage = event.origin.message.toString();
    final message = '[$traceId]\n $rawMessage\n';

    if (rawMessage.isNotEmpty) {
      LogManager.addLog(message, level: _mapLevel(event.level));
    }

    // Capture explicit error object details if available
    if (event.origin.error != null) {
      LogManager.addLog('[$traceId] Error Detail: ${event.origin.error}', level: LogLevel.error);
    }
  }

  // Convert external Logger levels to internal LogManager levels
  LogLevel _mapLevel(Level level) {
    if (level == Level.error || level == Level.fatal) return LogLevel.error;
    if (level == Level.warning) return LogLevel.warning;
    if (level == Level.debug || level == Level.trace) return LogLevel.debug;
    return LogLevel.info;
  }
}
