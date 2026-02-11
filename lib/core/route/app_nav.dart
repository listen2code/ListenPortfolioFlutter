import 'package:flutter/material.dart';

import 'route_interceptor.dart';

/// Centralized navigation utility with built-in interception support.
class Nav {
  Nav._();

  /// Runs a permission check before executing [onSuccess].
  /// If [needLogin] is true and user is a guest, it triggers the login flow.
  static void tryLogin({required VoidCallback onSuccess, bool needLogin = true}) {
    runOnRedirect<bool>(needLogin: needLogin)?.then((success) {
      if (success == true) {
        onSuccess();
      }
    });
  }

  /// Navigates to a new [page] with optional auth check.
  static Future<T?>? to<T>(Widget page, {bool needLogin = false, Object? arguments}) {
    final route = MaterialPageRoute<T>(
      builder: (_) => page,
      settings: RouteSettings(name: page.runtimeType.toString(), arguments: arguments),
    );
    return runOnRedirect<T>(toRoute: route, needLogin: needLogin);
  }

  /// Replaces the current route with a new [page].
  static Future<T?>? off<T>(Widget page, {bool needLogin = false, Object? arguments}) {
    final route = MaterialPageRoute<T>(
      builder: (_) => page,
      settings: RouteSettings(name: page.runtimeType.toString(), arguments: arguments),
    );

    // If login is required, let interceptor handle the sequence.
    // Once successful, it will perform a standard push, so we manually do off if needed.
    if (needLogin && (RouteInterceptorConfig.isGuestCheck?.call() ?? true)) {
      return runOnRedirect<bool>(needLogin: true)?.then((success) {
        if (success == true) {
          return RouteInterceptorConfig.navigatorKey.currentState?.pushReplacement(route);
        }
        return null;
      });
    }

    return RouteInterceptorConfig.navigatorKey.currentState?.pushReplacement(route);
  }

  /// Navigates to a new page and removes all previous routes.
  static Future<T?>? offAll<T>(Widget page) {
    return RouteInterceptorConfig.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute<T>(builder: (_) => page),
      (route) => false,
    );
  }

  /// Close the current screen and optionally return a [result].
  static void back<T>([T? result]) {
    RouteInterceptorConfig.navigatorKey.currentState?.pop(result);
  }
}
