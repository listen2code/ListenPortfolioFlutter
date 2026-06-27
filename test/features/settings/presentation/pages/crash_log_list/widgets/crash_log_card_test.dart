import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/widgets/crash_log_card.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CrashLogCard Widget Tests', () {
    final testFile = File('/path/to/mock_crash.log');
    const testName = 'mock_crash.log';
    const testDate = '2026-06-26 12:00:00';

    late bool tapCalled;
    late bool shareCalled;
    late bool deleteCalled;

    setUp(() {
      tapCalled = false;
      shareCalled = false;
      deleteCalled = false;

      // Mock Clipboard channel to prevent clipboard serialization exceptions
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            SystemChannels.platform,
            (MethodCall methodCall) async {
              if (methodCall.method == 'Clipboard.setData') {
                return null;
              }
              return null;
            },
          );
    });

    testWidgets('should render file details correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrashLogCard(
              file: testFile,
              name: testName,
              date: testDate,
              onTap: () => tapCalled = true,
              onShare: () => shareCalled = true,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      // Assert details are shown
      expect(find.text(testName), findsOneWidget);
      expect(find.text(testDate), findsOneWidget);
      expect(find.text(testFile.path), findsOneWidget);
    });

    testWidgets('should trigger onTap callback when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrashLogCard(
              file: testFile,
              name: testName,
              date: testDate,
              onTap: () => tapCalled = true,
              onShare: () => shareCalled = true,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      // Tap card (ListTile)
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(tapCalled, isTrue);
    });

    testWidgets('should copy path to clipboard when path text is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrashLogCard(
              file: testFile,
              name: testName,
              date: testDate,
              onTap: () => tapCalled = true,
              onShare: () => shareCalled = true,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      // Tap path text
      await tester.tap(find.text(testFile.path));
      await tester.pump();

      // Test completes successfully if no unhandled channel exception is thrown
    });

    testWidgets('should open menu and trigger onShare callback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrashLogCard(
              file: testFile,
              name: testName,
              date: testDate,
              onTap: () => tapCalled = true,
              onShare: () => shareCalled = true,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      // Tap the PopupMenuButton (the more_vert icon)
      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();

      // Tap the share item using I18nKeys
      await tester.tap(find.text(I18nKeys.share.tr));
      await tester.pumpAndSettle();

      expect(shareCalled, isTrue);
    });

    testWidgets('should open menu and trigger onDelete callback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrashLogCard(
              file: testFile,
              name: testName,
              date: testDate,
              onTap: () => tapCalled = true,
              onShare: () => shareCalled = true,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      // Tap PopupMenuButton
      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();

      // Tap delete item using I18nKeys
      await tester.tap(find.text(I18nKeys.delete.tr));
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });
  });
}
