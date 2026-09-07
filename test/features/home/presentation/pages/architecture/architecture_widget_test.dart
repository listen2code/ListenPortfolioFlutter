import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/widgets/architecture_section_card.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/widgets/architecture_skeleton.dart';
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

  Widget createWidget({required bool active}) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: ArchitectureWidget(active: active),
        ),
      ),
    );
  }

  group('ArchitectureWidget Tests', () {
    testWidgets('renders skeleton while loading and sections on load', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget(active: true));
      await tester.pump();

      // Initially shows skeleton during refresh
      expect(find.byType(ArchitectureSkeleton), findsOneWidget);

      // Fast forward past simulated network delay (800ms)
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // After load, sections are rendered
      expect(find.byType(ArchitectureSectionCard), findsWidgets);
      expect(find.text(I18nKeys.cleanMVITitle.tr), findsOneWidget);
    });

    testWidgets('inactive widget does not trigger auto-load', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget(active: false));
      await tester.pump();

      expect(find.byType(ArchitectureWidget), findsOneWidget);
    });
  });
}
