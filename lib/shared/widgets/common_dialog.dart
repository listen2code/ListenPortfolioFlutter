import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text.dart';

/// Centralized utility for showing various types of dialogs.
class CommonDialog {
  CommonDialog._();

  /// Shows an informational dialog with a single button.
  static Future<void> showMessage({
    required String title,
    required String message,
    String? buttonText,
  }) async {
    final context = AppNavConfig.context;
    if (context == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CommonText(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => AppNav.back(),
            child: Text(buttonText ?? I18nKeys.ok.tr, style: TextStyle(color: settingManager.accentColor)),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog with OK and Cancel buttons.
  static Future<bool?> showConfirm({
    required String title,
    required String message,
    String? okText,
    String? cancelText,
    Color? okColor,
  }) {
    return showCustom<bool>(
      title: title,
      body: Text(message),
      actions: [
        TextButton(
          onPressed: () => AppNav.back(false),
          child: Text(cancelText ?? I18nKeys.cancel.tr, style: const TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () => AppNav.back(true),
          child: Text(
            okText ?? I18nKeys.ok.tr,
            style: TextStyle(color: okColor ?? settingManager.accentColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  /// Shows a list of selection options with checkmarks.
  /// Dismisses automatically when an item is selected via the provided callback.
  static Future<void> showSwitchDialog({required String title, required List<DialogSwitchItem> items}) async {
    final context = AppNavConfig.context;
    if (context == null) return;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: CommonText(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items
                  .map(
                    (item) => ListTile(
                      dense: true,
                      title: Text(item.label, style: const TextStyle(fontSize: 14)),
                      // Display checkmark for selected item
                      trailing: item.value
                          ? Icon(Icons.check_circle, color: settingManager.accentColor)
                          : null,
                      onTap: () {
                        // Trigger callback (which usually includes AppNav.back())
                        setDialogState(() => item.onChanged(!item.value));
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a custom content dialog with a title and optional actions.
  /// No buttons are displayed by default.
  static Future<T?> showCustom<T>({required String title, required Widget body, List<Widget>? actions}) {
    final context = AppNavConfig.context;
    if (context == null) return Future.value(null);

    return showDialog<T>(
      context: context,
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
  final ValueChanged<bool> onChanged;

  DialogSwitchItem({required this.label, required this.value, required this.onChanged});
}
