import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
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
    intent.when(refresh: () => _onRefresh());
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true, type: LoadingType.page));
    // Simulate initial data loading delay
    await Future.delayed(const Duration(milliseconds: 1000));
    updateState(state.copyWith(isInitialLoaded: true));
    emitEffect(LoadingEffect(false));
  }
}
