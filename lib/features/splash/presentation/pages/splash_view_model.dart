import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'splash_intent.dart';
import 'splash_state.dart';

part 'splash_view_model.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel with ViewModelMixin<SplashState, SplashIntent> {
  @override
  SplashState build() => const SplashState();

  @override
  void onInit() {
    handleIntent(const SplashIntent.init());
  }

  @override
  FutureOr<void> onIntent(SplashIntent intent) {
    return intent.when<FutureOr<void>>(init: _onInit);
  }

  Future<void> _onInit() async {
    // Artificial delay for splash screen branding
    await Future.delayed(const Duration(seconds: 2));
    emitEffect(NavigationEffect(target: Routes.home, isReplace: true));
  }
}
