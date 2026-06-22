import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'projects_intent.freezed.dart';

@freezed
class ProjectsIntent extends BaseIntent with _$ProjectsIntent {
  const factory ProjectsIntent.refresh() = _Refresh;
  const factory ProjectsIntent.launchURL(String url) = _LaunchURL;
  const ProjectsIntent._();
}
