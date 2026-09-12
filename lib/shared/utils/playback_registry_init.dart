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
import '../../features/settings/presentation/pages/playback_tape_list/playback_tape_list_intent.dart';
import '../../features/splash/presentation/pages/splash_intent.dart';
import '../../features/ai_chat/presentation/pages/ai_chat_intent.dart';
import '../../features/settings/presentation/pages/widgets/coffee_purchase/coffee_purchase_intent.dart';
import '../../features/fault_injection/presentation/pages/fault_injection_intent.dart';

/// Initializes the MVI Playback registry with deserializers by delegating to each specific Intent class.
///
/// In Flutter's AOT (Ahead-Of-Time) compiled runtime, reflection (`dart:mirrors`) is disabled
/// to preserve tree-shaking and minimal binary size. Therefore, Intent reconstruction from
/// persisted tape strings must rely on explicit static registrations.
///
/// This bootstrap method registers deserialization closures for every feature's Intent family
/// before playback sessions are executed.
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
  PlaybackTapeListIntent.registerPlayback();
  SplashIntent.registerPlayback();
  AiChatIntent.registerPlayback();
  CoffeePurchaseIntent.registerPlayback();
  FaultInjectionIntent.registerPlayback();
}

/// Static deserializer registry to reconstruct concrete [BaseIntent] instances in a reflectionless Flutter environment.
///
/// Design Pattern:
/// - **Registry Pattern**: Maintains a two-level lookup table: `[ClassName] -> [ConstructorName] -> DeserializerClosure`.
/// - **Zero Mirrors**: Achieves 100% tree-shakeable, type-safe deserialization without `dart:mirrors`.
/// - **Decoupled Registration**: Individual feature modules register their own intent factories,
///   maintaining Clean Architecture boundary isolation.
mixin MviPlaybackRegistry {
  /// Internal registry mapping: `ClassName -> {ConstructorName -> DeserializerClosure}`.
  static final Map<String, Map<String, BaseIntent? Function(Map<String, String> args)>> _deserializers = {};

  /// Returns all registered class names and their associated constructor names.
  ///
  /// Useful for automated unit tests verifying that all required features have registered their intents.
  static Map<String, Set<String>> get registeredKeys =>
      _deserializers.map((k, v) => MapEntry(k, v.keys.toSet()));

  /// Registers a deserializer closure for a given [className] and [constructorName].
  ///
  /// Example:
  /// ```dart
  /// MviPlaybackRegistry.register(
  ///   'LoginIntent',
  ///   'inputAccount',
  ///   (args) => LoginIntent.inputAccount(args['account'] ?? ''),
  /// );
  /// ```
  static void register(
    String className,
    String constructorName,
    BaseIntent? Function(Map<String, String> args) deserializer,
  ) {
    _deserializers.putIfAbsent(className, () => {})[constructorName] = deserializer;
  }

  /// Parses a serialized Intent string representation and reconstructs the typed [BaseIntent] object.
  ///
  /// Supported string format:
  /// `ClassName.constructorName(param1: value1, param2: value2)`
  /// or
  /// `ClassName.constructorName()`
  ///
  /// Parsing Algorithm:
  /// 1. Uses a regular expression `^([a-zA-Z0-9_]+)\.([a-zA-Z0-9_]+)\((.*)\)$` to extract:
  ///    - Group 1: Class Name (e.g. `LoginIntent`)
  ///    - Group 2: Constructor / Named Factory (e.g. `inputAccount`)
  ///    - Group 3: Argument parameter body (e.g. `account: test@example.com`)
  /// 2. Splits parameter body by `, ` and key-values by `: `.
  /// 3. Forwards extracted arguments to [deserialize].
  ///
  /// Returns null if the format is invalid or no matching deserializer is found.
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

  /// Looks up and invokes the registered deserializer closure with parsed [args].
  ///
  /// Returns the instantiated [BaseIntent], or null if the class or constructor is unregistered.
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

