import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'architecture_intent.dart';
import 'architecture_state.dart';

part 'architecture_view_model.g.dart';

@riverpod
class ArchitectureViewModel extends _$ArchitectureViewModel
    with ViewModelMixin<ArchitectureState, ArchitectureIntent> {
  @override
  ArchitectureState build() => const ArchitectureState();

  @override
  void onVisible() {
    super.onVisible();
    if (!state.isInitialLoaded) {
      handleIntent(const ArchitectureIntent.refresh());
    }
  }

  @override
  FutureOr<void> onIntent(ArchitectureIntent intent) {
    return intent.when<FutureOr<void>>(refresh: () => _onRefresh());
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true));
    // Simulate loading for architecture summary
    await Future.delayed(const Duration(milliseconds: 800));
    updateState(state.copyWith(isInitialLoaded: true));
    emitEffect(LoadingEffect(false));
  }
}
