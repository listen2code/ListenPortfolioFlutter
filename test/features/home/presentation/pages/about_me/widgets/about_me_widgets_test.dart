import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/bio_section.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/comprehensive_skills.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
  });

  group('AboutMe Child Widgets Tests', () {
    testWidgets('BioSection renders bio text and triggers onTapResume', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BioSection(
              bio: 'Senior Flutter & Full-Stack Architect with 10+ years experience.',
              onTapResume: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Senior Flutter & Full-Stack Architect with 10+ years experience.'), findsOneWidget);
      expect(find.byIcon(Icons.description_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.description_outlined));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('ComprehensiveSkills renders skill categories and item chips', (WidgetTester tester) async {
      const skills = [
        SkillCategoryModel(category: 'Mobile', items: ['Flutter', 'Dart', 'Swift']),
        SkillCategoryModel(category: 'Backend', items: ['Go', 'Node.js', 'PostgreSQL']),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ComprehensiveSkills(skills: skills),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(I18nKeys.coreSkills.tr), findsOneWidget);
      expect(find.text('Mobile'), findsWidgets);
      expect(find.text('Flutter'), findsOneWidget);

      // Switch to List mode to see all categories and items
      await tester.tap(find.text(I18nKeys.viewModeList.tr));
      await tester.pumpAndSettle();

      expect(find.text('Backend'), findsOneWidget);
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('ComprehensiveSkills supports swiping detail card and synchronizes selection', (WidgetTester tester) async {
      const skills = [
        SkillCategoryModel(category: 'Mobile', score: 95, items: ['Flutter', 'Dart']),
        SkillCategoryModel(category: 'Backend', score: 88, items: ['Java', 'Spring']),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ComprehensiveSkills(skills: skills),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially Mobile is selected and Flutter item is visible
      expect(find.text('Flutter'), findsOneWidget);

      // Swipe left on the PageView area to go to page 1 (Backend)
      await tester.fling(find.byType(PageView), const Offset(-500, 0), 1000);
      await tester.pumpAndSettle();

      // Now Backend details and Java item should be visible in the inspector card
      expect(find.text('Java'), findsOneWidget);
      expect(find.text('Spring'), findsOneWidget);

      // Tap on Mobile chip to navigate back to Mobile
      await tester.tap(find.text('Mobile').first);
      await tester.pumpAndSettle();

      expect(find.text('Flutter'), findsOneWidget);
    });
  });
}
