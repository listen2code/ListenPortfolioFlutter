import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

import '../uikit.dart';

/// Centralized utility for showing various types of dialogs.
/// Uses specific Route references to manage singleton dialogs reliably.
class CommonDialog {
  CommonDialog._();

  /// Map to track currently active singleton dialogs by their Route handles.
  static final Map<String, Route> _activeRoutes = {};

  /// Internal logic to push a dialog route with singleton support.
  static Future<T?> _show<T>({
    required String? tag,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) async {
    final context = AppNavConfig.context;
    if (context == null) return null;

    final navigator = Navigator.of(context);

    // 1. Singleton Check: If a dialog with this tag is already active,
    // we simply return null to avoid overlapping or flickering.
    if (tag != null) {
      final existingRoute = _activeRoutes[tag];
      if (existingRoute != null && existingRoute.isActive) {
        return null;
      }
    }

    // 2. Create the DialogRoute
    final route = DialogRoute<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    );

    // 3. Store the handle if tagged
    if (tag != null) {
      _activeRoutes[tag] = route;
    }

    // 4. Push and cleanup on completion
    final result = await navigator.push<T>(route);

    if (tag != null && _activeRoutes[tag] == route) {
      _activeRoutes.remove(tag);
    }

    return result;
  }

  /// Shows an informational dialog with a single button.
  static Future<void> showMessage({
    required String title,
    required String message,
    String? buttonText,
    String? tag,
    bool barrierDismissible = true,
  }) async {
    await _show<void>(
      tag: tag,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: CommonText(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            CommonButton(
              text: buttonText ?? UIKitConfig.getString(UIKitConfig.kOk),
              type: ButtonType.text,
              isFullWidth: false,
              onPressed: () => AppNav.back(),
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirmation dialog with OK and Cancel buttons.
  static Future<bool?> showConfirm({
    required String title,
    required String message,
    String? okText,
    String? cancelText,
    Color? okColor,
    String? tag,
    bool barrierDismissible = false,
  }) {
    return _show<bool>(
      tag: tag,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: CommonText(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            CommonButton(
              text: cancelText ?? UIKitConfig.getString(UIKitConfig.kCancel),
              type: ButtonType.text,
              foregroundColor: Colors.grey,
              isFullWidth: false,
              onPressed: () => AppNav.back(false),
            ),
            CommonButton(
              text: okText ?? UIKitConfig.getString(UIKitConfig.kOk),
              type: ButtonType.text,
              backgroundColor: okColor,
              isFullWidth: false,
              onPressed: () => AppNav.back(true),
            ),
          ],
        );
      },
    );
  }

  /// Shows a list of selection options with checkmarks.
  static Future<void> showSwitchDialog({
    required String title,
    required List<DialogSwitchItem> items,
    bool isMultiSelect = false,
  }) async {
    await _show<void>(
      tag: null,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final theme = Theme.of(context);
          final accentColor = theme.iconTheme.color ?? theme.colorScheme.primary;
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: CommonText(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items
                    .map(
                      (item) => ListTile(
                        dense: true,
                        title: Text(item.label, style: const TextStyle(fontSize: 14)),
                        trailing: item.value ? Icon(Icons.check_circle, color: accentColor) : null,
                        onTap: () async {
                          if (!isMultiSelect && item.value) return;

                          final newValue = isMultiSelect ? !item.value : true;

                          if (context.mounted) {
                            setDialogState(() {
                              if (!isMultiSelect) {
                                for (var otherItem in items) {
                                  otherItem.value = false;
                                }
                              }
                              item.value = newValue;
                            });
                          }

                          await item.onChanged(newValue);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            actions: [
              CommonButton(
                text: UIKitConfig.getString(UIKitConfig.kOk),
                type: ButtonType.text,
                isFullWidth: false,
                onPressed: () => AppNav.back(),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Shows a custom content dialog with a title and optional actions.
  static Future<T?> showCustom<T>({
    required String title,
    required Widget body,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return _show<T>(
      tag: null,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: CommonText(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: body,
        actions: actions,
      ),
    );
  }
}

/// Data model for a selection item within a dialog.
class DialogSwitchItem {
  final String label;
  bool value;
  final dynamic Function(bool) onChanged;

  DialogSwitchItem({required this.label, required this.value, required this.onChanged});
}
