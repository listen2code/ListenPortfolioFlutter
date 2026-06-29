import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_observer_manager.dart';

part 'forgot_password_intent.freezed.dart';

@freezed
class ForgotPasswordIntent extends BaseIntent with _$ForgotPasswordIntent {
  const factory ForgotPasswordIntent.emailChanged(String email) = _EmailChanged;
  const factory ForgotPasswordIntent.submitReset() = _SubmitReset;
  const factory ForgotPasswordIntent.navigateToLogin() = _NavigateToLogin;
  const ForgotPasswordIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('ForgotPasswordIntent', 'emailChanged', (args) => ForgotPasswordIntent.emailChanged(args['email'] ?? ''));
    MviPlaybackRegistry.register('ForgotPasswordIntent', 'submitReset', (args) => const ForgotPasswordIntent.submitReset());
    MviPlaybackRegistry.register('ForgotPasswordIntent', 'navigateToLogin', (args) => const ForgotPasswordIntent.navigateToLogin());
  }
}
