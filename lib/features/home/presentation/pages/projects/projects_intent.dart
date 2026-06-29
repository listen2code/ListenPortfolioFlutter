import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_observer_manager.dart';

part 'projects_intent.freezed.dart';

@freezed
class ProjectsIntent extends BaseIntent with _$ProjectsIntent {
  const factory ProjectsIntent.refresh() = _Refresh;
  const factory ProjectsIntent.launchURL(String url) = _LaunchURL;
  const ProjectsIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('ProjectsIntent', 'refresh', (args) => const ProjectsIntent.refresh());
    MviPlaybackRegistry.register('ProjectsIntent', 'launchURL', (args) => ProjectsIntent.launchURL(args['url'] ?? ''));
  }
}
