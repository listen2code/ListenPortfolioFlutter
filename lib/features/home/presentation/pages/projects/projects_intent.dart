import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_registry_init.dart';

part 'projects_intent.freezed.dart';

@freezed
class ProjectsIntent extends BaseIntent with _$ProjectsIntent {
  const factory ProjectsIntent.refresh() = _Refresh;
  const factory ProjectsIntent.launchURL(String url) = _LaunchURL;
  const factory ProjectsIntent.scrollToProject(String businessId) = _ScrollToProject;
  const ProjectsIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('ProjectsIntent', 'refresh', (args) => const ProjectsIntent.refresh());
    MviPlaybackRegistry.register(
      'ProjectsIntent',
      'launchURL',
      (args) => ProjectsIntent.launchURL(args['url'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'ProjectsIntent',
      'scrollToProject',
      (args) => ProjectsIntent.scrollToProject(args['businessId'] ?? ''),
    );
  }
}
