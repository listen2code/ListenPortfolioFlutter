import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

import '../../../../../../shared/utils/playback_registry_init.dart';

part 'terms_of_service_intent.freezed.dart';

@freezed
class TermsOfServiceIntent extends BaseIntent with _$TermsOfServiceIntent {
  const factory TermsOfServiceIntent.init() = _Init;
  const TermsOfServiceIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('TermsOfServiceIntent', 'init', (args) => const TermsOfServiceIntent.init());
  }
}
