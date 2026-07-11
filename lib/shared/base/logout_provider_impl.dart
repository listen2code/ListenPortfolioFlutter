import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import '../../features/home/presentation/pages/home_state.dart';
import '../../features/home/presentation/pages/overview/overview_view_model.dart';
import '../../features/home/presentation/pages/about_me/about_me_view_model.dart';
import '../../features/home/presentation/pages/projects/projects_view_model.dart';
import '../../features/home/presentation/pages/resume/resume_view_model.dart';
import '../shared.dart';
import 'package:listen_uikit/uikit.dart';

/// Concrete implementation for handling [LogoutEffect].
/// Performs session cleanup and redirects the user to the login screen while keeping Home in stack.
class LogoutProviderImpl extends BaseProvider<LogoutEffect> {
  final ProviderContainer container;

  const LogoutProviderImpl(this.container);

  @override
  void handleEffect(LogoutEffect effect) async {
    // 1. Show an alert if a message is provided (e.g., "Session Expired")
    CommonToast.show(effect.message ?? I18nKeys.sessionExpired.tr, type: ToastType.error);

    // 2. Perform global logout logic via AuthManager
    // Await ensures credentials are cleared before the next navigation occurs
    authManager.logout();

    if (effect.to?.isNotEmpty == true) {
      // 3. Navigation Strategy: Navigate to specific target
      await AppNav.to(effect.to);
    } else {
      // 3. Navigation Strategy: Pop all routes until HomePage is reached
      // This keeps HomePage alive and avoids recreating ViewModels
      await AppNav.offAll(Routes.home, isReplace: false);

      // 4. Fire event to notify HomeViewModel to reset to overview tab
      eventBus.fire(const CommonEvent<HomeTab>(AppConstants.tabChangedEvent, data: HomeTab.overview));
    }

    // 5. Invalidate Riverpod view models safely AFTER navigation has settled,
    // to clear in-memory user states without interfering with active route lifecycles.
    container
      ..invalidate(overviewViewModelProvider)
      ..invalidate(aboutMeViewModelProvider)
      ..invalidate(projectsViewModelProvider)
      ..invalidate(resumeViewModelProvider);
  }
}
