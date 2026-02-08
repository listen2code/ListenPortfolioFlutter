import 'package:flutter/material.dart';
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

  static void addLog(String message, {LogLevel level = LogLevel.info}) {
    if (_logs.length >= _maxLogs) {
      _logs.removeAt(0);
    }
    _logs.add(LogEntry(timestamp: DateTime.now(), level: level, message: message));
  }

  static List<LogEntry> get logs => List.unmodifiable(_logs);

  static void clear() {
    _logs.clear();
  }

  static String getAllLogsAsText() {
    return _logs.map((e) => '[${e.formattedTime}] [${e.level.name.toUpperCase()}] ${e.message}').join('\n');
  }
}
