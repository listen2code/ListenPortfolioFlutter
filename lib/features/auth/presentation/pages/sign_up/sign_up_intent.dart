import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../shared/utils/playback_registry_init.dart';

part 'sign_up_intent.freezed.dart';

@freezed
class SignUpIntent extends BaseIntent with _$SignUpIntent {
  const factory SignUpIntent.fullNameChanged(String name) = _FullNameChanged;
  const factory SignUpIntent.emailChanged(String email) = _EmailChanged;
  const factory SignUpIntent.passwordChanged(String password) = _PasswordChanged;
  const factory SignUpIntent.confirmPasswordChanged(String password) = _ConfirmPasswordChanged;
  const factory SignUpIntent.submitSignUp() = _SubmitSignUp;
  const factory SignUpIntent.navigateToLogin() = _NavigateToLogin;

  const SignUpIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register(
      'SignUpIntent',
      'fullNameChanged',
      (args) => SignUpIntent.fullNameChanged(args['name'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'SignUpIntent',
      'emailChanged',
      (args) => SignUpIntent.emailChanged(args['email'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'SignUpIntent',
      'passwordChanged',
      (args) => SignUpIntent.passwordChanged(args['password'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'SignUpIntent',
      'confirmPasswordChanged',
      (args) => SignUpIntent.confirmPasswordChanged(args['password'] ?? ''),
    );
    MviPlaybackRegistry.register('SignUpIntent', 'submitSignUp', (args) => const SignUpIntent.submitSignUp());
    MviPlaybackRegistry.register(
      'SignUpIntent',
      'navigateToLogin',
      (args) => const SignUpIntent.navigateToLogin(),
    );
  }
}
