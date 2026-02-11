import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

/// Global configuration for route interception to avoid reverse dependencies.
class RouteInterceptorConfig {
  RouteInterceptorConfig._();

  /// Global key to access the navigator without BuildContext.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Callback to check if the user is a guest.
  static bool Function()? isGuestCheck;

  /// Callback to handle redirection to the login page.
  static Future<bool> Function(BuildContext context)? onLoginRedirect;

  /// Setup the registry at app startup.
  static void register({
    required bool Function() isGuest,
    required Future<bool> Function(BuildContext context) onLogin,
  }) {
    isGuestCheck = isGuest;
    onLoginRedirect = onLogin;
  }
}

abstract class _RouteInterceptor {
  /// Priority of the interceptor. Lower value means higher priority.
  int? priority;

  Future<T?>? runOnRedirect<T>({
    MaterialPageRoute? toRoute,
    bool needLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  });
}

class CommonRouteInterceptor implements _RouteInterceptor {
  @override
  int? priority = -1;

  @override
  Future<T?>? runOnRedirect<T>({
    MaterialPageRoute? toRoute,
    bool needLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) => null;
}

class LoginRouteInterceptor extends CommonRouteInterceptor {
  @override
  int? get priority => -1;

  @override
  Future<T?>? runOnRedirect<T>({
    MaterialPageRoute? toRoute,
    bool needLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    // Check guest status via registered callback
    final bool isGuest = RouteInterceptorConfig.isGuestCheck?.call() ?? true;

    // Helper to convert dynamic values to generic T
    Future<T?> convert(value) {
      if (T == bool || T == dynamic) {
        return Future.value(value as T);
      }
      return Future.value(null);
    }

    // Intercept if login is required but user is a guest
    if (needLogin && isGuest) {
      final context = RouteInterceptorConfig.navigatorKey.currentContext;
      if (context != null && RouteInterceptorConfig.onLoginRedirect != null) {
        appLogger.d("Login Intercepted: Redirecting to Login Screen");

        // Execute the registered redirect logic
        return RouteInterceptorConfig.onLoginRedirect!(context).then((isLoginSuccess) {
          appLogger.d("Login Intercepted: isLoginSuccess=$isLoginSuccess");
          if (isLoginSuccess) {
            ScaffoldMessenger.of(RouteInterceptorConfig.navigatorKey.currentContext!).showSnackBar(
              const SnackBar(content: Text('Login Success!'), behavior: SnackBarBehavior.floating),
            );
          }
          if (isLoginSuccess && toRoute != null) {
            // todo
            return Navigator.of(
              RouteInterceptorConfig.navigatorKey.currentContext!,
            ).push(toRoute as Route<T>);
          } else if (isLoginSuccess && toRoute == null) {
            return convert(true);
          } else {
            return null;
          }
        });
      }
    } else if (needLogin && !isGuest) {
      return convert(true);
    }

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

  Future<T?>? runOnRedirect<T>({
    MaterialPageRoute? route,
    bool needLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    Future<T?>? to;
    for (final element in _getInterceptors()) {
      to = element.runOnRedirect(toRoute: route, needLogin: needLogin, routeInterceptor: routeInterceptor);
      if (to != null) {
        appLogger.d("Route Intercepted: Target ${route?.settings.name} redirected by ${element.runtimeType}");
        break;
      }
    }
    return to;
  }
}

/// Helper function to execute route redirection logic
Future<T?>? runOnRedirect<T>({
  MaterialPageRoute? route,
  bool needLogin = false,
  List<CommonRouteInterceptor>? routeInterceptor,
}) {
  final runner = RouteInterceptorRunner([...?routeInterceptor, if (needLogin) loginRouteInterceptor]);
  return runner.runOnRedirect(route: route, needLogin: needLogin, routeInterceptor: routeInterceptor);
}

final LoginRouteInterceptor loginRouteInterceptor = LoginRouteInterceptor();
