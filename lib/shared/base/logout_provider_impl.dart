import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

/// Concrete implementation for handling [LogoutEffect].
/// Performs session cleanup and redirects the user to the login screen while keeping Home in stack.
class LogoutProviderImpl extends BaseProvider<LogoutEffect> {
  const LogoutProviderImpl();

  @override
  void handleEffect(LogoutEffect effect) async {
    // 1. Show an alert if a message is provided (e.g., "Session Expired")
    CommonToast.show(effect.message ?? "Session expired", type: ToastType.error);

    // 2. Perform global logout logic via AuthManager
    // Await ensures credentials are cleared before the next navigation occurs
    authManager.logout();

    // 3. Navigation Strategy:
    // First, clear the entire navigation stack and reset to Home.
    await AppNav.offAll(Routes.home);
  }
}
