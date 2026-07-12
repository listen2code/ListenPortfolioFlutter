import 'package:listen_core/core.dart';

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
import '../../features/ai_chat/presentation/pages/ai_chat_intent.dart';

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
  AiChatIntent.registerPlayback();
}

/// Static deserializer registry to reconstruct Intent instances in a reflectionless Flutter environment.
mixin MviPlaybackRegistry {
  static final Map<String, Map<String, BaseIntent? Function(Map<String, String> args)>> _deserializers = {};

  /// Returns all registered classes and their constructor names for testing verification.
  static Map<String, Set<String>> get registeredKeys =>
      _deserializers.map((k, v) => MapEntry(k, v.keys.toSet()));

  /// Register a custom deserializer dynamically for modular/decoupled features.
  static void register(
    String className,
    String constructorName,
    BaseIntent? Function(Map<String, String> args) deserializer,
  ) {
    _deserializers.putIfAbsent(className, () => {})[constructorName] = deserializer;
  }

  static BaseIntent? parseAndDeserialize(String intentStr) {
    final regex = RegExp(r'^([a-zA-Z0-9_]+)\.([a-zA-Z0-9_]+)\((.*)\)$');
    final match = regex.firstMatch(intentStr.trim());
    if (match == null) return null;

    final className = match.group(1)!;
    final constructorName = match.group(2)!;
    final body = match.group(3)!;

    final args = <String, String>{};
    if (body.isNotEmpty) {
      final pairs = body.split(', ');
      for (var pair in pairs) {
        final parts = pair.split(': ');
        if (parts.length >= 2) {
          args[parts[0].trim()] = parts.sublist(1).join(': ').trim();
        }
      }
    }
    return deserialize(className, constructorName, args);
  }

  static BaseIntent? deserialize(String className, String constructorName, Map<String, String> args) {
    final classMap = _deserializers[className];
    if (classMap != null) {
      final deserializer = classMap[constructorName];
      if (deserializer != null) {
        return deserializer(args);
      }
    }
    return null;
  }
}
