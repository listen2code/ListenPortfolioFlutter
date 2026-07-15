import 'package:collection/collection.dart';
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
    return const HomeState();
  }

  @override
  void onReady() {
    super.onReady();
    // Trigger in-app review check on app startup via effect
    emitEffect(RateAppEffect(action: RateAppAction.checkAndPrompt));

    // Subscribe to unified deep link event via core EventBus
    subscribeEvent<CommonEvent<Uri>>(
      (event) {
        final uri = event.data;
        if (uri != null) {
          final host = uri.host;
          final path = uri.path;

          // Handle home tab navigation via deep link directly to avoid full page replacement
          if (host == 'home' || path == '/home') {
            final tabStr = uri.queryParameters['tab'];
            if (tabStr != null) {
              final targetTab = HomeTab.values.firstWhereOrNull((tab) => tab.name == tabStr);
              if (targetTab != null) {
                if (state.currentTab != targetTab) {
                  handleIntent(HomeIntent.tabChanged(targetTab));
                }
                return;
              }
            }
          }

          appLogger.i('HomeViewModel: Processing deep link from EventBus: $uri');
          emitEffect(NavigationEffect(target: uri.toString(), replaceIfExists: true));
        }
      },
      key: DeepLinkManager.deepLinkEventKey,
      sticky: true,
    );
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
