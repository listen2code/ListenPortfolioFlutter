import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide RoutePageBuilder;
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/password/change_password_page.dart';
import '../../features/auth/presentation/pages/password/forgot_password_page.dart';
import '../../features/auth/presentation/pages/sign_up/sign_up_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/appearance/appearance_page.dart';
import '../../features/settings/presentation/pages/crash_log_list/crash_log_list_page.dart';
import '../../features/settings/presentation/pages/delete_account/delete_account_page.dart';
import '../../features/settings/presentation/pages/privacy_policy/privacy_policy_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/terms_of_service/terms_of_service_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/resume/resume_page.dart';

/// Centralized route definitions and registry for the application.
class Routes {
  Routes._();

  // Route Path Constants
  static const String root = '/splash';
  static const String home = '/home';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgot_password';
  static const String changePassword = '/change_password';
  static const String settings = '/settings';
  static const String appearance = '/appearance';
  static const String deleteAccount = '/delete_account';
  static const String crashLogs = '/crash_logs';
  static const String termsOfService = '/terms_of_service';
  static const String privacyPolicy = '/privacy_policy';
  static const String webViewTest = '/webview_test';
  static const String resume = '/resume';

  // Argument Keys - Enforce consistency between caller and receiver
  static const String argName = 'name';
  static const String argFilePath = 'file_path';
  static const String argCheckUpdate = 'check_update';

  /// The complete route map linking paths to their respective widget builders.
  static Map<String, RoutePageBuilder> get routes => {
    root: () => const SplashPage(),
    home: () => const HomePage(),

    /// login
    login: () => const LoginPage(),
    signUp: () => const SignUpPage(),
    forgotPassword: () => const ForgotPasswordPage(),
    changePassword: () => const ChangePasswordPage(),

    /// setting
    settings: () => const SettingsPage(),
    appearance: () => const AppearancePage(),
    deleteAccount: () => const DeleteAccountPage(),
    crashLogs: () => const CrashLogListPage(),
    termsOfService: () => const TermsOfServicePage(),
    privacyPolicy: () => const PrivacyPolicyPage(),
    resume: () => const ResumePage(),
    webViewTest: () => FutureBuilder<String>(
      future: rootBundle.loadString('assets/html/test.html'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return CommonWebView(
          showAppBar: true,
          shrinkWrap: false,
          initialHtml: snapshot.data,
          javascriptHandlers: {
            'showToast': (List<dynamic> args) {
              if (args.isNotEmpty) {
                final msg = args[0] as String;
                CommonToast.show(msg);
              }
            },
            'closePage': (List<dynamic> args) {
              Navigator.of(context).pop();
            },
            'getDeviceInfo': (List<dynamic> args) async {
              return {
                'platform': defaultTargetPlatform.name,
                'device': 'Flutter Emulator (SettingsPage Debug)',
                'timestamp': DateTime.now().toLocal().toString(),
              };
            },
          },
          shouldOverrideUrlLoadingWithAction: (InAppWebViewController controller, NavigationAction action) async {
            final url = action.request.url?.toString() ?? '';
            if (url.startsWith('myapp://')) {
              CommonToast.show('拦截到 Scheme 动作: $url');
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
        );
      },
    ),
  };
}
