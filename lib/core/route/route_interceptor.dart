import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

/// Global configuration for route interception to avoid reverse dependencies.
class RouteInterceptorConfig {
  RouteInterceptorConfig._();

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

  /// Setup the registry at app startup.
  static void register({
    required bool Function() isGuest,
    required Future<bool> Function(BuildContext context) onLogin,
    void Function()? onLoginSuccess,
  }) {
    isGuestCheck = isGuest;
    onLoginRedirect = onLogin;
    onLoginSuccessCallback = onLoginSuccess;
  }
}

abstract class _RouteInterceptor {
  int? priority;

  Future<T?>? runOnRedirect<T>({Route<T>? toRoute, bool needLogin = false});
}

class CommonRouteInterceptor implements _RouteInterceptor {
  @override
  int? priority = -1;

  @override
  Future<T?>? runOnRedirect<T>({Route<T>? toRoute, bool needLogin = false}) => null;
}

class LoginRouteInterceptor extends CommonRouteInterceptor {
  @override
  int? get priority => -1;

  @override
  Future<T?>? runOnRedirect<T>({Route<T>? toRoute, bool needLogin = false}) {
    final bool isGuest = RouteInterceptorConfig.isGuestCheck?.call() ?? true;

    if (needLogin && isGuest) {
      final context = RouteInterceptorConfig.context;
      if (context != null && RouteInterceptorConfig.onLoginRedirect != null) {
        appLogger.d("RouteInterceptor: Login required. Redirecting...");

        return RouteInterceptorConfig.onLoginRedirect!(context).then((isLoginSuccess) {
          if (isLoginSuccess) {
            appLogger.d("RouteInterceptor: Auth successful.");
            RouteInterceptorConfig.onLoginSuccessCallback?.call();

            if (toRoute != null && context.mounted) {
              return Navigator.of(context).push(toRoute);
            }
            return true as T;
          }
          return false as T;
        });
      } else {
        // Critical: If we intended to intercept but can't (no context/config), return false
        appLogger.e("RouteInterceptor: Interception failed due to missing context or config.");
        return Future.value(false as T);
      }
    }
    return null; // No interception needed
  }
}

class RouteInterceptorRunner {
  RouteInterceptorRunner(this._routeInterceptors);

  final List<CommonRouteInterceptor>? _routeInterceptors;

  List<CommonRouteInterceptor> _getInterceptors() {
    final list = _routeInterceptors ?? <CommonRouteInterceptor>[];
    return list..sort((a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0));
  }

  Future<T?>? runOnRedirect<T>({Route<T>? toRoute, bool needLogin = false}) {
    for (final element in _getInterceptors()) {
      final interceptedResult = element.runOnRedirect(toRoute: toRoute, needLogin: needLogin);
      if (interceptedResult != null) return interceptedResult;
    }

    if (toRoute != null) {
      return RouteInterceptorConfig.navigatorKey.currentState?.push(toRoute);
    }

    // Default to true only if no interceptor captured the request
    if (T == bool || T == dynamic) return Future.value(true as T);
    return null;
  }
}

Future<T?>? runOnRedirect<T>({
  Route<T>? toRoute,
  bool needLogin = false,
  List<CommonRouteInterceptor>? extraInterceptors,
}) {
  final runner = RouteInterceptorRunner([...?extraInterceptors, if (needLogin) loginRouteInterceptor]);
  return runner.runOnRedirect(toRoute: toRoute, needLogin: needLogin);
}

final LoginRouteInterceptor loginRouteInterceptor = LoginRouteInterceptor();
