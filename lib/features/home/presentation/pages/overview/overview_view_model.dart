import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/projects_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
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
    await call(
      ref.execute(getProjectsUseCaseProvider, const NoParams()),
      showLoading: true,
      loadingType: LoadingType.page,
      onSuccess: (projects) {
        final featured = projects.take(2).toList();
        updateState(state.copyWith(featuredProjects: featured, isInitialLoaded: true));
      },
    );
  }
}
