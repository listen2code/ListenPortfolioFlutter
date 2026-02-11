import 'dart:async';
import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';

import 'route_interceptor.dart';

/// Centralized navigation utility with built-in interception support.
class AppNav {
  AppNav._();

  /// Runs a permission check. If user is a guest, shows a login required dialog.
  /// If user confirms and logs in successfully, or is already logged in, [onSuccess] is executed.
  static void tryLogin({required VoidCallback onSuccess, VoidCallback? onFail, bool needLogin = true}) {
    final bool isGuest = RouteInterceptorConfig.isGuestCheck?.call() ?? true;

    if (needLogin && isGuest) {
      final context = RouteInterceptorConfig.context;
      if (context == null) {
        onFail?.call();
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(I18nKeys.loginLink.tr),
          content: Text(I18nKeys.signInToContinue.tr),
          actions: [
            TextButton(
              onPressed: () {
                back(); // Close dialog
                onFail?.call();
              },
              child: Text(I18nKeys.cancel.tr, style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                // Trigger actual login flow via interceptor
                runOnRedirect<bool>(needLogin: true)?.then((success) {
                  if (success == true && dialogContext.mounted) {
                    back(); // Close dialog
                    onSuccess();
                  } else if (success == false && dialogContext.mounted) {
                    back(); // Close dialog on explicit cancel/fail
                    onFail?.call();
                  }
                });
              },
              child: Text(I18nKeys.login.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      onSuccess();
    }
  }

  /// Navigates to a new [page] with optional auth check and confirmation dialog.
  static Future<T?>? to<T>(Widget page, {bool needLogin = false, Object? arguments}) {
    final completer = Completer<T?>();

    tryLogin(
      needLogin: needLogin,
      onSuccess: () {
        final route = MaterialPageRoute<T>(
          builder: (_) => page,
          settings: RouteSettings(name: page.runtimeType.toString(), arguments: arguments),
        );
        // Execute the actual push (interceptor will pass through as guest was already checked/handled)
        runOnRedirect<T>(toRoute: route, needLogin: false)?.then((value) {
          completer.complete(value);
        });
      },
      onFail: () => completer.complete(null),
    );

    return completer.future;
  }

  /// Replaces the current route with a new [page] with optional auth check and confirmation dialog.
  static Future<T?>? off<T>(Widget page, {bool needLogin = false, Object? arguments}) {
    final completer = Completer<T?>();

    tryLogin(
      needLogin: needLogin,
      onSuccess: () {
        final route = MaterialPageRoute<T>(
          builder: (_) => page,
          settings: RouteSettings(name: page.runtimeType.toString(), arguments: arguments),
        );
        final result = RouteInterceptorConfig.navigatorKey.currentState?.pushReplacement(route);
        completer.complete(result);
      },
      onFail: () => completer.complete(null),
    );

    return completer.future;
  }

  /// Navigates to a new page and removes all previous routes.
  static Future<T?>? offAll<T>(Widget page, {bool needLogin = false}) {
    final completer = Completer<T?>();

    tryLogin(
      needLogin: needLogin,
      onSuccess: () {
        final result = RouteInterceptorConfig.navigatorKey.currentState?.pushAndRemoveUntil(
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
    RouteInterceptorConfig.navigatorKey.currentState?.pop(result);
  }
}
