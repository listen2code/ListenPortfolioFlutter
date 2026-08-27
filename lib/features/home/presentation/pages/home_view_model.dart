import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/shared.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import 'home_intent.dart';
import 'home_state.dart';
import 'projects/projects_intent.dart';
import 'projects/projects_view_model.dart';

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
    _checkDeferredDeepLink();

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

  void _checkDeferredDeepLink() {
    Future<void>.microtask(() async {
      handleIntent(const HomeIntent.checkDeferredDeepLink());
    });
  }

  /// Checks whether this app installation came from a Google Play deferred referral link.
  /// Runs on startup and fetches the referrer payload if not permanently disabled via 'Do not show again'.
  Future<void> _onCheckDeferredDeepLink() async {
    final service = ref.read(installReferrerServiceProvider);
    appLogger.i('HomeViewModel: [Deferred Deep Link] Checking if install referrer has already been processed...');
    final hasProcessed = await service.hasProcessedReferrer();
    if (hasProcessed) {
      appLogger.d('HomeViewModel: [Deferred Deep Link] Install referrer marked as processed (Do not show again = true). Skipping check.');
      return;
    }

    // 1. Fetch install referrer payload from Google Play
    appLogger.i('HomeViewModel: [Deferred Deep Link] Fetching install referrer from platform...');
    final data = await service.fetchInstallReferrer();
    if (data.hasReferral) {
      appLogger.i('HomeViewModel: [Deferred Deep Link] Valid referral detected! refer="${data.refer}", target="${data.targetRoute}", source="${data.utmSource}". Saving data...');
      await service.saveReferrerData(data);
      _onHandleDeferredDeepLink(data);
    } else {
      appLogger.d('HomeViewModel: [Deferred Deep Link] No valid referral parameters found in install referrer (raw: "${data.rawReferrer}").');
    }
  }

  /// Displays the referral welcome dialog and handles deferred deep link destination navigation when confirmed.
  void _onHandleDeferredDeepLink(InstallReferrerData data) {
    final service = ref.read(installReferrerServiceProvider);
    appLogger.i('HomeViewModel: [Deferred Deep Link] Emitting ReferralWelcomeEffect -> displaySource: "${data.displaySource}", targetRoute: "${data.targetRoute}"');
    emitEffect(
      ReferralWelcomeEffect(
        data: data,
        onConfirm: (bool doNotShowAgain) async {
          if (doNotShowAgain) {
            appLogger.i('HomeViewModel: [Deferred Deep Link] User checked "Do not show again". Persisting processed mark in SP.');
            await service.markReferrerProcessed();
          } else {
            appLogger.i('HomeViewModel: [Deferred Deep Link] User unchecked "Do not show again". Resetting SP so referrer will be fetched again on next start.');
            await service.resetReferrerProcessed();
          }

          if (data.targetRoute != null && data.targetRoute!.isNotEmpty) {
            final target = data.targetRoute!.trim();
            appLogger.i('HomeViewModel: [Deferred Deep Link] User clicked Get Started. Navigating to target route: "$target"');
            final targetTab = HomeTab.values.firstWhereOrNull((t) => t.name == target);
            if (targetTab != null) {
              _onTabChanged(targetTab, null, false);
            } else {
              emitEffect(NavigationEffect<void>(target: target));
            }
          } else {
            appLogger.d('HomeViewModel: [Deferred Deep Link] No specific targetRoute provided, remaining on initial Home overview tab.');
          }
        },
      ),
    );
  }

  @override
  bool checkNeedLogin(HomeIntent intent) {
    return intent.maybeWhen(tabChanged: (tab, _, _) => tab == HomeTab.aboutMe, orElse: () => false);
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
      checkDeferredDeepLink: _onCheckDeferredDeepLink,
      handleDeferredDeepLink: _onHandleDeferredDeepLink,
    );
  }

  void _onHandleDeepLink(Uri uri) {
    // 1. Handle home tab navigation via deep link directly to avoid full page replacement
    if (uri.host == AppConstants.deepLinkHostHome) {
      final tabName = uri.queryParameters[AppConstants.deepLinkParamTab];
      final targetProjectBusinessId = uri.queryParameters['targetProjectBusinessId'];
      final targetTab = HomeTab.values.firstWhereOrNull((t) => t.name == tabName);
      if (targetTab != null) {
        if (state.currentTab != targetTab || targetProjectBusinessId != null) {
          _onTabChanged(targetTab, targetProjectBusinessId, false);
        }
        return;
      }
    }

    // 2. Otherwise, route via global navigation provider
    appLogger.i('HomeViewModel: Processing deep link from EventBus: $uri');
    emitEffect(NavigationEffect<void>(target: uri.toString(), replaceIfExists: true));
  }

  void _onTabChanged(HomeTab tab, String? targetProjectBusinessId, bool closeDrawer) {
    void performSwitch() {
      updateState(state.copyWith(currentTab: tab));
      if (tab == HomeTab.projects && targetProjectBusinessId != null && targetProjectBusinessId.isNotEmpty) {
        ref.read(projectsViewModelProvider.notifier).handleIntent(
              ProjectsIntent.scrollToProject(targetProjectBusinessId),
            );
      }
    }

    if (closeDrawer) {
      emitEffect(NavigationEffect<void>.back());
      Future.delayed(const Duration(milliseconds: 100), performSwitch);
    } else {
      performSwitch();
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
          _onTabChanged(HomeTab.overview, null, false);
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
