import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'projects_state.freezed.dart';

@freezed
abstract class ProjectsState extends BaseState with _$ProjectsState {
  const factory ProjectsState({
    @Default([]) List<Map<String, dynamic>> projects,
    @Default(false) bool isInitialLoaded,
  }) = _ProjectsState;

  const ProjectsState._();
}
