import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/fault_injection_page.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/widgets/fault_category_selector.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/widgets/fault_execution_console.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/widgets/fault_scenario_card.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
  });

  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: FaultInjectionPage(),
      ),
    );
  }

  group('FaultInjectionPage Widget Tests', () {
    testWidgets('renders FaultInjectionPage with all sub-components and handles reset', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(I18nKeys.faultInjectionPlayground.tr), findsOneWidget);
      expect(find.byType(FaultCategorySelector), findsOneWidget);
      expect(find.byType(FaultScenarioCard), findsWidgets);
      expect(find.byType(FaultExecutionConsole), findsOneWidget);
      expect(find.byIcon(Icons.restart_alt_rounded), findsOneWidget);

      // Tap reset all
      await tester.tap(find.byIcon(Icons.restart_alt_rounded));
      await tester.pumpAndSettle();
    });
  });
}
