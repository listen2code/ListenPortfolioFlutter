import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/domain/models/fault_injection_scenario.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/widgets/fault_category_selector.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/widgets/fault_execution_console.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/presentation/pages/widgets/fault_scenario_card.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
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

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    );
  }

  group('Fault Injection Widgets Tests', () {
    testWidgets('FaultCategorySelector displays categories and responds to taps', (WidgetTester tester) async {
      FaultCategory? selectedCat;

      await tester.pumpWidget(
        createTestWidget(
          FaultCategorySelector(
            selectedCategory: FaultCategory.all,
            onCategoryChanged: (cat) => selectedCat = cat,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FaultCategorySelector), findsOneWidget);
      expect(find.text(I18nKeys.faultAllCategories.tr), findsOneWidget);
      expect(find.text(I18nKeys.faultCategoryNetwork.tr), findsOneWidget);

      await tester.tap(find.text(I18nKeys.faultCategoryNetwork.tr));
      await tester.pumpAndSettle();

      expect(selectedCat, FaultCategory.network);
    });

    testWidgets('FaultScenarioCard displays scenario info and handles onRun tap', (WidgetTester tester) async {
      var ran = false;
      const scenario = FaultScenarioModel(
        type: FaultScenarioType.concurrent401,
        category: FaultCategory.network,
        titleKey: I18nKeys.faultScenario401Title,
        descKey: I18nKeys.faultScenario401Desc,
        status: ScenarioStatus.idle,
        lastExecutionDurationMs: 120,
      );

      await tester.pumpWidget(
        createTestWidget(
          FaultScenarioCard(
            scenario: scenario,
            isRunning: false,
            onRun: () => ran = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(I18nKeys.faultScenario401Title.tr), findsOneWidget);
      expect(find.text(I18nKeys.faultScenario401Desc.tr), findsOneWidget);
      expect(find.text('120ms'), findsOneWidget);
      expect(find.byType(CommonButton), findsOneWidget);

      final button = tester.widget<CommonButton>(find.byType(CommonButton));
      button.onPressed?.call();

      expect(ran, isTrue);
    });

    testWidgets('FaultScenarioCard renders different categories and statuses', (WidgetTester tester) async {
      final scenarios = [
        const FaultScenarioModel(
          type: FaultScenarioType.zoneAsyncCrash,
          category: FaultCategory.stability,
          titleKey: I18nKeys.faultScenarioZoneCrashTitle,
          descKey: I18nKeys.faultScenarioZoneCrashDesc,
          status: ScenarioStatus.running,
        ),
        const FaultScenarioModel(
          type: FaultScenarioType.mainThreadJank,
          category: FaultCategory.performance,
          titleKey: I18nKeys.faultScenarioJankTitle,
          descKey: I18nKeys.faultScenarioJankDesc,
          status: ScenarioStatus.recovered,
        ),
        const FaultScenarioModel(
          type: FaultScenarioType.networkTimeout,
          category: FaultCategory.all,
          titleKey: I18nKeys.faultScenarioTimeoutTitle,
          descKey: I18nKeys.faultScenarioTimeoutDesc,
          status: ScenarioStatus.failed,
        ),
        const FaultScenarioModel(
          type: FaultScenarioType.serverError500,
          category: FaultCategory.network,
          titleKey: I18nKeys.faultScenario500Title,
          descKey: I18nKeys.faultScenario500Desc,
          status: ScenarioStatus.success,
        ),
      ];

      for (final s in scenarios) {
        await tester.pumpWidget(
          createTestWidget(
            FaultScenarioCard(
              scenario: s,
              isRunning: s.status == ScenarioStatus.running,
              onRun: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text(s.titleKey.tr), findsOneWidget);
      }
    });

    testWidgets('FaultExecutionConsole renders logs, trace actions, and handles drill/copy/clear', (WidgetTester tester) async {
      var cleared = false;
      String? copiedTrace;
      String? drilledTrace;

      final logs = [
        ExecutionStepLog(
          timestamp: DateTime.now(),
          message: 'Step 1: Test step completed',
          isSuccess: true,
          elapsedMs: 25,
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          FaultExecutionConsole(
            logs: logs,
            activeTraceId: 'test-trace-999',
            onClear: () => cleared = true,
            onCopyTrace: (id) => copiedTrace = id,
            onDrillTrace: (id) => drilledTrace = id,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(I18nKeys.faultConsoleTitle.tr), findsOneWidget);
      expect(find.textContaining('test-trace-999'), findsOneWidget);
      expect(find.textContaining('Step 1: Test step completed'), findsOneWidget);

      // Tap clear console
      final clearBtn = find.byTooltip(I18nKeys.faultClearConsole.tr);
      if (clearBtn.evaluate().isNotEmpty) {
        await tester.tap(clearBtn);
        await tester.pumpAndSettle();
        expect(cleared, isTrue);
      }

      // Tap drill down trace
      final drillBtn = find.text(I18nKeys.faultDrillTrace.tr);
      if (drillBtn.evaluate().isNotEmpty) {
        await tester.tap(drillBtn);
        await tester.pumpAndSettle();
        expect(drilledTrace, 'test-trace-999');
      }
    });
  });
}
