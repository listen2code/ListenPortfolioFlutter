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
);

/// Logger for production builds with minimal output
final productionLogger = Logger(
  printer: SimplePrinter(),
  level: Level.warning,
);
