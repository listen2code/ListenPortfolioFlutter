import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listen_core/core.dart';

void main() {
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  const tempDocsDir = 'temp_crash_docs';

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Mock path_provider platform channel
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return tempDocsDir;
      }
      return null;
    });
  });

  setUp(() async {
    // Mock shared preferences
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    
    // Ensure temporary documents directory is clean
    final dir = Directory(tempDocsDir);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    dir.createSync(recursive: true);
  });

  tearDown(() {
    // Clean up temporary documents directory
    final dir = Directory(tempDocsDir);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  });

  group('CrashManager Tests', () {
    test('init sets SafeModeConfig configuration', () {
      bool resetCalled = false;
      final config = SafeModeConfig(
        rapidCrashThreshold: 2,
        timeWindow: const Duration(seconds: 10),
        onReset: () async {
          resetCalled = true;
        },
      );

      CrashManager.init(config);
      // Indirectly verify configuration is set via checking functionality
    });

    test('saveCrashLog saves log correctly to file', () async {
      final error = Exception('Simulated test crash error');
      final stack = StackTrace.current;

      final path = await CrashManager.saveCrashLog(error, stack);
      expect(path, isNotNull);

      final file = File(path!);
      expect(file.existsSync(), true);

      final content = file.readAsStringSync();
      expect(content.contains('=== CRASH REPORT ==='), true);
      expect(content.contains('Simulated test crash error'), true);
      expect(content.contains('=== STACK TRACE ==='), true);
    });

    test('getSavedCrashLogs lists logs in descending order', () async {
      final error1 = Exception('Crash 1');
      final error2 = Exception('Crash 2');
      final stack = StackTrace.current;

      // Ensure file names get different timestamps by waiting a bit if needed, 
      // or calling consecutively since DateFormat has seconds resolution
      await CrashManager.saveCrashLog(error1, stack);
      // Wait briefly to change seconds timestamp
      await Future.delayed(const Duration(seconds: 1));
      await CrashManager.saveCrashLog(error2, stack);

      final logs = await CrashManager.getSavedCrashLogs();
      expect(logs.length, 2);
      expect(logs[0].path.compareTo(logs[1].path) > 0, true, reason: 'Logs should be sorted in descending order');
    });

    test('deleteCrashLog and deleteAllCrashLogs clean files properly', () async {
      final error = Exception('Crash log to delete');
      final stack = StackTrace.current;

      final path = await CrashManager.saveCrashLog(error, stack);
      expect(path, isNotNull);

      var logs = await CrashManager.getSavedCrashLogs();
      expect(logs.length, 1);

      await CrashManager.deleteCrashLog(logs[0]);
      logs = await CrashManager.getSavedCrashLogs();
      expect(logs.isEmpty, true);

      // Re-create and delete all
      await CrashManager.saveCrashLog(error, stack);
      await CrashManager.deleteAllCrashLogs();
      logs = await CrashManager.getSavedCrashLogs();
      expect(logs.isEmpty, true);
    });

    test('Safe Mode triggers onReset when rapid crash threshold is exceeded', () async {
      int resetCallCount = 0;
      final config = SafeModeConfig(
        rapidCrashThreshold: 3,
        timeWindow: const Duration(seconds: 5),
        onReset: () async {
          resetCallCount++;
        },
      );

      CrashManager.init(config);

      final error = Exception('Safe Mode Trigger Exception');
      final stack = StackTrace.current;

      // First crash
      await CrashManager.saveCrashLog(error, stack);
      expect(resetCallCount, 0);

      // Second crash
      await CrashManager.saveCrashLog(error, stack);
      expect(resetCallCount, 0);

      // Third crash - should trigger reset
      await CrashManager.saveCrashLog(error, stack);
      expect(resetCallCount, 1);
    });

    test('uploadCrashLog completes successfully', () async {
      final file = File('$tempDocsDir/fake_report.log');
      file.writeAsStringSync('Fake report data');

      final result = await CrashManager.uploadCrashLog(file);
      expect(result, true);
    });
  });
}
