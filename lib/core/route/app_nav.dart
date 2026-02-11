import 'dart:async';

import 'package:flutter/material.dart';

import 'route_interceptor.dart';

/// Global configuration for route interception and app-wide navigation settings.
class AppNavConfig {
  AppNavConfig._();

  /// Global key to access the navigator without passing BuildContext manually.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Shortcut to get current context from navigator key.
  static BuildContext? get context => navigatorKey.currentContext;

  /// Callback to check if the user is a guest. Registered at app startup.
  static bool Function()? isGuestCheck;

  /// Callback to handle redirection to the login page. Returns true if login succeeded.
  static Future<bool> Function(BuildContext context)? onLoginRedirect;

  /// Optional callback triggered globally on successful login.
  static void Function()? onLoginSuccessCallback;

  /// Callback to show a custom login prompt dialog. Returns true to proceed with login.
  static Future<bool> Function(BuildContext context)? onShowLoginDialogCallback;

  /// Setup the registry at app startup.
  static void register({
    required bool Function() isGuest,
    required Future<bool> Function(BuildContext context) onLogin,
    void Function()? onLoginSuccess,
    Future<bool> Function(BuildContext context)? onShowLoginDialog,
  }) {
    isGuestCheck = isGuest;
    onLoginRedirect = onLogin;
    onLoginSuccessCallback = onLoginSuccess;
    onShowLoginDialogCallback = onShowLoginDialog;
  }
}

/// Centralized navigation utility with built-in interception and auth-guard support.
class AppNav {
  AppNav._();

  /// Performs an authentication check. Shows a prompt if [onShowLoginDialogCallback] is configured.
  /// If guest and confirmed (or no dialog configured), triggers the login flow.
  static void tryLogin({required VoidCallback onSuccess, VoidCallback? onFail, bool needLogin = true}) {
    final bool isGuest = AppNavConfig.isGuestCheck?.call() ?? true;

    if (needLogin && isGuest) {
      final context = AppNavConfig.context;
      final loginRedirect = AppNavConfig.onLoginRedirect;

      if (context == null || loginRedirect == null) {
        onFail?.call();
        return;
      }

      // Action to execute if login is decided or dialog is skipped
      void performLoginFlow() {
        loginRedirect(context).then((isLoginSuccess) {
          if (isLoginSuccess) {
            onSuccess();
          } else {
            onFail?.call();
          }
        });
      }

      // Check if a custom prompt dialog is registered
      final showPrompt = AppNavConfig.onShowLoginDialogCallback;
      if (showPrompt != null) {
        showPrompt(context).then((confirmed) {
          if (confirmed) {
            performLoginFlow();
          } else {
            onFail?.call();
          }
        });
      } else {
        // No dialog configured, jump straight to login redirection
        performLoginFlow();
      }
    } else {
      onSuccess();
    }
  }

  /// Navigates to a new [page] with optional auth check and configured prompt.
  static Future<T?>? to<T>(Widget page, {bool needLogin = false, Object? arguments}) {
    final completer = Completer<T?>();

    tryLogin(
      needLogin: needLogin,
      onSuccess: () {
        final route = MaterialPageRoute<T>(
          builder: (_) => page,
          settings: RouteSettings(name: page.runtimeType.toString(), arguments: arguments),
        );
        // Execute push after potential login/prompt sequence
        runOnRedirect<T>(toRoute: route, needLogin: false)?.then((value) {
          completer.complete(value);
        });
      },
      onFail: () => completer.complete(null),
    );

    return completer.future;
  }

  /// Replaces current route with [page] with optional auth check and configured prompt.
  static Future<T?>? off<T>(Widget page, {bool needLogin = false, Object? arguments}) {
    final completer = Completer<T?>();

    tryLogin(
      needLogin: needLogin,
      onSuccess: () {
        final route = MaterialPageRoute<T>(
          builder: (_) => page,
          settings: RouteSettings(name: page.runtimeType.toString(), arguments: arguments),
        );
        final result = AppNavConfig.navigatorKey.currentState?.pushReplacement(route);
        completer.complete(result);
      },
      onFail: () => completer.complete(null),
    );

    return completer.future;
  }

  /// Navigates to [page] and clears stack with optional auth check and configured prompt.
  static Future<T?>? offAll<T>(Widget page, {bool needLogin = false}) {
    final completer = Completer<T?>();

    tryLogin(
      needLogin: needLogin,
      onSuccess: () {
        final result = AppNavConfig.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute<T>(builder: (_) => page),
          (route) => false,
        );
        completer.complete(result);
      },
      onFail: () => completer.complete(null),
    );

    return completer.future;
  }

  /// Close the current screen and optionally return a [result].
  static void back<T>([T? result]) {
    AppNavConfig.navigatorKey.currentState?.pop(result);
  }
}
