import 'package:listen_portfolio_flutter/core/utils/log_manager.dart';
import 'package:logger/logger.dart';

/// Global logger instance for the application
/// Provides consistent logging across all layers
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
    ConsoleOutput(), // Normal logs with boxes in IDE console
    _LogManagerOutput(), // Cleaned logs for the App's UI LogViewer
  ]),
);

/// Custom output to feed the App's internal LogManager
class _LogManagerOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Use the original message instead of formatted lines to avoid box characters
    final message = event.origin.message.toString();
    
    if (message.isNotEmpty) {
      LogManager.addLog(message, level: _mapLevel(event.level));
    }

    // Also capture error information if present
    if (event.origin.error != null) {
      LogManager.addLog('Error: ${event.origin.error}', level: LogLevel.error);
    }
  }

  LogLevel _mapLevel(Level level) {
    if (level == Level.error) return LogLevel.error;
    if (level == Level.warning) return LogLevel.warning;
    if (level == Level.debug) return LogLevel.debug;
    return LogLevel.info;
  }
}

/// Logger for production builds with minimal output
final productionLogger = Logger(printer: SimplePrinter(), level: Level.warning);
