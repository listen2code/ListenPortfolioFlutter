import 'package:collection/collection.dart';
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
    handleIntent(const HomeIntent.init());
    _checkShorebirdPatchUpdate();

    // Subscribe to unified deep link event via core EventBus
    subscribeEvent<CommonEvent<Uri>>(
      (event) {
        if (event.data != null) {
          handleIntent(HomeIntent.handleDeepLink(event.data!));
        }
      },
      key: DeepLinkManager.deepLinkEventKey,
      sticky: true,
    );
  }

  void _checkShorebirdPatchUpdate() {
    Future<void>.microtask(() async {
      await shorebirdService.checkAndInstallPatch(
        onPatchDownloaded: () {
          emitEffect(MessageEffect(I18nKeys.shorebirdPatchReadyMsg.tr, type: MessageType.info));
        },
      );
    });
  }

  @override
  bool checkNeedLogin(HomeIntent intent) {
    return intent.maybeWhen(tabChanged: (tab, _) => tab == HomeTab.aboutMe, orElse: () => false);
  }

  @override
  FutureOr<void> onIntent(HomeIntent intent) {
    return intent.when<FutureOr<void>>(
      init: () => emitEffect(RateAppEffect(action: RateAppAction.checkAndPrompt)),
      tabChanged: _onTabChanged,
      logout: _onLogout,
      confirmLogout: _onConfirmLogout,
      toSettings: () => emitEffect(NavigationEffect<void>(target: Routes.settings)),
      toAppearance: () => emitEffect(NavigationEffect<void>(target: Routes.appearance)),
      handleDeepLink: _onHandleDeepLink,
      previewAvatar: _onPreviewAvatar,
    );
  }

  void _onHandleDeepLink(Uri uri) {
    // 1. Handle home tab navigation via deep link directly to avoid full page replacement
    if (uri.host == AppConstants.deepLinkHostHome) {
      final tabName = uri.queryParameters[AppConstants.deepLinkParamTab];
      final targetTab = HomeTab.values.firstWhereOrNull((t) => t.name == tabName);
      if (targetTab != null) {
        if (state.currentTab != targetTab) {
          _onTabChanged(targetTab, false);
        }
        return;
      }
    }

    // 2. Otherwise, route via global navigation provider
    appLogger.i('HomeViewModel: Processing deep link from EventBus: $uri');
    emitEffect(NavigationEffect<void>(target: uri.toString(), replaceIfExists: true));
  }

  void _onTabChanged(HomeTab tab, bool closeDrawer) {
    if (closeDrawer) {
      emitEffect(NavigationEffect<void>.back());
      Future.delayed(const Duration(milliseconds: 100), () {
        updateState(state.copyWith(currentTab: tab));
      });
    } else {
      updateState(state.copyWith(currentTab: tab));
    }
  }

  void _onLogout() {
    if (authManager.state.isGuest) {
      emitEffect(NavigationEffect<void>(target: Routes.login));
      return;
    }
    // 1. First, show the confirmation dialog via ConfirmEffect.
    // At this point, the user is still logged in, so the UI won't flash or redirect.
    emitEffect(
      ConfirmEffect(
        title: I18nKeys.logout.tr,
        message: I18nKeys.logoutTips.tr,
        onResult: (confirmed) {
          if (confirmed) {
            handleIntent(const HomeIntent.confirmLogout());
          }
        },
      ),
    );
  }

  Future<void> _onConfirmLogout() async {
    await call<void>(
      ref.execute<void, BaseParam>(logoutUseCaseProvider),
      showLoading: true,
      onSuccess: (_) async {
        if (state.currentTab == HomeTab.aboutMe) {
          _onTabChanged(HomeTab.overview, false);
        }
        emitEffect(LogoutEffect(to: Routes.login, message: I18nKeys.logoutSuccess.tr));
      },
    );
  }

  void _onPreviewAvatar() {
    final avatarUrl = authManager.state.user?.avatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      emitEffect(PreviewImageEffect(imageUrl: avatarUrl, heroTag: 'drawer_avatar_preview'));
    }
  }
}
