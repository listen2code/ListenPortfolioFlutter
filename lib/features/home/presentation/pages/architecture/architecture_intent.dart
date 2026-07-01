import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_registry_init.dart';

part 'architecture_intent.freezed.dart';

@freezed
class ArchitectureIntent extends BaseIntent with _$ArchitectureIntent {
  const factory ArchitectureIntent.refresh() = _Refresh;
  const factory ArchitectureIntent.launchURL(String url) = _LaunchURL;

  const ArchitectureIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register(
      'ArchitectureIntent',
      'refresh',
      (args) => const ArchitectureIntent.refresh(),
    );
    MviPlaybackRegistry.register(
      'ArchitectureIntent',
      'launchURL',
      (args) => ArchitectureIntent.launchURL(args['url'] ?? ''),
    );
  }
}
