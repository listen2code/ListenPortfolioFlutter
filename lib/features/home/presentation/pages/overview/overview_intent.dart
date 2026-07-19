import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_registry_init.dart';

part 'overview_intent.freezed.dart';

@freezed
class OverviewIntent extends BaseIntent with _$OverviewIntent {
  const factory OverviewIntent.refresh() = _Refresh;
  const factory OverviewIntent.launchURL(String url) = _LaunchURL;
  const factory OverviewIntent.contactMe(String email) = _ContactMe;
  const OverviewIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('OverviewIntent', 'refresh', (args) => const OverviewIntent.refresh());
    MviPlaybackRegistry.register(
      'OverviewIntent',
      'launchURL',
      (args) => OverviewIntent.launchURL(args['url'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'OverviewIntent',
      'contactMe',
      (args) => OverviewIntent.contactMe(args['email'] ?? ''),
    );
  }
}
