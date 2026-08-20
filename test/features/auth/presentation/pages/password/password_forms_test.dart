import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/widgets/change_password_form.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/widgets/forgot_password_form.dart';
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

  group('ChangePasswordForm Widget Tests', () {
    testWidgets('Renders all fields and triggers callbacks', (tester) async {
      final oldCtrl = TextEditingController();
      final newCtrl = TextEditingController();
      final confirmCtrl = TextEditingController();

      String? changedOld;
      String? changedNew;
      String? changedConfirm;
      bool submitted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ChangePasswordForm(
                oldPwdController: oldCtrl,
                newPwdController: newCtrl,
                confirmPwdController: confirmCtrl,
                state: const ChangePasswordState(
                  oldPasswordError: 'Old pwd error',
                  newPasswordError: 'New pwd error',
                ),
                onOldPasswordChanged: (v) => changedOld = v,
                onNewPasswordChanged: (v) => changedNew = v,
                onConfirmPasswordChanged: (v) => changedConfirm = v,
                onSubmit: () => submitted = true,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CommonTextField), findsNWidgets(3));
      expect(find.text('Old pwd error'), findsOneWidget);
      expect(find.text('New pwd error'), findsOneWidget);

      await tester.enterText(find.byType(CommonTextField).at(0), 'old123');
      expect(changedOld, equals('old123'));

      await tester.enterText(find.byType(CommonTextField).at(1), 'new123');
      expect(changedNew, equals('new123'));

      await tester.enterText(find.byType(CommonTextField).at(2), 'confirm123');
      expect(changedConfirm, equals('confirm123'));

      await tester.tap(find.text(I18nKeys.updatePassword.tr));
      await tester.pump();
      expect(submitted, isTrue);
    });
  });

  group('ForgotPasswordForm Widget Tests', () {
    testWidgets('Renders email field, buttons, and triggers callbacks', (tester) async {
      final emailCtrl = TextEditingController();
      String? changedEmail;
      bool submitReset = false;
      bool tapLogin = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ForgotPasswordForm(
                emailController: emailCtrl,
                state: const ForgotPasswordState(
                  emailError: 'Invalid email format',
                ),
                onEmailChanged: (v) => changedEmail = v,
                onSubmitReset: () => submitReset = true,
                onTapLogin: () => tapLogin = true,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CommonTextField), findsOneWidget);
      expect(find.text('Invalid email format'), findsOneWidget);

      await tester.enterText(find.byType(CommonTextField), 'test@domain.com');
      expect(changedEmail, equals('test@domain.com'));

      await tester.tap(find.text(I18nKeys.sendResetLink.tr));
      await tester.pump();
      expect(submitReset, isTrue);

      await tester.tap(find.text(I18nKeys.loginLink.tr));
      await tester.pump();
      expect(tapLogin, isTrue);
    });
  });
}
