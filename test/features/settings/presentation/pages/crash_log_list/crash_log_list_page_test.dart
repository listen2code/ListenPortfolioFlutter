import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_page.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: CrashLogListPage(),
      ),
    );
  }

  group('CrashLogListPage Widget Tests', () {
    testWidgets('should render app bar actions and empty state', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(I18nKeys.crashReports.tr), findsOneWidget);
      expect(find.byIcon(Icons.flash_on_rounded), findsOneWidget);
      expect(find.byIcon(Icons.delete_sweep_rounded), findsOneWidget);
    });
  });
}
