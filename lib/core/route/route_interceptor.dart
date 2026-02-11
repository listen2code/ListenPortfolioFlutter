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
    // Check current auth status via registered callback
    final bool isGuest = RouteInterceptorConfig.isGuestCheck?.call() ?? true;

    // Intercept navigation if login is required but user is a guest
    if (needLogin && isGuest) {
      final context = RouteInterceptorConfig.context;
      if (context != null && RouteInterceptorConfig.onLoginRedirect != null) {
        appLogger.d("RouteInterceptor: Access denied. Redirecting to login...");

        // Start login flow and return its completion future
        return RouteInterceptorConfig.onLoginRedirect!(context).then((isLoginSuccess) {
          if (isLoginSuccess) {
            RouteInterceptorConfig.onLoginSuccessCallback?.call();
            appLogger.d("RouteInterceptor: Auth success. Executing target route.");

            // If there's a target route, perform the push now using global navigator state
            if (toRoute != null) {
              return RouteInterceptorConfig.navigatorKey.currentState?.push(toRoute);
            }

            // If just checking permission, return true
            return true as T;
          }

          appLogger.d("RouteInterceptor: Auth cancelled or failed.");
          return false as T;
        });
      }
    }

    appLogger.d("RouteInterceptor: No interception isGuest=$isGuest");
    // No interception: Proceed to next interceptor or default runner logic
    return null;
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
      // If an interceptor captures the flow, return its result immediately
      if (interceptedResult != null) return interceptedResult;
    }

    // Default Fallback: If no interceptors caught the request
    if (toRoute != null) {
      // Execute the navigation normally
      return RouteInterceptorConfig.navigatorKey.currentState?.push(toRoute);
    }

    // No route to push, just return a "Permission Granted" flag
    if (T == bool || T == dynamic) return Future.value(true as T);
    return null;
  }
}

/// Helper function to trigger route redirection logic.
Future<T?>? runOnRedirect<T>({
  Route<T>? toRoute,
  bool needLogin = false,
  List<CommonRouteInterceptor>? extraInterceptors,
}) {
  final runner = RouteInterceptorRunner([...?extraInterceptors, if (needLogin) loginRouteInterceptor]);
  return runner.runOnRedirect(toRoute: toRoute, needLogin: needLogin);
}

final LoginRouteInterceptor loginRouteInterceptor = LoginRouteInterceptor();
