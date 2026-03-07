import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'home_intent.dart';
import 'home_state.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel with ViewModelMixin<HomeState, HomeIntent> {
  @override
  HomeState build() => const HomeState();

  @override
  FutureOr<void> onIntent(HomeIntent intent) {
    return intent.when<FutureOr<void>>(
      tabChanged: (tab) => updateState(state.copyWith(currentTab: tab)),
      refresh: _onRefresh,
      logout: _onLogout,
    );
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true));
    // Simulate data loading
    await Future.delayed(const Duration(milliseconds: 1500));
    emitEffect(LoadingEffect(false));
  }

  Future<void> _onLogout() async {
    // 1. First, show the confirmation dialog.
    // At this point, the user is still logged in, so the UI won't flash or redirect.
    final confirmed = await CommonDialog.showConfirm(
      title: I18nKeys.logout.tr,
      message: I18nKeys.logoutTips.tr,
    );

    if (confirmed == true) {
      await call<void>(
        ref.execute(logoutUseCaseProvider, NoParams()),
        showLoading: true,
        onSuccess: (_) async {
          if (state.currentTab == HomeTab.aboutMe) {
            updateState(state.copyWith(currentTab: HomeTab.overview));
          }
          emitEffect(LogoutEffect(to: Routes.login, message: "Logout Success!"));
        },
      );
    }
  }
}
