import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

import '../uikit.dart';

/// A global loading indicator widget managed via Overlay.
class CommonLoading {
  CommonLoading._();

  static OverlayEntry? _overlayEntry;

  /// Returns true if the loading overlay is currently visible.
  static bool get isShow => _overlayEntry != null;

  /// Displays a modal loading overlay.
  static void show({String? message}) {
    if (_overlayEntry != null) return;

    final overlayState = AppNavConfig.navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _LoadingWidget(message: message ?? UIKitConfig.getString(UIKitConfig.kLoading)),
    );

    overlayState.insert(_overlayEntry!);
  }

  /// Removes the current loading overlay.
  static void hide() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _LoadingWidget extends StatelessWidget {
  final String message;

  const _LoadingWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Resolve accent color: priority to theme's icon color (original accent), then primary.
    final effectiveAccentColor = theme.iconTheme.color ?? theme.colorScheme.primary;

    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(effectiveAccentColor),
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              CommonText(message, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
