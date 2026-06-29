import '../../features/auth/presentation/pages/login/login_intent.dart';
import '../../features/auth/presentation/pages/sign_up/sign_up_intent.dart';
import '../../features/auth/presentation/pages/password/forgot_password_intent.dart';
import '../../features/auth/presentation/pages/password/change_password_intent.dart';
import '../../features/home/presentation/pages/home_intent.dart';
import '../../features/settings/presentation/pages/settings_intent.dart';
import '../../features/home/presentation/pages/overview/overview_intent.dart';
import '../../features/home/presentation/pages/about_me/about_me_intent.dart';
import '../../features/home/presentation/pages/architecture/architecture_intent.dart';
import '../../features/home/presentation/pages/projects/projects_intent.dart';
import '../../features/home/presentation/pages/resume/resume_intent.dart';
import '../../features/settings/presentation/pages/appearance/appearance_intent.dart';
import '../../features/settings/presentation/pages/crash_log_list/crash_log_list_intent.dart';
import '../../features/settings/presentation/pages/delete_account/delete_account_intent.dart';
import '../../features/settings/presentation/pages/privacy_policy/privacy_policy_intent.dart';
import '../../features/settings/presentation/pages/terms_of_service/terms_of_service_intent.dart';
import '../../features/splash/presentation/pages/splash_intent.dart';

/// Initializes the MVI Playback registry with deserializers by delegating to each specific Intent class.
void initMviPlaybackRegistry() {
  LoginIntent.registerPlayback();
  SignUpIntent.registerPlayback();
  ForgotPasswordIntent.registerPlayback();
  ChangePasswordIntent.registerPlayback();
  HomeIntent.registerPlayback();
  SettingsIntent.registerPlayback();
  OverviewIntent.registerPlayback();
  AboutMeIntent.registerPlayback();
  ArchitectureIntent.registerPlayback();
  ProjectsIntent.registerPlayback();
  ResumeIntent.registerPlayback();
  AppearanceIntent.registerPlayback();
  CrashLogListIntent.registerPlayback();
  DeleteAccountIntent.registerPlayback();
  PrivacyPolicyIntent.registerPlayback();
  TermsOfServiceIntent.registerPlayback();
  SplashIntent.registerPlayback();
}
