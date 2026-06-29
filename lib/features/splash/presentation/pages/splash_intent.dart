import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../shared/utils/playback_observer_manager.dart';

part 'splash_intent.freezed.dart';

@freezed
class SplashIntent extends BaseIntent with _$SplashIntent {
  const factory SplashIntent.init() = _Init;
  const SplashIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('SplashIntent', 'init', (args) => const SplashIntent.init());
  }
}
