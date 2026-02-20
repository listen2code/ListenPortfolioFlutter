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

  static final Map<String, RoutePageBuilder> _routeRegistry = {};

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

  static RoutePageBuilder? getBuilder(String path) => _routeRegistry[path];
}

class AppNav {
  AppNav._();

  /// Retrieves a parameter from the current route by [key].
  /// Supports both Map-based arguments and URI query parameters.
  static T? getParam<T>(String key) {
    final context = AppNavConfig.context;
    if (context == null) return null;

    final settings = ModalRoute.of(context)?.settings;
    final args = settings?.arguments;

    if (args is Map<String, dynamic>) {
      return args[key] as T?;
    }
    return null;
  }

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
      String path;
      final Map<String, dynamic> combinedArgs = {};

      if (target.contains('?')) {
        final index = target.indexOf('?');
        path = target.substring(0, index);
        final queryStr = target.substring(index + 1);
        final queryParts = queryStr.split('&');
        for (var part in queryParts) {
          final kv = part.split('=');
          if (kv.length == 2) {
            combinedArgs[kv[0]] = kv[1];
          }
        }
      } else {
        path = target;
      }

      if (arguments is Map) {
        combinedArgs.addAll(Map<String, dynamic>.from(arguments));
      } else if (arguments != null && combinedArgs.isEmpty) {
        return _buildPageRoute(path, arguments);
      }

      return _buildPageRoute<T>(path, combinedArgs);
    }
    return null;
  }

  static Route<T>? _buildPageRoute<T>(String name, Object? args) {
    final builder = AppNavConfig.getBuilder(name);
    if (builder == null) return null;
    return MaterialPageRoute<T>(
      builder: (_) => builder(args),
      settings: RouteSettings(name: name, arguments: args),
    );
  }

  static void tryLogin({required VoidCallback onSuccess, VoidCallback? onFail, bool needLogin = true}) {
    final bool isGuest = AppNavConfig.isGuestCheck?.call() ?? true;
    if (needLogin && isGuest) {
      final context = AppNavConfig.context;
      final loginRedirect = AppNavConfig.onLoginRedirect;
      if (context == null || loginRedirect == null) return;

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
