import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_observer_manager.dart';

part 'overview_intent.freezed.dart';

@freezed
class OverviewIntent extends BaseIntent with _$OverviewIntent {
  const factory OverviewIntent.refresh() = _Refresh;
  const factory OverviewIntent.launchURL(String url) = _LaunchURL;
  const OverviewIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('OverviewIntent', 'refresh', (args) => const OverviewIntent.refresh());
    MviPlaybackRegistry.register('OverviewIntent', 'launchURL', (args) => OverviewIntent.launchURL(args['url'] ?? ''));
  }
}
