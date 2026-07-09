import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listen_core/core.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    LaunchMonitor.resetState();
    LaunchMonitor.clearHistory();
  });

  tearDown(() {
    LaunchMonitor.resetState();
    LaunchMonitor.clearHistory();
  });

  group('LaunchMonitor Tests', () {
    test('should record timestamps and compile report correctly', () async {
      expect(LaunchMonitor.latestReport.value, isNull);

      LaunchMonitor.recordMainStart();
      await Future.delayed(const Duration(milliseconds: 10));
      LaunchMonitor.recordInitStart();
      await Future.delayed(const Duration(milliseconds: 10));
      LaunchMonitor.recordInitEnd();
      await Future.delayed(const Duration(milliseconds: 10));
      LaunchMonitor.recordFirstFrame();

      final report = LaunchMonitor.latestReport.value;
      expect(report, isNotNull);
      expect(report!.coldBootMs, greaterThanOrEqualTo(0));
      expect(report.initMs, greaterThanOrEqualTo(0));
      expect(report.renderMs, greaterThanOrEqualTo(0));
      expect(report.totalMs, greaterThanOrEqualTo(report.coldBootMs + report.initMs + report.renderMs));
      expect(report.isRegression, isFalse);
    });

    test('should support historical record persistence and FIFO limit', () async {
      for (int i = 0; i < 60; i++) {
        LaunchMonitor.resetState();
        LaunchMonitor.recordMainStart();
        LaunchMonitor.recordInitStart();
        LaunchMonitor.recordInitEnd();
        LaunchMonitor.recordFirstFrame();
        await Future.delayed(Duration.zero);
      }

      final history = LaunchMonitor.getHistory();
      expect(history.length, equals(50)); // max limit is 50
    });

    test('should detect regression when launch time is significantly longer than average', () async {
      // Build 3 baseline healthy records
      for (int i = 0; i < 3; i++) {
        LaunchMonitor.resetState();
        // Setup mock internal values manually or via controlled delays
        // To make it deterministic, we can simulate the records by writing directly to SpUtil
        // wait, we can just compile them via resetState and mock values if we could, 
        // but since SpUtil stores it, we can write manually to SpUtil to establish baseline!
      }

      // Let's write 3 baseline launch reports (100ms total each) to SpUtil
      final baselineReports = List.generate(3, (idx) => LaunchReport(
        timestamp: DateTime.now().subtract(Duration(minutes: idx + 1)),
        coldBootMs: 30,
        initMs: 40,
        renderMs: 30,
        totalMs: 100,
        isRegression: false,
      ));

      importHistory(baselineReports);

      // Now compile a slow launch of 300ms (average was 100ms, 300ms exceeds 1.25x avg and is 150ms higher)
      LaunchMonitor.resetState();
      // Since LaunchMonitor uses DateTime.now().millisecondsSinceEpoch, we can mock it by setting values
      // Wait, we can't set private fields, but we can call:
      LaunchMonitor.recordMainStart();
      await Future.delayed(const Duration(milliseconds: 300));
      LaunchMonitor.recordFirstFrame();

      final report = LaunchMonitor.latestReport.value;
      expect(report, isNotNull);
      expect(report!.isRegression, isTrue);
      expect(report.regressionAmountMs, greaterThanOrEqualTo(150));
    });
  });
}

void importHistory(List<LaunchReport> reports) {
  importRawHistory(reports.map((r) => r.toJson()).toList());
}

void importRawHistory(List<Map<String, dynamic>> jsons) {
  final List<String> encoded = jsons.map<String>((j) => jsonEncode(j)).toList();
  SpUtil.put('launch_history', encoded);
}
