import 'dart:io';

import 'package:intl/intl.dart';
import 'package:listen_portfolio_flutter/core/utils/log_manager.dart';
import 'package:listen_portfolio_flutter/core/utils/logger.dart';
import 'package:path_provider/path_provider.dart';

class CrashManager {
  CrashManager._();

  /// Saves current logs and error details to a local file.
  static Future<String?> saveCrashLog(Object error, StackTrace stack) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final File file = File('${directory.path}/crash_$timestamp.log');

      final StringBuffer buffer = StringBuffer();
      buffer.writeln('=== CRASH REPORT ===');
      buffer.writeln('Time: ${DateTime.now()}');
      buffer.writeln('Error: $error');
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
      return files
          .whereType<File>()
          .where((f) => f.path.contains('crash_') && f.path.endsWith('.log'))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
