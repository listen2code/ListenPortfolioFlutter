import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../shared/utils/playback_registry_init.dart';

part 'login_intent.freezed.dart';

@freezed
class LoginIntent extends BaseIntent with _$LoginIntent {
  const factory LoginIntent.usernameChanged(String username) = _UsernameChanged;
  const factory LoginIntent.passwordChanged(String password) = _PasswordChanged;
  const factory LoginIntent.togglePasswordVisibility() = _TogglePasswordVisibility;
  const factory LoginIntent.toggleRememberMe() = _ToggleRememberMe;
  const factory LoginIntent.submitLogin() = _SubmitLogin;
  const factory LoginIntent.navigateToSignup() = _NavigateToSignup;
  const factory LoginIntent.navigateToForgotPassword() = _NavigateToForgotPassword;
  const factory LoginIntent.skipLogin() = _SkipLogin;
  const LoginIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register(
      'LoginIntent',
      'usernameChanged',
      (args) => LoginIntent.usernameChanged(args['username'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'LoginIntent',
      'passwordChanged',
      (args) => LoginIntent.passwordChanged(args['password'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'LoginIntent',
      'togglePasswordVisibility',
      (args) => const LoginIntent.togglePasswordVisibility(),
    );
    MviPlaybackRegistry.register(
      'LoginIntent',
      'toggleRememberMe',
      (args) => const LoginIntent.toggleRememberMe(),
    );
    MviPlaybackRegistry.register('LoginIntent', 'submitLogin', (args) => const LoginIntent.submitLogin());
    MviPlaybackRegistry.register(
      'LoginIntent',
      'navigateToSignup',
      (args) => const LoginIntent.navigateToSignup(),
    );
    MviPlaybackRegistry.register(
      'LoginIntent',
      'navigateToForgotPassword',
      (args) => const LoginIntent.navigateToForgotPassword(),
    );
    MviPlaybackRegistry.register('LoginIntent', 'skipLogin', (args) => const LoginIntent.skipLogin());
  }
}
