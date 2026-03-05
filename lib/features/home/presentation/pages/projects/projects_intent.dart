import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'projects_intent.freezed.dart';

@freezed
class ProjectsIntent extends BaseIntent with _$ProjectsIntent {
  const factory ProjectsIntent.refresh() = _Refresh;
  const ProjectsIntent._();
}
