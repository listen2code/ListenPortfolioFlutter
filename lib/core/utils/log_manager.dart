import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

enum LogLevel { debug, info, warning, error }

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;

  LogEntry({required this.timestamp, required this.level, required this.message});

  String get formattedTime => DateFormat('HH:mm:ss.SSS').format(timestamp);
}

class LogManager {
  static final List<LogEntry> _logs = [];
  static const int _maxLogs = 100;

  // Private ValueNotifier to manage state internally
  static final ValueNotifier<List<LogEntry>> _logNotifier = ValueNotifier([]);

  // Public ValueListenable to allow external widgets to listen without direct modification
  static ValueListenable<List<LogEntry>> get logNotifier => _logNotifier;

  static void addLog(String message, {LogLevel level = LogLevel.info}) {
    if (_logs.length >= _maxLogs) {
      _logs.removeAt(0);
    }
    _logs.add(LogEntry(timestamp: DateTime.now(), level: level, message: message));
    
    // Trigger update asynchronously
    refresh();
  }

  static List<LogEntry> get logs => List.unmodifiable(_logs);

  static void clear() {
    _logs.clear();
    // Wrap in microtask to defer UI notifications.
    // This prevents "setState() called when widget tree was locked" errors, 
    // which occur if clear() is triggered during framework-locked phases 
    // like build, layout, or global error handling (e.g., inside FlutterError.onError).
    Future.microtask(() {
      _logNotifier.value = [];
    });
  }

  /// Refreshes the log notifier value to sync with current logs.
  static void refresh() {
    // We use Future.microtask to ensure the ValueNotifier update is asynchronous.
    // When logs are generated during critical phases (Build, Layout, or inside 
    // FlutterError.onError), the framework locks the widget tree and prohibits 
    // immediate UI refreshes. Deferring the update to the next microtask 
    // allows the framework to complete its current task before processing the UI change.
    Future.microtask(() {
      _logNotifier.value = List.from(_logs);
    });
  }

  static String getAllLogsAsText({bool reversed = false}) {
    final logIterable = reversed ? _logs.reversed : _logs;
    return logIterable
        .map((e) => '[${e.formattedTime}] [${e.level.name.toUpperCase()}] ${e.message}')
        .join('\n');
  }
}
