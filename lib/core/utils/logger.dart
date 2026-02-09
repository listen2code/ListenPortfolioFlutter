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
  output: MultiOutput([ConsoleOutput(), LogManagerOutput()]),
);

/// Logger for production builds with minimal output
final productionLogger = Logger(printer: SimplePrinter(), level: Level.warning);

class LogManagerOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      LogManager.addLog(line, level: _convertLevel(event.level));
    }
  }

  LogLevel _convertLevel(Level level) {
    switch (level) {
      case Level.debug:
        return LogLevel.debug;
      case Level.error:
        return LogLevel.error;
      case Level.warning:
        return LogLevel.warning;
      default:
        return LogLevel.info;
    }
  }
}
