import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance/appearance_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list/crash_log_list_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/resume/resume_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/widgets/quick_actions.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/widgets/settings_version_tile.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:listen_portfolio_flutter/main.dart' as app;
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ==========================================
// Robust Page Transition Wait Helpers
// ==========================================
Future<void> waitForPageTransition(PatrolTester $) async {
  final tester = $.tester;
  for (int i = 0; i < 40; i++) {
    if (find.byType(LoginPage).evaluate().isNotEmpty ||
        find.byType(HomePage).evaluate().isNotEmpty) {
      break;
    }
    await tester.pump(const Duration(milliseconds: 300));
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }
  await tester.pumpAndSettle();
}

Future<void> waitForPage(PatrolTester $, Type pageType) async {
  final tester = $.tester;
  for (int i = 0; i < 40; i++) {
    if (find.byType(pageType).evaluate().isNotEmpty) {
      break;
    }
    await tester.pump(const Duration(milliseconds: 200));
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }
  await tester.pumpAndSettle();
}

// ==========================================
// UI Helpers for Isolated & Re-entrant Runs
// ==========================================
Future<void> bootAppAndGoToLogin(PatrolTester $) async {
  final tester = $.tester;
  // If an alert dialog is left open from previous test, dismiss it
  final dialogOkBtn = find.text(I18nKeys.ok.tr);
  if (dialogOkBtn.evaluate().isNotEmpty && find.byType(AlertDialog).evaluate().isNotEmpty) {
    await tester.tap(dialogOkBtn.first);
    await tester.pumpAndSettle();
  }

  if (find.byType(LoginPage).evaluate().isNotEmpty) {
    return;
  }

  // If on HomePage, navigate to LoginPage
  if (find.byType(HomePage).evaluate().isNotEmpty) {
    tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    final logoutBtn = find.descendant(
      of: find.byType(Drawer),
      matching: find.text(I18nKeys.logout.tr),
    );
    if (logoutBtn.evaluate().isNotEmpty) {
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();
      final okBtn = find.text(I18nKeys.ok.tr);
      if (okBtn.evaluate().isNotEmpty) {
        await tester.tap(okBtn);
        await waitForPage($, LoginPage);
      }
      return;
    }

    final loginBtn = find.descendant(
      of: find.byType(Drawer),
      matching: find.text(I18nKeys.login.tr),
    );
    if (loginBtn.evaluate().isNotEmpty) {
      await tester.tap(loginBtn);
      await waitForPage($, LoginPage);
      return;
    }
  }

  // Otherwise, boot the app from scratch
  app.main();
  await tester.pumpAndSettle();

  // Wait for splash transition to complete
  await waitForPageTransition($);

  if (find.byType(LoginPage).evaluate().isNotEmpty) {
    return;
  }

  if (find.byType(HomePage).evaluate().isNotEmpty) {
    tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    final logoutBtn = find.descendant(
      of: find.byType(Drawer),
      matching: find.text(I18nKeys.logout.tr),
    );
    if (logoutBtn.evaluate().isNotEmpty) {
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();
      final okBtn = find.text(I18nKeys.ok.tr);
      if (okBtn.evaluate().isNotEmpty) {
        await tester.tap(okBtn);
        await waitForPage($, LoginPage);
      }
      return;
    }

    final loginBtn = find.descendant(
      of: find.byType(Drawer),
      matching: find.text(I18nKeys.login.tr),
    );
    if (loginBtn.evaluate().isNotEmpty) {
      await tester.tap(loginBtn);
      await waitForPage($, LoginPage);
      return;
    }
  }

  await waitForPage($, LoginPage);
}

Future<void> performUiLogin(PatrolTester $, String username, String password) async {
  final tester = $.tester;
  if (find.byType(HomePage).evaluate().isNotEmpty && !authManager.state.isGuest) {
    return;
  }

  await bootAppAndGoToLogin($);

  if (find.byType(LoginPage).evaluate().isNotEmpty) {
    final loginFields = find.byType(CommonTextField);
    await tester.enterText(loginFields.at(0), username);
    await tester.enterText(loginFields.at(1), password);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    final submitLoginBtn = find.widgetWithText(CommonButton, I18nKeys.login.tr);
    await tester.tap(submitLoginBtn);
    await waitForPage($, HomePage);

    // Dismiss floating CommonToast overlay so bottom navigation bar is not blocked
    CommonToast.hide();
    await tester.pumpAndSettle();
  }
}

Future<void> navigateToSettings(PatrolTester $) async {
  final tester = $.tester;
  if (find.byType(HomePage).evaluate().isEmpty) {
    await performUiLogin($, 'test_user', 'password123');
  }

  if (find.byType(HomePage).evaluate().isNotEmpty) {
    tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    final settingsOption = find.descendant(
      of: find.byType(Drawer),
      matching: find.text(I18nKeys.settings.tr),
    );
    await tester.tap(settingsOption);
    await waitForPage($, SettingsPage);
  }
}

void main() {
  setUpAll(() {
    // Prevent visibility animations from lagging and blocking pumpAndSettle
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    // Pre-initialize mock services to prevent native hangs during tests
    iapService = FakeIapService();
    notificationService = FakeNotificationService();
    ShareProviderImpl.skipShareForTesting = true;

    // Configure LocalMockServer with low latency for fast execution
    LocalMockServer.initConfig(const MockServerConfig(networkLatency: Duration(milliseconds: 10)));
  });

  group('E2E UI Flow Integration Tests (Patrol)', () {
    setUp(() async {
      await SpUtil.put(AppConstants.hasReviewKey, true);
    });

    // ==========================================
    // CASE GROUP 1: Login Form & Validations
    // ==========================================
    patrolWidgetTest('UI Test - Login Form and Validations', ($) async {
      final tester = $.tester;
      await bootAppAndGoToLogin($);

      expect(find.byType(LoginPage), findsOneWidget);

      final loginFields = find.byType(CommonTextField);
      expect(loginFields, findsNWidgets(2));

      final submitLoginBtn = find.widgetWithText(CommonButton, I18nKeys.login.tr);
      expect(submitLoginBtn, findsOneWidget);

      // Verify and tap Remember Me toggle
      final rememberMeBtn = find.text(I18nKeys.rememberMe.tr);
      expect(rememberMeBtn, findsOneWidget);
      await tester.tap(rememberMeBtn);
      await tester.pumpAndSettle();

      // Test Password visibility toggle locally in CommonTextField
      final passwordVisibilityOff = find.byIcon(Icons.visibility_off);
      expect(passwordVisibilityOff, findsOneWidget);
      await tester.tap(passwordVisibilityOff);
      await tester.pumpAndSettle();

      final passwordVisibilityOn = find.byIcon(Icons.visibility);
      expect(passwordVisibilityOn, findsOneWidget);
      await tester.tap(passwordVisibilityOn);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // ABNORMAL 1: Submit with empty fields
      await tester.enterText(loginFields.at(0), '');
      await tester.enterText(loginFields.at(1), '');
      await tester.pumpAndSettle();

      await tester.ensureVisible(submitLoginBtn);
      await tester.pumpAndSettle();
      await tester.tap(submitLoginBtn);
      await tester.pumpAndSettle();
      // Expect "Field required" errors
      expect(find.text(I18nKeys.fieldRequired.tr), findsNWidgets(2));

      // ABNORMAL 2: Submit with too short username and password
      await tester.enterText(loginFields.at(0), 'ab');
      await tester.enterText(loginFields.at(1), '123');
      await tester.pumpAndSettle();

      await tester.tap(submitLoginBtn);
      await tester.pumpAndSettle();
      // Expect min length validation errors
      expect(find.text(I18nKeys.minLengthMsg.trArgs(['3'])), findsOneWidget);
      expect(find.text(I18nKeys.minLengthMsg.trArgs(['6'])), findsOneWidget);
    });

    // ==========================================
    // CASE GROUP 2: Forgot Password Flow
    // ==========================================
    patrolWidgetTest('UI Test - Forgot Password Flow', ($) async {
      final tester = $.tester;
      await bootAppAndGoToLogin($);

      final forgotPasswordBtn = find.text(I18nKeys.forgotPassword.tr);
      expect(forgotPasswordBtn, findsOneWidget);

      // Tap Forgot Password
      await tester.tap(forgotPasswordBtn);
      await tester.pumpAndSettle();

      // Verify page transition
      expect(find.byType(ForgotPasswordPage), findsOneWidget);

      final forgotEmailField = find.byType(CommonTextField);
      expect(forgotEmailField, findsOneWidget);

      final sendResetBtn = find.text(I18nKeys.sendResetLink.tr);
      expect(sendResetBtn, findsOneWidget);

      // Submit invalid email format
      await tester.enterText(forgotEmailField, 'invalid-email');
      await tester.pumpAndSettle();
      await tester.tap(sendResetBtn);
      await tester.pumpAndSettle();
      expect(find.text(I18nKeys.invalidEmail.tr), findsOneWidget);

      // Submit valid email
      await tester.enterText(forgotEmailField, 'test_user@gmail.com');
      await tester.pumpAndSettle();

      // Dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      await tester.tap(sendResetBtn);
      await waitForPage($, LoginPage);

      // Verify redirect back to LoginPage
      expect(find.byType(LoginPage), findsOneWidget);
    });

    // ==========================================
    // CASE GROUP 3: Sign Up Flow
    // ==========================================
    patrolWidgetTest('UI Test - Sign Up Flow', ($) async {
      final tester = $.tester;
      await bootAppAndGoToLogin($);

      final signUpBtn = find.text(I18nKeys.signUp.tr);
      expect(signUpBtn, findsOneWidget);

      // Tap Sign Up
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();

      // Verify on SignUpPage
      expect(find.byType(SignUpPage), findsOneWidget);

      final signUpFields = find.byType(CommonTextField);
      expect(signUpFields, findsNWidgets(4));

      final submitSignUpBtn = find.widgetWithText(CommonButton, I18nKeys.signUp.tr);
      expect(submitSignUpBtn, findsOneWidget);

      final timestamp = DateTime.now().millisecondsSinceEpoch % 100000;
      final uniqueName = 'User_$timestamp';
      final uniqueEmail = 'user_$timestamp@gmail.com';

      // Submit with mismatching confirm password
      await tester.enterText(signUpFields.at(0), uniqueName);
      await tester.enterText(signUpFields.at(1), uniqueEmail);
      await tester.enterText(signUpFields.at(2), 'password123');
      await tester.enterText(signUpFields.at(3), 'different');
      await tester.pumpAndSettle();

      await tester.ensureVisible(submitSignUpBtn);
      await tester.pumpAndSettle();
      await tester.tap(submitSignUpBtn);
      await tester.pumpAndSettle();
      expect(find.text(I18nKeys.passwordsDoNotMatch.tr), findsOneWidget);

      // Submit valid registration details
      await tester.enterText(signUpFields.at(3), 'password123');
      await tester.pumpAndSettle();

      // Dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      await tester.tap(submitSignUpBtn);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Dismiss any API dialog if returned
      final okBtn = find.text(I18nKeys.ok.tr);
      if (okBtn.evaluate().isNotEmpty) {
        await tester.tap(okBtn.first);
        await tester.pumpAndSettle();
      }

      await waitForPage($, LoginPage);
      if (find.byType(LoginPage).evaluate().isEmpty) {
        final backBtn = find.byType(BackButton);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await waitForPage($, LoginPage);
        }
      }

      // Verify redirect back to LoginPage
      expect(find.byType(LoginPage), findsOneWidget);
    });

    // ==========================================
    // CASE GROUP 4: Login & Home Navigation
    // ==========================================
    patrolWidgetTest('UI Test - Login and Home Navigation', ($) async {
      final tester = $.tester;
      await performUiLogin($, 'test_user', 'password123');

      // Verify we returned to HomePage
      expect(find.byType(HomePage), findsOneWidget);

      // Open Navigation Drawer to verify profile details
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Listen'), findsOneWidget);
      expect(find.text('listen2code@gmail.com'), findsOneWidget);

      // Close Drawer (tap outside)
      await tester.tapAt(const Offset(350, 300));
      await tester.pumpAndSettle();

      // Switch to About Me tab via Drawer
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();

      final aboutMeOption = find.descendant(
        of: find.byType(Drawer),
        matching: find.text(I18nKeys.aboutMe.tr),
      );
      expect(aboutMeOption, findsOneWidget);
      await tester.tap(aboutMeOption);
      await tester.pumpAndSettle();

      // Verify AboutMe page & check Share action button
      final shareIcon = find.byIcon(Icons.share_outlined);
      expect(shareIcon, findsOneWidget);
      await tester.tap(shareIcon);
      await tester.pumpAndSettle();
    });

    // ==========================================
    // CASE GROUP 5: Settings Adjustments & Logout
    // ==========================================
    patrolWidgetTest('UI Test - Settings Adjustments and Logout', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // 1. Language switcher UI verification
      final languageTile = find.text(I18nKeys.language.tr);
      expect(languageTile, findsOneWidget);
      await tester.tap(languageTile);
      await tester.pumpAndSettle();

      // Select english language in Dialog
      final englishOption = find.descendant(
        of: find.byType(Dialog),
        matching: find.text(AppLanguage.english.label),
      );
      if (englishOption.evaluate().isNotEmpty) {
        await tester.tap(englishOption);
        await tester.pumpAndSettle();
      }

      // 2. Notifications switch toggle UI check
      final notificationTile = find.byIcon(Icons.notifications_none_rounded);
      expect(notificationTile, findsOneWidget);
      await tester.tap(notificationTile);
      await tester.pumpAndSettle();

      // 3. Clear cache UI check
      final clearCacheTile = find.text(I18nKeys.clearCache.tr);
      expect(clearCacheTile, findsOneWidget);
      await tester.tap(clearCacheTile);
      await tester.pumpAndSettle();

      // 4. Pop back from SettingsPage to HomePage before opening drawer for logout
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      } else {
        final backIcon = find.byIcon(Icons.arrow_back);
        if (backIcon.evaluate().isNotEmpty) {
          await tester.tap(backIcon);
          await tester.pumpAndSettle();
        }
      }

      // Logout trigger via HomePage Drawer (since Logout button is in drawer footer)
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();

      final logoutBtn = find.descendant(
        of: find.byType(Drawer),
        matching: find.text(I18nKeys.logout.tr),
      );
      expect(logoutBtn, findsOneWidget);
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      // Tap Dialog OK button
      final okBtn = find.text(I18nKeys.ok.tr);
      expect(okBtn, findsOneWidget);
      await tester.tap(okBtn);
      await waitForPage($, LoginPage);

      // Verify redirected back to LoginPage
      expect(find.byType(LoginPage), findsOneWidget);
    });

    // ==========================================
    // CASE GROUP 6: AI Chat Assistant Interactivity
    // ==========================================
    patrolWidgetTest('UI Test - AI Chat Floating Sheet and Interaction', ($) async {
      final tester = $.tester;
      await performUiLogin($, 'test_user', 'password123');

      expect(find.byType(HomePage), findsOneWidget);

      // Find and tap the AI Assistant Floating Action Button
      final aiFab = find.byType(FloatingActionButton);
      if (aiFab.evaluate().isNotEmpty) {
        await tester.tap(aiFab);
        await tester.pumpAndSettle();

        // Verify transition to AiChatPage
        expect(find.byType(AiChatPage), findsOneWidget);

        // Find input textfield in AI Chat
        final chatInputField = find.byType(TextField);
        if (chatInputField.evaluate().isNotEmpty) {
          await tester.enterText(chatInputField.first, 'Tell me about Flutter Architecture');
          await tester.pumpAndSettle();

          // Find send button
          final sendBtn = find.byIcon(Icons.send_rounded);
          if (sendBtn.evaluate().isNotEmpty) {
            await tester.tap(sendBtn);
            await tester.pumpAndSettle();
          }
        }

        // Pop back to HomePage
        final backButton = find.byType(BackButton);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();
        } else {
          final closeIcon = find.byIcon(Icons.close);
          if (closeIcon.evaluate().isNotEmpty) {
            await tester.tap(closeIcon.first);
            await tester.pumpAndSettle();
          }
        }
      }
    });

    // ==========================================
    // CASE GROUP 7: Home Sub-Views Navigation
    // ==========================================
    patrolWidgetTest('UI Test - Home Bottom Navigation and All Sub-Views', ($) async {
      final tester = $.tester;
      await performUiLogin($, 'test_user', 'password123');

      expect(find.byType(HomePage), findsOneWidget);

      // 1. Navigate to Projects Tab via Drawer
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();
      final projectsItem = find.descendant(
        of: find.byType(Drawer),
        matching: find.byIcon(Icons.rocket_launch_outlined),
      );
      if (projectsItem.evaluate().isNotEmpty) {
        await tester.tap(projectsItem);
        await tester.pumpAndSettle();
      }

      // 2. Navigate to Architecture Tab via Drawer
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();
      final archItem = find.descendant(
        of: find.byType(Drawer),
        matching: find.byIcon(Icons.account_tree_outlined),
      );
      if (archItem.evaluate().isNotEmpty) {
        await tester.tap(archItem);
        await tester.pumpAndSettle();
      }

      // 3. Navigate to About Me Tab via Drawer
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();
      final aboutItem = find.descendant(
        of: find.byType(Drawer),
        matching: find.byIcon(Icons.person_search_outlined),
      );
      if (aboutItem.evaluate().isNotEmpty) {
        await tester.tap(aboutItem);
        await tester.pumpAndSettle();
      }

      // 4. Return to Overview Tab via Drawer
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();
      final overviewItem = find.descendant(
        of: find.byType(Drawer),
        matching: find.byIcon(Icons.dashboard_customize_outlined),
      );
      if (overviewItem.evaluate().isNotEmpty) {
        await tester.tap(overviewItem);
        await tester.pumpAndSettle();
      }
    });

    // ==========================================
    // CASE GROUP 8: Settings Theme & Font Size Adjustments
    // ==========================================
    patrolWidgetTest('UI Test - Settings Theme and Font Size Adjustments', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // Navigate to Appearance Page
      final appearanceOption = find.text(I18nKeys.appearance.tr);
      if (appearanceOption.evaluate().isNotEmpty) {
        await tester.tap(appearanceOption);
        await tester.pumpAndSettle();

        expect(find.byType(AppearancePage), findsOneWidget);

        // Switch Theme Mode (Dark Mode)
        final darkModeTile = find.text(I18nKeys.dark.tr);
        if (darkModeTile.evaluate().isNotEmpty) {
          await tester.tap(darkModeTile);
          await tester.pumpAndSettle();
        }

        // Switch Theme Mode (Light Mode)
        final lightModeTile = find.text(I18nKeys.light.tr);
        if (lightModeTile.evaluate().isNotEmpty) {
          await tester.tap(lightModeTile);
          await tester.pumpAndSettle();
        }

        // Pop back to SettingsPage
        final backBtn = find.byType(BackButton);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await tester.pumpAndSettle();
        }
      }
    });

    // ==========================================
    // CASE GROUP 9: Developer Mode & Settings Extra Actions
    // ==========================================
    patrolWidgetTest('UI Test - Developer Mode and Settings Extra Actions', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // Scroll to version tile & trigger developer mode if present
      final versionTile = find.byType(SettingsVersionTile);
      if (versionTile.evaluate().isNotEmpty) {
        await tester.ensureVisible(versionTile);
        await tester.pumpAndSettle();
        await tester.tap(versionTile);
        await tester.pumpAndSettle();
      }

      // Check Buy me a coffee tile in settings
      final coffeeTile = find.text(I18nKeys.buyMeCoffee.tr);
      if (coffeeTile.evaluate().isNotEmpty) {
        await tester.tap(coffeeTile);
        await tester.pumpAndSettle();

        final cancelBtn = find.text(I18nKeys.cancel.tr);
        if (cancelBtn.evaluate().isNotEmpty) {
          await tester.tap(cancelBtn);
          await tester.pumpAndSettle();
        }
      }
    });

    // ==========================================
    // CASE GROUP 10: Guest Mode Flow & Exploration
    // ==========================================
    patrolWidgetTest('UI Test - Guest Mode Flow and Exploration', ($) async {
      final tester = $.tester;
      await bootAppAndGoToLogin($);

      // Verify Skip For Now / Guest entrance button on LoginPage
      final skipForNowBtn = find.text(I18nKeys.skipForNow.tr);
      if (skipForNowBtn.evaluate().isNotEmpty) {
        await tester.tap(skipForNowBtn);
        await waitForPage($, HomePage);

        expect(find.byType(HomePage), findsOneWidget);

        // Open Drawer to verify guest profile role
        tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
        await tester.pumpAndSettle();

        expect(find.text(I18nKeys.roleGuest.tr), findsOneWidget);

        // Tap Login link in drawer footer to return to LoginPage
        final loginOption = find.descendant(
          of: find.byType(Drawer),
          matching: find.text(I18nKeys.login.tr),
        );
        if (loginOption.evaluate().isNotEmpty) {
          await tester.tap(loginOption);
          await waitForPage($, LoginPage);

          expect(find.byType(LoginPage), findsOneWidget);
        }
      }
    });

    // ==========================================
    // CASE GROUP 11: Change Password Flow Validation
    // ==========================================
    patrolWidgetTest('UI Test - Change Password Flow Validation', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // Navigate to Change Password Page
      final changePasswordOption = find.text(I18nKeys.changePassword.tr);
      if (changePasswordOption.evaluate().isNotEmpty) {
        await tester.tap(changePasswordOption);
        await waitForPage($, ChangePasswordPage);

        expect(find.byType(ChangePasswordPage), findsOneWidget);

        final passwordFields = find.byType(CommonTextField);
        if (passwordFields.evaluate().length >= 3) {
          // Input mismatching passwords
          await tester.enterText(passwordFields.at(0), 'password123');
          await tester.enterText(passwordFields.at(1), 'newPassword123');
          await tester.enterText(passwordFields.at(2), 'mismatchPassword');
          await tester.pumpAndSettle();

          // Submit form
          final updateBtn = find.widgetWithText(CommonButton, I18nKeys.updatePassword.tr);
          if (updateBtn.evaluate().isNotEmpty) {
            await tester.tap(updateBtn);
            await tester.pumpAndSettle();

            expect(find.text(I18nKeys.passwordsDoNotMatch.tr), findsOneWidget);
          }
        }

        // Pop back to SettingsPage
        final backBtn = find.byType(BackButton);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await tester.pumpAndSettle();
        }
      }
    });

    // ==========================================
    // CASE GROUP 12: Resume View & PDF Export Trigger
    // ==========================================
    patrolWidgetTest('UI Test - Resume View and PDF Export Trigger', ($) async {
      final tester = $.tester;
      await performUiLogin($, 'test_user', 'password123');

      expect(find.byType(HomePage), findsOneWidget);

      // Open Drawer and tap Resume / Author Resume
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();

      final resumeOption = find.descendant(
        of: find.byType(Drawer),
        matching: find.text(I18nKeys.authorResume.tr),
      );
      if (resumeOption.evaluate().isNotEmpty) {
        await tester.tap(resumeOption);
        await waitForPage($, ResumePage);

        expect(find.byType(ResumePage), findsOneWidget);

        // Tap PDF export action icon
        final pdfIcon = find.byIcon(Icons.picture_as_pdf_outlined);
        if (pdfIcon.evaluate().isNotEmpty) {
          await tester.tap(pdfIcon);
          await tester.pumpAndSettle();
        }

        // Pop back to HomePage
        final backBtn = find.byType(BackButton);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await tester.pumpAndSettle();
        }
      }
    });

    // ==========================================
    // CASE GROUP 13: Language Switching Flow
    // ==========================================
    patrolWidgetTest('UI Test - Language Switching Flow', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // Tap language tile
      final langTile = find.text(I18nKeys.language.tr);
      if (langTile.evaluate().isNotEmpty) {
        await tester.tap(langTile);
        await tester.pumpAndSettle();

        // Switch to English in Dialog
        final englishOption = find.descendant(
          of: find.byType(Dialog),
          matching: find.text(AppLanguage.english.label),
        );
        if (englishOption.evaluate().isNotEmpty) {
          await tester.tap(englishOption);
          await tester.pumpAndSettle();

          expect(find.byType(SettingsPage), findsOneWidget);
        }

        // Tap language tile again and revert to Chinese
        final langTileEn = find.text(I18nKeys.language.tr);
        if (langTileEn.evaluate().isNotEmpty) {
          await tester.tap(langTileEn);
          await tester.pumpAndSettle();

          final chineseOption = find.descendant(
            of: find.byType(Dialog),
            matching: find.text(AppLanguage.chinese.label),
          );
          if (chineseOption.evaluate().isNotEmpty) {
            await tester.tap(chineseOption);
            await tester.pumpAndSettle();
          }
        }
      }
    });

    // ==========================================
    // CASE GROUP 14: Environment Switching Flow
    // ==========================================
    patrolWidgetTest('UI Test - Environment Switching Flow', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // Tap switch environment tile
      final envTile = find.text(I18nKeys.switchEnv.tr);
      if (envTile.evaluate().isEmpty) {
        await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
        await tester.pumpAndSettle();
      }
      if (envTile.evaluate().isNotEmpty) {
        await tester.tap(envTile);
        await tester.pumpAndSettle();

        // Switch to Mock Environment in Dialog
        final mockOption = find.descendant(
          of: find.byType(Dialog),
          matching: find.text(I18nKeys.envMock.tr),
        );
        if (mockOption.evaluate().isNotEmpty) {
          await tester.tap(mockOption);
          await tester.pumpAndSettle();
        }

        // Tap switch env tile and revert to Prod
        final envTileAfter = find.text(I18nKeys.switchEnv.tr);
        if (envTileAfter.evaluate().isNotEmpty) {
          await tester.tap(envTileAfter);
          await tester.pumpAndSettle();

          final prodOption = find.descendant(
            of: find.byType(Dialog),
            matching: find.text(I18nKeys.envProd.tr),
          );
          if (prodOption.evaluate().isNotEmpty) {
            await tester.tap(prodOption);
            await tester.pumpAndSettle();
          }
        }
      }
    });

    // ==========================================
    // CASE GROUP 15: Delete Account Danger Zone
    // ==========================================
    patrolWidgetTest('UI Test - Delete Account Danger Zone', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // Scroll until Delete Account tile is in view
      final deleteAccountTile = find.text(I18nKeys.deleteAccount.tr);
      try {
        await tester.scrollUntilVisible(deleteAccountTile, 100.0, scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
      } catch (_) {}

      if (deleteAccountTile.evaluate().isNotEmpty) {
        await tester.tap(deleteAccountTile, warnIfMissed: false);
        await waitForPage($, DeleteAccountPage);

        expect(find.byType(DeleteAccountPage), findsOneWidget);

        // Pop back to SettingsPage
        final backBtn = find.byType(BackButton);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await tester.pumpAndSettle();
        }
      }
    });

    // ==========================================
    // CASE GROUP 16: Crash Logs Diagnostic View
    // ==========================================
    patrolWidgetTest('UI Test - Crash Logs Diagnostic View', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // Scroll until Crash Reports tile is in view
      final crashTile = find.text(I18nKeys.crashReports.tr);
      try {
        await tester.scrollUntilVisible(crashTile, 100.0, scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
      } catch (_) {}

      if (crashTile.evaluate().isNotEmpty) {
        await tester.tap(crashTile, warnIfMissed: false);
        await waitForPage($, CrashLogListPage);

        expect(find.byType(CrashLogListPage), findsOneWidget);

        // Pop back to SettingsPage
        final backBtn = find.byType(BackButton);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await tester.pumpAndSettle();
        }
      }
    });

    // ==========================================
    // CASE GROUP 17: Overview Quick Actions Navigation
    // ==========================================
    patrolWidgetTest('UI Test - Overview Quick Actions Navigation', ($) async {
      final tester = $.tester;
      await performUiLogin($, 'test_user', 'password123');

      expect(find.byType(HomePage), findsOneWidget);

      // Ensure Overview tab is active
      tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();
      final overviewItem = find.descendant(
        of: find.byType(Drawer),
        matching: find.byIcon(Icons.dashboard_customize_outlined),
      );
      if (overviewItem.evaluate().isNotEmpty) {
        await tester.tap(overviewItem);
        await tester.pumpAndSettle();
      }

      // Check QuickActions card: Architecture
      final quickActions = find.byType(QuickActions);
      if (quickActions.evaluate().isNotEmpty) {
        try {
          await tester.scrollUntilVisible(quickActions, 100.0, scrollable: find.byType(Scrollable).first);
          await tester.pumpAndSettle();
        } catch (_) {}

        final archCard = find.descendant(
          of: quickActions,
          matching: find.byIcon(Icons.account_tree_outlined),
        );
        if (archCard.evaluate().isNotEmpty) {
          await tester.tap(archCard, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Return to Overview
        tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
        await tester.pumpAndSettle();
        final returnOverview = find.descendant(
          of: find.byType(Drawer),
          matching: find.byIcon(Icons.dashboard_customize_outlined),
        );
        if (returnOverview.evaluate().isNotEmpty) {
          await tester.tap(returnOverview);
          await tester.pumpAndSettle();
        }
      }
    });

    // ==========================================
    // CASE GROUP 18: AI Chat Mode Selector & Preset QA Flow
    // ==========================================
    patrolWidgetTest('UI Test - AI Chat Mode Selector and Preset QA Flow', ($) async {
      final tester = $.tester;
      await performUiLogin($, 'test_user', 'password123');

      expect(find.byType(HomePage), findsOneWidget);

      // Tap global floating AI FAB to open AI Chat Sheet
      final aiFab = find.byType(FloatingActionButton);
      if (aiFab.evaluate().isNotEmpty) {
        await tester.tap(aiFab);
        await tester.pumpAndSettle();
      }

      if (find.byType(AiChatPage).evaluate().isNotEmpty) {

        // Tap a preset question chip if available
        final chipFinder = find.byType(ActionChip);
        if (chipFinder.evaluate().isNotEmpty) {
          await tester.tap(chipFinder.first);
          await tester.pump(const Duration(milliseconds: 300));
          await Future<void>.delayed(const Duration(milliseconds: 150));
          await tester.pumpAndSettle();
        }

        // Clear history
        final clearHistoryIcon = find.byIcon(Icons.delete_sweep_outlined);
        if (clearHistoryIcon.evaluate().isNotEmpty) {
          await tester.tap(clearHistoryIcon);
          await tester.pumpAndSettle();
        }

        // Close AI panel
        final closeIcon = find.byIcon(Icons.close);
        if (closeIcon.evaluate().isNotEmpty) {
          await tester.tap(closeIcon);
          await tester.pumpAndSettle();
        }
      }
    });

    // ==========================================
    // CASE GROUP 19: Reset Settings to Defaults Flow
    // ==========================================
    patrolWidgetTest('UI Test - Reset Settings to Defaults Flow', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      final resetTile = find.text(I18nKeys.resetSettings.tr);
      try {
        await tester.scrollUntilVisible(resetTile, 100.0, scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
      } catch (_) {}

      if (resetTile.evaluate().isNotEmpty) {
        await tester.tap(resetTile, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Check if confirm dialog appeared
        final confirmBtn = find.text(I18nKeys.confirm.tr);
        if (confirmBtn.evaluate().isNotEmpty) {
          await tester.tap(confirmBtn);
          await tester.pumpAndSettle();
        } else {
          final okBtn = find.text(I18nKeys.ok.tr);
          if (okBtn.evaluate().isNotEmpty) {
            await tester.tap(okBtn);
            await tester.pumpAndSettle();
          }
        }
      }
    });

    // ==========================================
    // CASE GROUP 20: Simulate Token Expired & 401 Interceptor Flow
    // ==========================================
    patrolWidgetTest('UI Test - Simulate Token Expired & 401 Interceptor Flow', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // Activate developer mode by tapping version tile 5 times
      final versionTile = find.byType(SettingsVersionTile);
      if (versionTile.evaluate().isNotEmpty) {
        try {
          await tester.scrollUntilVisible(versionTile, 100.0, scrollable: find.byType(Scrollable).first);
          await tester.pumpAndSettle();
        } catch (_) {}
        for (int i = 0; i < 5; i++) {
          await tester.tap(versionTile, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 100));
        }
        await tester.pumpAndSettle();
      }

      // Tap Simulate Token Expired tile
      final simulateExpiredTile = find.text(I18nKeys.simulateTokenExpired.tr);
      try {
        await tester.scrollUntilVisible(simulateExpiredTile, 100.0, scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
      } catch (_) {}

      if (simulateExpiredTile.evaluate().isNotEmpty) {
        await tester.tap(simulateExpiredTile, warnIfMissed: false);
        await tester.pumpAndSettle();
      }
    });

    // ==========================================
    // CASE GROUP 21: Common WebView & JS Bridge Test
    // ==========================================
    patrolWidgetTest('UI Test - Common WebView & JS Bridge Test', ($) async {
      final tester = $.tester;
      await navigateToSettings($);

      expect(find.byType(SettingsPage), findsOneWidget);

      // Activate developer mode
      final versionTile = find.byType(SettingsVersionTile);
      if (versionTile.evaluate().isNotEmpty) {
        try {
          await tester.scrollUntilVisible(versionTile, 100.0, scrollable: find.byType(Scrollable).first);
          await tester.pumpAndSettle();
        } catch (_) {}
        for (int i = 0; i < 5; i++) {
          await tester.tap(versionTile, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 100));
        }
        await tester.pumpAndSettle();
      }

      // Tap WebView Test tile
      final webViewTile = find.text(I18nKeys.webViewTestTitle.tr);
      try {
        await tester.scrollUntilVisible(webViewTile, 100.0, scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
      } catch (_) {}

      if (webViewTile.evaluate().isNotEmpty) {
        await tester.tap(webViewTile, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Pop back to SettingsPage
        final backBtn = find.byType(BackButton);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await tester.pumpAndSettle();
        }
      }
    });

    // ==========================================
    // CASE GROUP 22: Terms of Service & Privacy Policy Navigation
    // ==========================================
    patrolWidgetTest('UI Test - Terms of Service & Privacy Policy Navigation', ($) async {
      final tester = $.tester;
      await bootAppAndGoToLogin($);

      expect(find.byType(LoginPage), findsOneWidget);

      // Tap Terms of Service link in login agreement
      final tosLink = find.text(I18nKeys.termsOfService.tr);
      if (tosLink.evaluate().isNotEmpty) {
        await tester.tap(tosLink);
        await tester.pumpAndSettle();

        // Pop back to LoginPage
        final backBtn = find.byType(BackButton);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await tester.pumpAndSettle();
        }
      }

      // Tap Privacy Policy link in login agreement
      final privacyLink = find.text(I18nKeys.privacyPolicy.tr);
      if (privacyLink.evaluate().isNotEmpty) {
        await tester.tap(privacyLink);
        await tester.pumpAndSettle();

        // Pop back to LoginPage
        final backBtn = find.byType(BackButton);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await tester.pumpAndSettle();
        }
      }
    });
  });
}

class FakeIapService implements IIapService {
  @override
  Future<void> initialize() async {}

  @override
  Future<List<ProductDetails>> queryProducts(Set<String> productIds) async => [];

  @override
  Future<void> buyProduct(ProductDetails product) async {}

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => const Stream.empty();

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}
}

class FakeNotificationService implements INotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<String?> getToken() async => 'fake_fcm_token';

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Stream<NotificationPayload> get onMessageReceived => const Stream.empty();

  @override
  Stream<NotificationPayload> get onMessageOpenedApp => const Stream.empty();

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}
}
