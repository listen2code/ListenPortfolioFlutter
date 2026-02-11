import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

/// Utility to show SnackBars without requiring BuildContext manually.
class SnackBarUtil {
  SnackBarUtil._();

  /// Global key to access ScaffoldMessengerState anywhere.
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Shows a standard snack bar with customizable background.
  /// [isError] sets the background to redAccent by default.
  static void show(
    String message, {
    bool isError = false,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Color? backgroundColor,
  }) {
    final accentColor = settingManager.accentColor;

    // Resolve background color: provided color > error color > accent color
    final Color finalBgColor = backgroundColor ?? (isError ? Colors.redAccent : accentColor);

    // Ensure the messenger state is available before proceeding
    final messengerState = messengerKey.currentState;
    if (messengerState == null) {
      debugPrint("SnackBarUtil Error: messengerKey is not attached to MaterialApp.");
      return;
    }

    // Clear previous snack bars immediately to show the new one
    messengerState.hideCurrentSnackBar();

    messengerState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        behavior: behavior,
        backgroundColor: finalBgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: behavior == SnackBarBehavior.floating ? const EdgeInsets.all(20) : null,
      ),
    );
  }

  /// Clears any current snack bars.
  static void clear() {
    messengerKey.currentState?.hideCurrentSnackBar();
  }
}
