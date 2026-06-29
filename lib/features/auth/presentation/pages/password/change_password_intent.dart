import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_observer_manager.dart';

part 'change_password_intent.freezed.dart';

@freezed
class ChangePasswordIntent extends BaseIntent with _$ChangePasswordIntent {
  const factory ChangePasswordIntent.oldPasswordChanged(String password) = _OldPasswordChanged;
  const factory ChangePasswordIntent.newPasswordChanged(String password) = _NewPasswordChanged;
  const factory ChangePasswordIntent.confirmPasswordChanged(String password) = _ConfirmPasswordChanged;
  const factory ChangePasswordIntent.submitChange() = _SubmitChange;

  const ChangePasswordIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('ChangePasswordIntent', 'oldPasswordChanged', (args) => ChangePasswordIntent.oldPasswordChanged(args['password'] ?? ''));
    MviPlaybackRegistry.register('ChangePasswordIntent', 'newPasswordChanged', (args) => ChangePasswordIntent.newPasswordChanged(args['password'] ?? ''));
    MviPlaybackRegistry.register('ChangePasswordIntent', 'confirmPasswordChanged', (args) => ChangePasswordIntent.confirmPasswordChanged(args['password'] ?? ''));
    MviPlaybackRegistry.register('ChangePasswordIntent', 'submitChange', (args) => const ChangePasswordIntent.submitChange());
  }
}
