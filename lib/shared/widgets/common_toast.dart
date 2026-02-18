import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';

enum ToastType { info, success, error }

/// A global toast utility managed via Overlay.
class CommonToast {
  CommonToast._();

  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  /// Displays a brief toast message.
  static void show(
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    _timer?.cancel();
    _overlayEntry?.remove();

    final context = AppNavConfig.context;
    if (context == null) return;

    final overlayState = AppNavConfig.navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(message: message, type: type),
    );

    overlayState.insert(_overlayEntry!);

    _timer = Timer(duration, () {
      hide();
    });
  }

  /// Manually hides the toast.
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _timer?.cancel();
    _timer = null;
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;

  const _ToastWidget({required this.message, required this.type});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green.withAlpha((255.0 * 0.9).round());
      case ToastType.error:
        return Colors.redAccent.withAlpha((255.0 * 0.9).round());
      case ToastType.info:
        return Colors.black.withAlpha((255.0 * 0.8).round());
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 100.f, left: 40.f, right: 40.f),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.f, vertical: 12.f),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(25.f),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((255.0 * 0.2).round()),
                      blurRadius: 10.f,
                      offset: Offset(0, 5.f),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getIcon(), color: Colors.white, size: 20.f),
                    SizedBox(width: 12.f),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
