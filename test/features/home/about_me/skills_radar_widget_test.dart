import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/comprehensive_skills.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/skills_radar_chart.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  final List<SkillCategoryModel> mockSkills = [
    const SkillCategoryModel(
      id: '1',
      category: 'Mobile',
      score: 96,
      items: ['Android Native', 'Flutter', 'Kotlin', 'Dart'],
    ),
    const SkillCategoryModel(
      id: '2',
      category: 'Architecture',
      score: 93,
      items: ['Clean Arch', 'MVI', 'SOLID'],
    ),
    const SkillCategoryModel(
      id: '3',
      category: 'APM & Performance',
      score: 95,
      items: ['Vsync Monitor', 'Systrace', 'LeakCanary'],
    ),
    const SkillCategoryModel(
      id: '4',
      category: 'Stability',
      score: 94,
      items: ['Safe Mode', '401 Queue', 'Zone Sandbox'],
    ),
    const SkillCategoryModel(
      id: '5',
      category: 'Backend & Cloud',
      score: 85,
      items: ['Spring Boot', 'MySQL', 'Docker'],
    ),
    const SkillCategoryModel(
      id: '6',
      category: 'DevOps',
      score: 90,
      items: ['CI/CD', 'Automated Testing', 'Shorebird'],
    ),
  ];

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }

  group('ComprehensiveSkills & SkillsRadarChart Widget Tests', () {
    testWidgets('renders empty widget when skills list is empty', (tester) async {
      await tester.pumpWidget(
        buildTestApp(const ComprehensiveSkills(skills: [])),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ComprehensiveSkills), findsOneWidget);
      expect(find.byType(SkillsRadarChart), findsNothing);
    });

    testWidgets('renders Radar mode by default with chart and inspector card', (tester) async {
      await tester.pumpWidget(
        buildTestApp(ComprehensiveSkills(skills: mockSkills)),
      );
      await tester.pumpAndSettle();

      // Check header
      expect(find.byType(CommonSectionHeader), findsOneWidget);
      expect(find.byType(SkillsRadarChart), findsOneWidget);

      // Check view mode switcher exists
      expect(find.text(I18nKeys.viewModeRadar.tr), findsOneWidget);
      expect(find.text(I18nKeys.viewModeList.tr), findsOneWidget);

      // Check first dimension is selected and shows items
      expect(find.text('Android Native'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('switching dimension updates inspector card details', (tester) async {
      await tester.pumpWidget(
        buildTestApp(ComprehensiveSkills(skills: mockSkills)),
      );
      await tester.pumpAndSettle();

      // Initially Mobile is selected
      expect(find.text('Android Native'), findsOneWidget);
      expect(find.text('Spring Boot'), findsNothing);

      // Tap on Backend & Cloud dimension chip
      final backendChip = find.text('Backend & Cloud');
      expect(backendChip, findsOneWidget);
      await tester.ensureVisible(backendChip);
      await tester.tap(backendChip);
      await tester.pumpAndSettle();

      // Now Backend items should be shown
      expect(find.text('Spring Boot'), findsOneWidget);
      expect(find.text('MySQL'), findsOneWidget);
      expect(find.text('Android Native'), findsNothing);
    });

    testWidgets('switches between Radar mode and List mode seamlessly', (tester) async {
      await tester.pumpWidget(
        buildTestApp(ComprehensiveSkills(skills: mockSkills)),
      );
      await tester.pumpAndSettle();

      // Currently in Radar mode
      expect(find.byType(SkillsRadarChart), findsOneWidget);

      // Tap on List view mode
      await tester.tap(find.text(I18nKeys.viewModeList.tr));
      await tester.pumpAndSettle();

      // In List mode, chart is not displayed and all categories are listed
      expect(find.byType(SkillsRadarChart), findsNothing);
      expect(find.text('Android Native'), findsOneWidget);
      expect(find.text('Spring Boot'), findsOneWidget);
      expect(find.text('Safe Mode'), findsOneWidget);

      // Tap back to Radar mode
      await tester.tap(find.text(I18nKeys.viewModeRadar.tr));
      await tester.pumpAndSettle();

      // Radar chart is visible again
      expect(find.byType(SkillsRadarChart), findsOneWidget);
    });

    testWidgets('SkillsRadarChart handles tap gestures on canvas', (tester) async {
      int selected = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: SkillsRadarChart(
                  skills: mockSkills,
                  selectedIndex: selected,
                  onSelectDimension: (idx) {
                    selected = idx;
                  },
                  animation: const AlwaysStoppedAnimation(1.0),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SkillsRadarChart), findsOneWidget);

      // Tap on the right quadrant of the radar canvas
      await tester.tapAt(const Offset(220, 150));
      await tester.pumpAndSettle();
    });

    testWidgets('jumping across multiple non-adjacent dimensions animates directly to target without flicker', (tester) async {
      await tester.pumpWidget(
        buildTestApp(ComprehensiveSkills(skills: mockSkills)),
      );
      await tester.pumpAndSettle();

      // Initially dimension 0 (Mobile) is selected
      expect(find.text('Android Native'), findsOneWidget);

      // Jump to dimension 4 (Backend & Cloud) skipping 1, 2, 3
      final backendChip = find.text('Backend & Cloud');
      expect(backendChip, findsOneWidget);
      await tester.ensureVisible(backendChip);
      await tester.tap(backendChip);

      // Advance by half animation duration (e.g. 150ms) to check mid-flight state
      await tester.pump(const Duration(milliseconds: 150));

      // Settle animation
      await tester.pumpAndSettle();

      // Target dimension 4 details should be displayed cleanly
      expect(find.text('Spring Boot'), findsOneWidget);
      expect(find.text('MySQL'), findsOneWidget);
      expect(find.text('Android Native'), findsNothing);
    });
  });
}
