import 'package:flutter/foundation.dart';
import 'package:listen_portfolio_flutter/core/utils/log_manager.dart';
import 'package:logger/logger.dart';

/// Global logger instance providing consistent logging and in-app log management.
/// Configured to capture logs even in Release builds for the internal UI viewer.
final appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
  output: MultiOutput([
    // Only output to system console in Debug mode to protect privacy and performance
    if (kDebugMode) ConsoleOutput(),
    // Always pipe logs to internal LogManager for the App's log viewer
    _LogManagerOutput(),
  ]),
);

/// Custom output handler to populate the App's LogManager with formatted data.
class _LogManagerOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Extract raw message to avoid ANSI escape sequences in the UI
    final message = event.origin.message.toString();
    
    if (message.isNotEmpty) {
      LogManager.addLog(message, level: _mapLevel(event.level));
    }

    // Capture explicit error object details if available
    if (event.origin.error != null) {
      LogManager.addLog('Error Detail: ${event.origin.error}', level: LogLevel.error);
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
