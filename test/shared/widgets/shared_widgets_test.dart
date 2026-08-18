import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_auth_text.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_section_header.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_settings_card.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_settings_section_title.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_settings_switch_tile.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_settings_tile.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_timeline_item.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
  });

  group('Shared Widgets Tests', () {
    testWidgets('CommonTimelineItem should render title, subtitle and description', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CommonTimelineItem(
                  title: 'Senior Flutter Developer',
                  subtitle: '2023 - Present',
                  description: 'Architecting cross-platform apps.',
                  isLast: false,
                ),
                CommonTimelineItem(
                  title: 'Mobile Engineer',
                  subtitle: '2021 - 2023',
                  description: 'Built enterprise iOS & Android apps.',
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Senior Flutter Developer'), findsOneWidget);
      expect(find.text('2023 - Present'), findsOneWidget);
      expect(find.text('Architecting cross-platform apps.'), findsOneWidget);
      expect(find.text('Mobile Engineer'), findsOneWidget);
    });

    testWidgets('CommonSettingsCard & CommonSettingsSectionTitle should render properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CommonSettingsSectionTitle(title: 'General Settings'),
                CommonSettingsCard(
                  children: [
                    Text('Child 1'),
                    Text('Child 2'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('GENERAL SETTINGS'), findsOneWidget);
      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);
    });

    testWidgets('CommonSettingsTile and CommonSettingsSwitchTile interaction', (WidgetTester tester) async {
      bool tileTapped = false;
      bool switchValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    CommonSettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'English',
                      onTap: () => tileTapped = true,
                    ),
                    CommonSettingsSwitchTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      value: switchValue,
                      onChanged: (val) {
                        setState(() {
                          switchValue = val;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);

      await tester.tap(find.text('Language'));
      expect(tileTapped, isTrue);

      final switchFinder = find.byType(CommonSwitch);
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      expect(switchValue, isTrue);
    });

    testWidgets('CommonSectionHeader and CommonAuthText render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const CommonSectionHeader(
                  title: 'Featured Projects',
                  showVerticalBar: true,
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                CommonAuthText(
                  'Sensitive User Info',
                  blurLevel: AuthBlurLevel.medium,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Featured Projects'), findsOneWidget);
      expect(find.byType(CommonSectionHeader), findsOneWidget);
      expect(find.byType(CommonAuthText), findsOneWidget);
    });
  });
}
