import 'dart:async';

import '../../../data/models/project_model.dart';
import '../../provider/projects_provider.dart';
import '../../../../../shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'projects_intent.dart';
import 'projects_state.dart';

part 'projects_view_model.g.dart';

@riverpod
class ProjectsViewModel extends _$ProjectsViewModel with ViewModelMixin<ProjectsState, ProjectsIntent> {
  @override
  ProjectsState build() {
    authManager.addListener(_onAuthStatusChanged);
    ref.onDispose(() {
      authManager.removeListener(_onAuthStatusChanged);
    });
    return const ProjectsState();
  }

  void _onAuthStatusChanged() {
    updateState(const ProjectsState());
  }

  @override
  void onVisible() {
    super.onVisible();
    if (!state.isInitialLoaded) {
      handleIntent(const ProjectsIntent.refresh());
    }
  }

  @override
  FutureOr<void> onIntent(ProjectsIntent intent) {
    return intent.when<FutureOr<void>>(
      refresh: () => _onRefresh(),
      launchURL: (url) => emitEffect(LaunchUrlEffect(url)),
    );
  }

  Future<void> _onRefresh() async {
    await call(
      ref.execute<List<ProjectModel>, BaseParam>(getProjectsUseCaseProvider),
      showLoading: true,
      loadingType: LoadingType.page,
      onSuccess: (projects) {
        updateState(state.copyWith(projects: projects, isInitialLoaded: true));
      },
    );
  }
}
