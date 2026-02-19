import 'dart:async';

import 'package:flutter/material.dart';

import 'route_interceptor.dart';

/// Builder function to create a page for a specific route path.
typedef RoutePageBuilder = Widget Function(Object? arguments);

/// Global configuration for route interception and app-wide navigation settings.
class AppNavConfig {
  AppNavConfig._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;
  static bool Function()? isGuestCheck;
  static Future<bool> Function(BuildContext context)? onLoginRedirect;
  static void Function()? onLoginSuccessCallback;
  static Future<bool> Function(BuildContext context)? onShowLoginDialogCallback;

  /// Registry for named routes mapping paths to widget builders.
  static final Map<String, RoutePageBuilder> _routeRegistry = {};

  /// Setup navigation and register named routes.
  static void register({
    required bool Function() isGuest,
    required Future<bool> Function(BuildContext context) onLogin,
    void Function()? onLoginSuccess,
    Future<bool> Function(BuildContext context)? onShowLoginDialog,
    Map<String, RoutePageBuilder>? routes,
  }) {
    isGuestCheck = isGuest;
    onLoginRedirect = onLogin;
    onLoginSuccessCallback = onLoginSuccess;
    onShowLoginDialogCallback = onShowLoginDialog;
    if (routes != null) _routeRegistry.addAll(routes);
  }

  /// Finds a widget builder for the given [path].
  static RoutePageBuilder? getBuilder(String path) => _routeRegistry[path];
}

/// Centralized navigation utility with support for both Widget and String-based routes.
class AppNav {
  AppNav._();

  /// Navigates to a new page using either a [Widget] instance or a [String] path.
  /// Example: AppNav.to("/login"); or AppNav.to(LoginPage());
  static Future<T?>? to<T>(dynamic target, {bool needLogin = false, Object? arguments}) {
    final completer = Completer<T?>();

    tryLogin(
      needLogin: needLogin,
      onSuccess: () {
        final Route<T>? route = _resolveRoute<T>(target, arguments);
        if (route == null) {
          completer.complete(null);
          return;
        }

        runOnRedirect<T>(toRoute: route, needLogin: false)?.then((value) {
          completer.complete(value);
        });
      },
      onFail: () => completer.complete(null),
    );

    return completer.future;
  }

  /// Replaces current route with a new page.
  static Future<T?>? off<T>(dynamic target, {bool needLogin = false, Object? arguments}) {
    final completer = Completer<T?>();

    tryLogin(
      needLogin: needLogin,
      onSuccess: () {
        final Route<T>? route = _resolveRoute<T>(target, arguments);
        if (route == null) {
          completer.complete(null);
          return;
        }

        final result = AppNavConfig.navigatorKey.currentState?.pushReplacement(route);
        completer.complete(result);
      },
      onFail: () => completer.complete(null),
    );

    return completer.future;
  }

  /// Clears stack and navigates to a new page.
  static Future<T?>? offAll<T>(dynamic target, {bool needLogin = false, Object? arguments}) {
    final completer = Completer<T?>();

    tryLogin(
      needLogin: needLogin,
      onSuccess: () {
        final Route<T>? route = _resolveRoute<T>(target, arguments);
        if (route == null) {
          completer.complete(null);
          return;
        }

        final result = AppNavConfig.navigatorKey.currentState?.pushAndRemoveUntil(route, (route) => false);
        completer.complete(result);
      },
      onFail: () => completer.complete(null),
    );

    return completer.future;
  }

  /// Close current screen.
  static void back<T>([T? result]) => AppNavConfig.navigatorKey.currentState?.pop(result);

  /// Performs auth check and dialog handling before proceeding.
  static void tryLogin({required VoidCallback onSuccess, VoidCallback? onFail, bool needLogin = true}) {
    final bool isGuest = AppNavConfig.isGuestCheck?.call() ?? true;

    if (needLogin && isGuest) {
      final context = AppNavConfig.context;
      final loginRedirect = AppNavConfig.onLoginRedirect;
      if (context == null || loginRedirect == null) {
        onFail?.call();
        return;
      }

      void performLoginFlow() {
        loginRedirect(context).then((success) {
          if (success) {
            AppNavConfig.onLoginSuccessCallback?.call();
            onSuccess();
          } else {
            onFail?.call();
          }
        });
      }

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
        performLoginFlow();
      }
    } else {
      onSuccess();
    }
  }

  /// Internal helper to convert target (Widget or String) into a MaterialPageRoute.
  static Route<T>? _resolveRoute<T>(dynamic target, Object? arguments) {
    if (target is Widget) {
      return MaterialPageRoute<T>(
        builder: (_) => target,
        settings: RouteSettings(name: target.runtimeType.toString(), arguments: arguments),
      );
    } else if (target is String) {
      final builder = AppNavConfig.getBuilder(target);
      if (builder != null) {
        return MaterialPageRoute<T>(
          builder: (_) => builder(arguments),
          settings: RouteSettings(name: target, arguments: arguments),
        );
      }
      debugPrint('AppNav Error: Route path "$target" not found in registry.');
    }
    return null;
  }
}
