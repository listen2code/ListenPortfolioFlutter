import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text.dart';

/// A global loading indicator widget managed via Overlay.
class CommonLoading {
  CommonLoading._();

  static OverlayEntry? _overlayEntry;

  /// Notifier to track loading visibility.
  static final ValueNotifier<bool> isShowNotifier = ValueNotifier<bool>(false);

  /// Returns true if the loading overlay is currently visible.
  static bool get isShow => isShowNotifier.value;

  /// Displays a modal loading overlay.
  static void show({String? message}) {
    if (_overlayEntry != null) return;

    final overlayState = AppNavConfig.navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _LoadingWidget(message: message ?? I18nKeys.loading.tr),
    );

    overlayState.insert(_overlayEntry!);
    isShowNotifier.value = true;
  }

  /// Removes the current loading overlay.
  static void hide() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    isShowNotifier.value = false;
  }
}

class _LoadingWidget extends StatelessWidget {
  final String message;

  const _LoadingWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(30.f),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(20.f),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(context.accentColor),
                strokeWidth: 3.f,
              ),
              SizedBox(height: 20.f),
              CommonText(message, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
