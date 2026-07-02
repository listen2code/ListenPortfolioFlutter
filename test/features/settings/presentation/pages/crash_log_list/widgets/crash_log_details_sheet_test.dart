import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/widgets/crash_log_details_sheet.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CrashLogDetailsSheet Widget Tests', () {
    const testFileName = 'crash_2026-06-26.log';
    const testContent = '''
=== Crash Log ===
[2026-06-26 12:00:00] [ERROR] Something went wrong
[2026-06-26 12:00:01] [WARNING] Disk space low
[2026-06-26 12:00:02] [INFO] App started
[2026-06-26 12:00:03] [DEBUG] API request sent
Error: NullPointerException
Random log detail line
''';

    setUp(() {
      // Mock Clipboard channel
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

    testWidgets('should render correctly and display content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrashLogDetailsSheet(
              content: testContent,
              fileName: testFileName,
            ),
          ),
        ),
      );

      // Verify file name is shown
      expect(find.text(testFileName), findsOneWidget);

      // Verify log contents are shown in rich text formatting
      // Since it's rich text, find.textContaining works for SelectableText.rich
      expect(find.textContaining('Something went wrong'), findsOneWidget);
      expect(find.textContaining('Disk space low'), findsOneWidget);
      expect(find.textContaining('App started'), findsOneWidget);
      expect(find.textContaining('API request sent'), findsOneWidget);
      expect(find.textContaining('NullPointerException'), findsOneWidget);
      expect(find.textContaining('Random log detail line'), findsOneWidget);
    });

    testWidgets('should copy content to clipboard when copy button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrashLogDetailsSheet(
              content: testContent,
              fileName: testFileName,
            ),
          ),
        ),
      );

      // Find copy button by its icon
      final copyButton = find.byWidgetPredicate(
        (widget) => widget is CommonIconButton && widget.icon is Icon && (widget.icon as Icon).icon == Icons.copy_all_rounded,
      );
      
      expect(copyButton, findsOneWidget);
      await tester.tap(copyButton);
      await tester.pump();

      // Test completes successfully if no exception is thrown
    });
  });
}
