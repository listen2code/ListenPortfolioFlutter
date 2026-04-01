import 'dart:async';

import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/projects_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'projects_intent.dart';
import 'projects_state.dart';

part 'projects_view_model.g.dart';

@riverpod
class ProjectsViewModel extends _$ProjectsViewModel with ViewModelMixin<ProjectsState, ProjectsIntent> {
  @override
  ProjectsState build() => const ProjectsState();

  @override
  void onVisible() {
    super.onVisible();
    if (!state.isInitialLoaded) {
      handleIntent(const ProjectsIntent.refresh());
    }
  }

  @override
  FutureOr<void> onIntent(ProjectsIntent intent) {
    return intent.when<FutureOr<void>>(refresh: () => _onRefresh());
  }

  Future<void> _onRefresh() async {
    await call(
      ref.execute(getProjectsUseCaseProvider),
      showLoading: true,
      loadingType: LoadingType.page,
      onSuccess: (projects) {
        updateState(state.copyWith(projects: projects as List<ProjectModel>, isInitialLoaded: true));
      },
    );
  }
}
