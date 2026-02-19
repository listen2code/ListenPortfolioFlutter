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

  static void back<T>([T? result]) => AppNavConfig.navigatorKey.currentState?.pop(result);

  /// Internal helper to resolve target and extract URI parameters.
  static Route<T>? _resolveRoute<T>(dynamic target, Object? arguments) {
    if (target is Widget) {
      return MaterialPageRoute<T>(
        builder: (_) => target,
        settings: RouteSettings(name: target.runtimeType.toString(), arguments: arguments),
      );
    } else if (target is String) {
      // 1. Parse the string as a URI to handle queries like "/path?key=value"
      final uri = Uri.parse(target);
      final path = uri.path;

      // 2. Merge path parameters with explicitly passed arguments
      Object? finalArgs = arguments;
      if (uri.queryParameters.isNotEmpty) {
        if (arguments is Map<String, dynamic>) {
          finalArgs = {...uri.queryParameters, ...arguments};
        } else {
          finalArgs = uri.queryParameters;
        }
      }

      final builder = AppNavConfig.getBuilder(path);
      if (builder != null) {
        return MaterialPageRoute<T>(
          builder: (_) => builder(finalArgs),
          settings: RouteSettings(name: path, arguments: finalArgs),
        );
      }
    }
    return null;
  }

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
}
