import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
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

    testWidgets('show with startExpanded opens window directly', (WidgetTester tester) async {
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

      LogOverlayManager.hide();
      await tester.pumpAndSettle();
      expect(LogOverlayManager.isShowing, isFalse);
    });
  });
}
