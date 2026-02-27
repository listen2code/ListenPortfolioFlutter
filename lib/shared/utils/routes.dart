import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/crash_log_list_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/terms_of_service_page.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_page.dart';

/// Centralized route definitions and registry for the application.
class Routes {
  Routes._();

  // Route Path Constants
  static const String root = "/splash";
  static const String home = "/home";
  static const String login = "/login";
  static const String signUp = "/signUp";
  static const String forgotPassword = "/forgot_password";
  static const String changePassword = "/change_password";
  static const String deleteAccount = "/delete_account";
  static const String settings = "/settings";
  static const String appearance = "/appearance";
  static const String crashLogs = "/crash_logs";
  static const String termsOfService = "/terms_of_service";
  static const String privacyPolicy = "/privacy_policy";

  // Argument Keys - Enforce consistency between caller and receiver
  static const String argName = "name";
  static const String argFilePath = "file_path";

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
  };
}
