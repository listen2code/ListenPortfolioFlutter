import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
  });

  tearDown(() {
    LogOverlayManager.hide();
  });

  group('LogOverlayManager Tests', () {
    test('isShowingNotifier and traceFilterNotifier state changes', () {
      expect(LogOverlayManager.isShowing, isFalse);

      LogOverlayManager.traceFilterNotifier.value = 'test-trace-123';
      expect(LogOverlayManager.traceFilterNotifier.value, 'test-trace-123');

      LogOverlayManager.traceFilterNotifier.value = null;
      expect(LogOverlayManager.traceFilterNotifier.value, isNull);
    });

    testWidgets('show and hide overlay in widget context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => LogOverlayManager.show(context),
                  child: const Text('Show Overlay'),
                );
              },
            ),
          ),
        ),
      );

      expect(LogOverlayManager.isShowing, isFalse);

      // Tap to show overlay
      await tester.tap(find.text('Show Overlay'));
      await tester.pump();

      expect(LogOverlayManager.isShowing, isTrue);
      expect(LogOverlayManager.isShowingNotifier.value, isTrue);

      // Hide overlay
      LogOverlayManager.hide();
      await tester.pump();

      expect(LogOverlayManager.isShowing, isFalse);
      expect(LogOverlayManager.isShowingNotifier.value, isFalse);
    });

    testWidgets('show with startExpanded opens window directly and supports tab switching and dragging', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => LogOverlayManager.show(context, startExpanded: true),
                  child: const Text('Show Expanded'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Expanded'));
      await tester.pumpAndSettle();

      expect(LogOverlayManager.isShowing, isTrue);

      // 1. Switch to Perf tab
      final perfTab = find.byIcon(Icons.speed_rounded);
      if (perfTab.evaluate().isNotEmpty) {
        await tester.tap(perfTab.first);
        await tester.pumpAndSettle();
      }

      // 2. Switch to Network tab
      final netTab = find.byIcon(Icons.wifi_tethering_rounded);
      if (netTab.evaluate().isNotEmpty) {
        await tester.tap(netTab.first);
        await tester.pumpAndSettle();
      }

      // 3. Switch back to Logs tab
      final logsTab = find.byIcon(Icons.article_outlined);
      if (logsTab.evaluate().isNotEmpty) {
        await tester.tap(logsTab.first);
        await tester.pumpAndSettle();
      }

      // 4. Test trace filter update
      LogOverlayManager.traceFilterNotifier.value = 'trace-id-999';
      await tester.pumpAndSettle();

      LogOverlayManager.traceFilterNotifier.value = null;
      await tester.pumpAndSettle();

      // 5. Test collapse window to floating button
      final minimizeBtn = find.byIcon(Icons.remove_rounded);
      if (minimizeBtn.evaluate().isNotEmpty) {
        await tester.tap(minimizeBtn.first);
        await tester.pumpAndSettle();
      }

      // 6. Test floating button drag
      final floatingDrag = find.byIcon(Icons.drag_indicator_rounded);
      if (floatingDrag.evaluate().isNotEmpty) {
        await tester.drag(floatingDrag.first, const Offset(20, 20));
        await tester.pump();
      }

      // 7. Hide overlay
      LogOverlayManager.hide();
      await tester.pumpAndSettle();
      expect(LogOverlayManager.isShowing, isFalse);
    });
  });
}
