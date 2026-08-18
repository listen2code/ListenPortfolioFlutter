import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/about_me_skeleton.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/widgets/architecture_skeleton.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/widgets/overview_skeleton.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
  });

  group('Home Skeletons Widget Tests', () {
    testWidgets('AboutMeSkeleton should render skeleton placeholders', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AboutMeSkeleton(),
          ),
        ),
      );

      expect(find.byType(AboutMeSkeleton), findsOneWidget);
      expect(find.byType(CommonSkeleton), findsWidgets);
    });

    testWidgets('OverviewSkeleton should render skeleton placeholders', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OverviewSkeleton(),
          ),
        ),
      );

      expect(find.byType(OverviewSkeleton), findsOneWidget);
      expect(find.byType(CommonSkeleton), findsWidgets);
    });

    testWidgets('ArchitectureSkeleton should render skeleton placeholders', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArchitectureSkeleton(),
          ),
        ),
      );

      expect(find.byType(ArchitectureSkeleton), findsOneWidget);
      expect(find.byType(CommonSkeleton), findsWidgets);
    });
  });
}
