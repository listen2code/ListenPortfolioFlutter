import 'dart:async';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:listen_core/core.dart';

class MockFrameTiming extends Mock implements FrameTiming {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FramePhase.vsyncStart);
  });

  group('FrameMonitor Tests', () {
    late FrameMonitor monitor;

    setUp(() {
      monitor = FrameMonitor.instance;
      monitor.stop();
    });

    tearDown(() {
      monitor.stop();
    });

    test('FrameMonitor start / stop updates running status', () {
      expect(monitor.snapshot.value, isNull);
      
      monitor.start();
      expect(monitor.snapshot.value, isNotNull);
      expect(monitor.snapshot.value!.fps, equals(60.0));
      expect(monitor.snapshot.value!.jankCount, equals(0));

      monitor.stop();
    });

    test('FrameMonitor ignores warm-up frames and processes subsequent ones', () {
      monitor.start();

      // Feed 5 warm-up frames (should be ignored)
      for (int i = 0; i < 5; i++) {
        final timing = MockFrameTiming();
        when(() => timing.buildDuration).thenReturn(const Duration(milliseconds: 5));
        when(() => timing.rasterDuration).thenReturn(const Duration(milliseconds: 5));
        when(() => timing.totalSpan).thenReturn(const Duration(milliseconds: 10));
        when(() => timing.timestampInMicroseconds(FramePhase.vsyncStart)).thenReturn(i * 16670);
        monitor.handleTimingsForTest([timing]);
      }

      expect(monitor.snapshot.value!.recentFrames.length, equals(0));

      // Feed the 6th frame (should be captured)
      final timing6 = MockFrameTiming();
      when(() => timing6.buildDuration).thenReturn(const Duration(milliseconds: 4));
      when(() => timing6.rasterDuration).thenReturn(const Duration(milliseconds: 4));
      when(() => timing6.totalSpan).thenReturn(const Duration(milliseconds: 8));
      when(() => timing6.timestampInMicroseconds(FramePhase.vsyncStart)).thenReturn(5 * 16670);
      
      monitor.handleTimingsForTest([timing6]);

      expect(monitor.snapshot.value!.recentFrames.length, equals(1));
      expect(monitor.snapshot.value!.recentFrames[0].buildDurationUs, equals(4000));
    });

    test('Jank and Severe Jank detection using default budget', () {
      monitor.start();

      // Bypass 5 warm-up frames
      for (int i = 0; i < 5; i++) {
        final timing = MockFrameTiming();
        when(() => timing.buildDuration).thenReturn(const Duration(milliseconds: 2));
        when(() => timing.rasterDuration).thenReturn(const Duration(milliseconds: 2));
        when(() => timing.totalSpan).thenReturn(const Duration(milliseconds: 4));
        when(() => timing.timestampInMicroseconds(FramePhase.vsyncStart)).thenReturn(i * 16670);
        monitor.handleTimingsForTest([timing]);
      }

      // 6th frame: Normal frame (8ms < 16.6ms)
      final normalTiming = MockFrameTiming();
      when(() => normalTiming.buildDuration).thenReturn(const Duration(milliseconds: 4));
      when(() => normalTiming.rasterDuration).thenReturn(const Duration(milliseconds: 4));
      when(() => normalTiming.totalSpan).thenReturn(const Duration(milliseconds: 8));
      when(() => normalTiming.timestampInMicroseconds(FramePhase.vsyncStart)).thenReturn(5 * 16670);
      monitor.handleTimingsForTest([normalTiming]);

      expect(monitor.snapshot.value!.jankCount, equals(0));
      expect(monitor.snapshot.value!.severeJankCount, equals(0));

      // 7th frame: Jank frame (20ms > 16.6ms, but < 33.3ms)
      final jankTiming = MockFrameTiming();
      when(() => jankTiming.buildDuration).thenReturn(const Duration(milliseconds: 10));
      when(() => jankTiming.rasterDuration).thenReturn(const Duration(milliseconds: 10));
      when(() => jankTiming.totalSpan).thenReturn(const Duration(milliseconds: 20));
      when(() => jankTiming.timestampInMicroseconds(FramePhase.vsyncStart)).thenReturn(6 * 16670);
      monitor.handleTimingsForTest([jankTiming]);

      expect(monitor.snapshot.value!.jankCount, equals(1));
      expect(monitor.snapshot.value!.severeJankCount, equals(0));

      // 8th frame: Severe Jank frame (40ms > 33.3ms)
      final severeJankTiming = MockFrameTiming();
      when(() => severeJankTiming.buildDuration).thenReturn(const Duration(milliseconds: 20));
      when(() => severeJankTiming.rasterDuration).thenReturn(const Duration(milliseconds: 20));
      when(() => severeJankTiming.totalSpan).thenReturn(const Duration(milliseconds: 40));
      when(() => severeJankTiming.timestampInMicroseconds(FramePhase.vsyncStart)).thenReturn(7 * 16670);
      monitor.handleTimingsForTest([severeJankTiming]);

      expect(monitor.snapshot.value!.jankCount, equals(2));
      expect(monitor.snapshot.value!.severeJankCount, equals(1));
      expect(monitor.snapshot.value!.worstFrameUs, equals(40000));
    });

    test('Adaptive vsync budget for high-refresh rates (120Hz)', () {
      monitor.start();

      // Bypass 5 warm-up frames
      for (int i = 0; i < 5; i++) {
        final timing = MockFrameTiming();
        when(() => timing.buildDuration).thenReturn(const Duration(milliseconds: 2));
        when(() => timing.rasterDuration).thenReturn(const Duration(milliseconds: 2));
        when(() => timing.totalSpan).thenReturn(const Duration(milliseconds: 4));
        when(() => timing.timestampInMicroseconds(FramePhase.vsyncStart)).thenReturn(i * 16670);
        monitor.handleTimingsForTest([timing]);
      }

      // Feed a frame at vsync = 100,000us
      final t1 = MockFrameTiming();
      when(() => t1.buildDuration).thenReturn(const Duration(milliseconds: 4));
      when(() => t1.rasterDuration).thenReturn(const Duration(milliseconds: 4));
      when(() => t1.totalSpan).thenReturn(const Duration(milliseconds: 8));
      when(() => t1.timestampInMicroseconds(FramePhase.vsyncStart)).thenReturn(100000);
      monitor.handleTimingsForTest([t1]);

      // Feed next frame at vsync = 108,333us (8.33ms delta, indicating 120Hz)
      // This frame has totalSpan = 10ms, which is larger than the 8.33ms budget
      final t2 = MockFrameTiming();
      when(() => t2.buildDuration).thenReturn(const Duration(milliseconds: 5));
      when(() => t2.rasterDuration).thenReturn(const Duration(milliseconds: 5));
      when(() => t2.totalSpan).thenReturn(const Duration(milliseconds: 10));
      when(() => t2.timestampInMicroseconds(FramePhase.vsyncStart)).thenReturn(108333);
      monitor.handleTimingsForTest([t2]);

      final lastFrame = monitor.snapshot.value!.recentFrames[monitor.snapshot.value!.recentFrames.length - 1];
      expect(lastFrame.vsyncBudgetUs, closeTo(8333, 100)); // Should adapt budget close to 8.33ms
      expect(lastFrame.isJank, isTrue); // 10ms > 8.33ms budget, so it is a Jank
    });
  });

  group('PerfTraceStore Tests', () {
    late PerfTraceStore store;

    setUp(() {
      store = PerfTraceStore.instance;
      store.clear();
    });

    tearDown(() {
      store.clear();
    });

    test('PerfTraceStore records traces and triggers notifier', () {
      expect(store.traces.value.isEmpty, isTrue);

      store.record(
        traceId: 'test-trace-id',
        label: 'Intent',
        name: 'LoadData',
        stages: [(name: 'Init', duration: 10), (name: 'Finish', duration: 15)],
        totalMs: 25,
      );

      expect(store.traces.value.length, equals(1));
      final entry = store.traces.value[0];
      expect(entry.traceId, equals('test-trace-id'));
      expect(entry.name, equals('LoadData'));
      expect(entry.stages.length, equals(2));
      expect(entry.stages[0].name, equals('Init'));
      expect(entry.stages[0].durationMs, equals(10));
      expect(entry.totalMs, equals(25));
    });

    test('PerfTraceStore maintains historical list bounds', () {
      for (int i = 0; i < 210; i++) {
        store.record(
          traceId: 'id-$i',
          label: 'Intent',
          name: 'Name-$i',
          stages: [],
          totalMs: i,
        );
      }

      // Should limit to 200 items
      expect(store.traces.value.length, equals(200));
      // Oldest items (0-9) should be removed, first item in list should be index 10
      expect(store.traces.value.first.traceId, equals('id-10'));
      expect(store.traces.value.last.traceId, equals('id-209'));
    });

    test('ZoneManager broadcasts and PerfTraceStore automatically collects records', () async {
      // ZoneManager.runPage will automatically trigger postFrameCallback and emit performance metrics.
      // For unit tests, we can directly trigger ZoneManager's onPerfTrace stream manually to verify 
      // the subscription listener behaves.
      final completer = Completer<void>();
      
      store.traces.addListener(() {
        if (store.traces.value.isNotEmpty) {
          completer.complete();
        }
      });

      // Run code inside ZoneManager.run to trigger performance summary output
      ZoneManager.run(() {
        ZoneManager.mark('Start');
        ZoneManager.mark('Query');
      }, traceId: 'test-zone-trace');

      // Wait for async Stream delivery
      await completer.future.timeout(const Duration(seconds: 2));

      expect(store.traces.value.isNotEmpty, isTrue);
      expect(store.traces.value.any((e) => e.traceId == 'test-zone-trace'), isTrue);
    });
  });
}
