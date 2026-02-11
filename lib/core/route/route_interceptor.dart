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

  /// Callback to show a SnackBar message. Added as requested.
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
  /// Priority of the interceptor. Lower value means higher priority.
  int? priority;

  /// Logic to run before navigation.
  /// Returns a Future if it intercepts the flow, null otherwise.
  Future<T?>? runOnRedirect<T>({Route<T>? toRoute, bool needLogin = false});
}

class CommonRouteInterceptor implements _RouteInterceptor {
  @override
  int? priority = -1;

  @override
  Future<T?>? runOnRedirect<T>({Route<T>? toRoute, bool needLogin = false}) => null;
}

/// Specialized interceptor for checking authentication status.
class LoginRouteInterceptor extends CommonRouteInterceptor {
  @override
  int? get priority => -1;

  @override
  Future<T?>? runOnRedirect<T>({Route<T>? toRoute, bool needLogin = false}) {
    // Check guest status via registered callback
    final bool isGuest = RouteInterceptorConfig.isGuestCheck?.call() ?? true;

    // Helper to convert dynamic values to generic T
    Future<T?> convert(value) {
      if (T == bool || T == dynamic) return Future.value(value as T);
      return Future.value(null);
    }

    // Intercept if login is required but user is a guest
    if (needLogin && isGuest) {
      final context = RouteInterceptorConfig.context;
      if (context != null && RouteInterceptorConfig.onLoginRedirect != null) {
        appLogger.d("RouteInterceptor: Login required. Redirecting...");

        // Execute the registered login logic and wait for result
        return RouteInterceptorConfig.onLoginRedirect!(context).then((isLoginSuccess) {
          if (isLoginSuccess) {
            RouteInterceptorConfig.onLoginSuccessCallback?.call();
            appLogger.d("RouteInterceptor: Login success. Resuming navigation.");
            // If original route exists, push it now.
            if (toRoute != null && context.mounted) {
              return Navigator.of(context).push(toRoute);
            }
            // If no specific route, just return success flag
            return convert(true);
          }
          appLogger.d("RouteInterceptor: Login cancelled or failed.");
          return convert(false);
        });
      }
    }

    // No interception occurred
    return null;
  }
}

class RouteInterceptorRunner {
  RouteInterceptorRunner(this._routeInterceptors);

  final List<CommonRouteInterceptor>? _routeInterceptors;

  List<CommonRouteInterceptor> _getInterceptors() {
    final m = _routeInterceptors ?? <CommonRouteInterceptor>[];
    return m..sort((a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0));
  }

  Future<T?>? runOnRedirect<T>({Route<T>? toRoute, bool needLogin = false}) {
    for (final element in _getInterceptors()) {
      final result = element.runOnRedirect(toRoute: toRoute, needLogin: needLogin);
      if (result != null) return result;
    }

    // Default behavior: If not intercepted, proceed with navigation if route is provided
    if (toRoute != null) {
      return RouteInterceptorConfig.navigatorKey.currentState?.push(toRoute);
    }

    // Return default success if no route was provided (e.g., just a check)
    if (T == bool || T == dynamic) return Future.value(true as T);
    return null;
  }
}

/// Main entry point for performing intercepted navigation.
Future<T?>? runOnRedirect<T>({
  Route<T>? toRoute,
  bool needLogin = false,
  List<CommonRouteInterceptor>? extraInterceptors,
}) {
  final runner = RouteInterceptorRunner([...?extraInterceptors, if (needLogin) loginRouteInterceptor]);
  return runner.runOnRedirect(toRoute: toRoute, needLogin: needLogin);
}

final LoginRouteInterceptor loginRouteInterceptor = LoginRouteInterceptor();
