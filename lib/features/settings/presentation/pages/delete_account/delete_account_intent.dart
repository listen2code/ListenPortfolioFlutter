import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_registry_init.dart';

part 'delete_account_intent.freezed.dart';

@freezed
class DeleteAccountIntent extends BaseIntent with _$DeleteAccountIntent {
  const factory DeleteAccountIntent.toggleConfirm() = _ToggleConfirm;
  const factory DeleteAccountIntent.deleteAccount() = _DeleteAccount;
  const DeleteAccountIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register(
      'DeleteAccountIntent',
      'toggleConfirm',
      (args) => const DeleteAccountIntent.toggleConfirm(),
    );
    MviPlaybackRegistry.register(
      'DeleteAccountIntent',
      'deleteAccount',
      (args) => const DeleteAccountIntent.deleteAccount(),
    );
  }
}
