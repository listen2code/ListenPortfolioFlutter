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

    subscribeEvent<CommonEvent<AppLanguage>>(
      (_) => updateState(state.copyWith(isInitialLoaded: false)),
      key: AppConstants.languageChangedEventKey,
    );

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
      scrollToProject: _onScrollToProject,
    );
  }

  void _onScrollToProject(String businessId) {
    if (state.projects.isEmpty) {
      updateState(state.copyWith(targetBusinessId: businessId));
    } else {
      final index = state.projects.indexWhere(
        (p) => p.businessId == businessId || p.id?.toString() == businessId,
      );
      if (index != -1) {
        emitEffect(ScrollToProjectEffect(index: index, businessId: businessId));
      }
    }
  }

  Future<void> _onRefresh() async {
    await call(
      ref.execute<List<ProjectModel>, BaseParam>(getProjectsUseCaseProvider),
      showLoading: true,
      loadingType: LoadingType.page,
      onSuccess: (projects) {
        final targetId = state.targetBusinessId;
        updateState(state.copyWith(projects: projects, isInitialLoaded: true, targetBusinessId: null));
        if (targetId != null) {
          final index = projects.indexWhere(
            (p) => p.businessId == targetId || p.id?.toString() == targetId,
          );
          if (index != -1) {
            emitEffect(ScrollToProjectEffect(index: index, businessId: targetId));
          }
        }
      },
    );
  }
}
