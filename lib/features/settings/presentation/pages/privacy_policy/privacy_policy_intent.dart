import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_observer_manager.dart';

part 'privacy_policy_intent.freezed.dart';

@freezed
class PrivacyPolicyIntent extends BaseIntent with _$PrivacyPolicyIntent {
  const factory PrivacyPolicyIntent.refresh() = _Refresh;

  const PrivacyPolicyIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('PrivacyPolicyIntent', 'refresh', (args) => const PrivacyPolicyIntent.refresh());
  }
}
