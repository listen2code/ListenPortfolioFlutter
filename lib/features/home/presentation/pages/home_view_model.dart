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
    // Subscribe to tab change event (e.g. from logout or push notifications)
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

    // Trigger in-app review check on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReviewService().checkAndPromptReview();
    });

    // Subscribe to unified deep link event via core EventBus
    subscribeEvent<CommonEvent<Uri>>(
      (event) {
        final uri = event.data;
        if (uri != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            appLogger.i('HomeViewModel: Processing deep link from EventBus: $uri');
            emitEffect(NavigationEffect(target: uri.toString(), replaceIfExists: true));
          });
        }
      },
      key: DeepLinkManager.deepLinkEventKey,
      sticky: true,
    );

    return const HomeState();
  }

  @override
  FutureOr<void> onIntent(HomeIntent intent) {
    return intent.when<FutureOr<void>>(
      tabChanged: _onTabChanged,
      logout: _onLogout,
      toSettings: () => emitEffect(NavigationEffect(target: Routes.settings)),
      toAppearance: () => emitEffect(NavigationEffect(target: Routes.appearance)),
    );
  }

  Future<void> _onTabChanged(HomeTab tab, bool closeDrawer) async {
    updateState(state.copyWith(currentTab: tab));
    if (closeDrawer) {
      emitEffect(NavigationEffect.back());
    }
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
