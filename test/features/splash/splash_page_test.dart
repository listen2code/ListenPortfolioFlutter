import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_view_model.dart';
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
    SplashViewModel.splashDelay = Duration.zero;
  });

  tearDownAll(() {
    SplashViewModel.splashDelay = const Duration(seconds: 2);
  });

  group('SplashPage Widget Tests', () {
    testWidgets('renders app logo, app name, and hero animation structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SplashPage(),
          ),
        ),
      );
      // Advance past the 1500ms TweenAnimationBuilder duration
      await tester.pump(const Duration(milliseconds: 1600));

      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.text(AppConstants.appName), findsOneWidget);
      expect(find.byType(CommonImage), findsOneWidget);
      expect(find.byType(Hero), findsOneWidget);
    });
  });
}
