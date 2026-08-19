import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/widgets/login_action_buttons.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/widgets/login_form_fields.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/widgets/login_header.dart';
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

  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('renders LoginPage with header, form fields, and action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(LoginHeader), findsOneWidget);
      expect(find.byType(LoginFormFields), findsOneWidget);
      expect(find.byType(LoginActionButtons), findsOneWidget);

      expect(find.text(I18nKeys.welcomeBack.tr), findsOneWidget);
      expect(find.text(I18nKeys.rememberMe.tr), findsOneWidget);
      expect(find.text(I18nKeys.forgotPassword.tr), findsOneWidget);

      // Verify text fields exist
      expect(find.byType(CommonTextField), findsNWidgets(2));

      // Enter username
      await tester.enterText(find.byType(CommonTextField).first, 'developer_test');
      await tester.pumpAndSettle();

      // Enter password
      await tester.enterText(find.byType(CommonTextField).last, 'Secret123!');
      await tester.pumpAndSettle();
    });
  });
}
