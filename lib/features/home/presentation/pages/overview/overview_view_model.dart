import 'dart:async';

import 'package:listen_core/core.dart';
import '../../../data/models/about_me_model.dart';
import '../../../data/models/project_model.dart';
import '../../provider/about_me_provider.dart';
import '../../provider/projects_provider.dart';
import '../../../../../shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'overview_intent.dart';
import 'overview_state.dart';

part 'overview_view_model.g.dart';

@riverpod
class OverviewViewModel extends _$OverviewViewModel with ViewModelMixin<OverviewState, OverviewIntent> {
  @override
  OverviewState build() => const OverviewState();

  @override
  void onVisible() {
    super.onVisible();
    if (!state.isInitialLoaded) {
      handleIntent(const OverviewIntent.refresh());
    }
  }

  @override
  FutureOr<void> onIntent(OverviewIntent intent) {
    return intent.when<FutureOr<void>>(refresh: () => _onRefresh());
  }

  Future<void> _onRefresh() async {
    if (authManager.state.isGuest) return;

    await callAll(
      [
        ref.execute<List<ProjectModel>, BaseParam>(getProjectsUseCaseProvider),
        ref.execute<AboutMeModel, BaseParam>(getAboutMeUseCaseProvider),
      ],
      showLoading: true,
      loadingType: LoadingType.page,
      onSuccess: (results) {
        final projects = (results[0] as List<ProjectModel>).take(2).toList();
        updateState(state.copyWith(featuredProjects: projects, aboutMe: results[1] as AboutMeModel?, isInitialLoaded: true));
      },
    );
  }
}
