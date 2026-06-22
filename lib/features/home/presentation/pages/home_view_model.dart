import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:listen_core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/shared.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import 'home_intent.dart';
import 'home_state.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel with ViewModelMixin<HomeState, HomeIntent> {
  @override
  HomeState build() {
    // Subscribe to logout event to reset to overview tab
    subscribeEvent<CommonEvent<dynamic>>((event) {
      if (state.currentTab != HomeTab.overview) {
        handleIntent(const HomeIntent.tabChanged(HomeTab.overview));
      }
    }, key: AppConstants.resetOverview);

    // Subscribe to tab change event (e.g. from push notifications)
    subscribeEvent<CommonEvent<HomeTab>>(
      (event) {
        if (event.key == AppConstants.tabChangedEvent) {
          final targetTab = event.data;
          if (targetTab != null && state.currentTab != targetTab) {
            handleIntent(HomeIntent.tabChanged(targetTab));
          }
        }
      },
      key: AppConstants.tabChangedEvent,
      sticky: true,
    );

    // Subscribe to route change event (e.g. from push notifications)
    subscribeEvent<CommonEvent<String>>(
      (event) {
        if (event.key == AppConstants.routeChangedEvent) {
          final targetRoute = event.data;
          if (targetRoute != null && targetRoute.isNotEmpty) {
            // Navigate to target route safely on the next frame to avoid build collision
            WidgetsBinding.instance.addPostFrameCallback((_) {
              emitEffect(NavigationEffect(target: targetRoute, arguments: {Routes.argCheckUpdate: true}));
            });
          }
        }
      },
      key: AppConstants.routeChangedEvent,
      sticky: true,
    );

    // Trigger in-app review check on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReviewService().checkAndPromptReview();
    });

    return const HomeState();
  }

  @override
  FutureOr<void> onIntent(HomeIntent intent) {
    return intent.when<FutureOr<void>>(
      tabChanged: (tab) => _onTabChanged,
      refresh: _onRefresh,
      logout: _onLogout,
    );
  }

  Future<void> _onTabChanged(HomeTab tab) async {
    updateState(state.copyWith(currentTab: tab));
    emitEffect(NavigationEffect.back());
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true));
    // Simulate data loading
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    emitEffect(LoadingEffect(false));
  }

  void _onLogout() {
    if (authManager.state.isGuest) {
      emitEffect(NavigationEffect(target: Routes.login));
      return;
    }
    // 1. First, show the confirmation dialog via ConfirmEffect.
    // At this point, the user is still logged in, so the UI won't flash or redirect.
    emitEffect(
      ConfirmEffect(
        title: I18nKeys.logout.tr,
        message: I18nKeys.logoutTips.tr,
        onResult: (confirmed) async {
          if (confirmed) {
            await call<void>(
              ref.execute<void, BaseParam>(logoutUseCaseProvider),
              showLoading: true,
              onSuccess: (_) async {
                if (state.currentTab == HomeTab.aboutMe) {
                  handleIntent(const HomeIntent.tabChanged(HomeTab.overview));
                }
                emitEffect(LogoutEffect(to: Routes.login, message: I18nKeys.logoutSuccess.tr));
              },
            );
          }
        },
      ),
    );
  }
}
