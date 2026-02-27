import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:path_provider/path_provider.dart';

class CrashManager {
  CrashManager._();

  static DateTime? _scheduledCrashTime;

  /// Saves current logs and error details to a local file.
  static Future<String?> saveCrashLog(Object error, StackTrace stack) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final File file = File('${directory.path}/crash_$timestamp.log');

      final StringBuffer buffer = StringBuffer();
      buffer.writeln('=== CRASH REPORT ===');
      buffer.writeln('Time: ${DateTime.now()}');

      if (error is FlutterErrorDetails) {
        // Extract rich context from Flutter framework errors
        buffer.writeln('Summary: ${error.exceptionAsString()}');
        buffer.writeln('Context: ${error.context}');
        buffer.writeln('Library: ${error.library}');
        buffer.writeln('\n=== FLUTTER DETAILS ===\n$error');
      } else {
        buffer.writeln('Error: $error');
      }

      buffer.writeln('\n=== STACK TRACE ===\n$stack');
      buffer.writeln('\n=== RECENT LOGS ===');
      buffer.writeln(LogManager.getAllLogsAsText(reversed: true));

      await file.writeAsString(buffer.toString());

      appLogger.i('Crash log saved to: ${file.path}');
      return file.path;
    } catch (e) {
      appLogger.e('Failed to save crash log: $e');
      return null;
    }
  }

  /// Lists all saved crash logs.
  static Future<List<File>> getSavedCrashLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = directory.listSync();
      final logs = files
          .whereType<File>()
          .where((f) => f.path.contains('crash_') && f.path.endsWith('.log'))
          .toList();
      logs.sort((a, b) => b.path.compareTo(a.path));
      return logs;
    } catch (_) {
      return [];
    }
  }

  /// Deletes a crash log file.
  static Future<void> deleteCrashLog(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Simulates an upload to the server.
  static Future<bool> uploadCrashLog(File file) async {
    await Future.delayed(const Duration(seconds: 2));
    appLogger.i('Uploaded crash log: ${file.path}');
    return true;
  }

  /// Schedules a crash to occur after 10-20 seconds.
  /// The crash will be injected into the next ViewModel dispatch.
  static void scheduleRandomCrash() {
    final random = Random();
    final delaySeconds = 10 + random.nextInt(11); // 10 to 20 seconds
    _scheduledCrashTime = DateTime.now().add(Duration(seconds: delaySeconds));

    appLogger.w(
      'CRASH TEST: Exception scheduled to trigger during any dispatch after $delaySeconds seconds.',
    );
  }

  /// Internal: Checks if a scheduled crash is due and throws if it is.
  static void checkAndTriggerInjectedCrash() {
    if (_scheduledCrashTime != null && DateTime.now().isAfter(_scheduledCrashTime!)) {
      _scheduledCrashTime = null; // Reset

      final random = Random();
      final crashTypes = [
        () => throw Exception('Injected: UI interaction interrupted by simulated core failure'),
        () => throw StateError('Injected: viewModel state corrupted during intent processing'),
        () => throw ArgumentError('Injected: Unexpected null value in critical business logic'),
        () => throw const FormatException('Injected: Corrupted response data from simulated network'),
      ];

      crashTypes[random.nextInt(crashTypes.length)]();
    }
  }
}
