import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';

part 'overview_state.freezed.dart';

@freezed
abstract class OverviewState extends BaseState with _$OverviewState {
  const factory OverviewState({
    @Default(false) bool isInitialLoaded,
    @Default([]) List<ProjectModel> featuredProjects,
    AboutMeModel? aboutMe,
  }) = _OverviewState;

  const OverviewState._();
}
