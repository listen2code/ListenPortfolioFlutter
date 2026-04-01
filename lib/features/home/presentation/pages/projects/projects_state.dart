import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';

part 'projects_state.freezed.dart';

@freezed
abstract class ProjectsState extends BaseState with _$ProjectsState {
  const factory ProjectsState({
    @Default([]) List<ProjectModel> projects,
    @Default(false) bool isInitialLoaded,
  }) = _ProjectsState;

  const ProjectsState._();
}
