import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show PointMode;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../shared.dart';

part 'widgets/fps_charts.dart';
part 'widgets/perf_dashboard_tab.dart';
part 'widgets/log_overlay_widget.dart';

enum LogFilter { all, server, app, perf, playback }

class LogOverlayManager {
  LogOverlayManager._();

  static const String logOverlayKey = 'log_overlay_key';
  static OverlayEntry? _overlayEntry;
  static Offset? _offset;
  static Offset? _windowOffset;
  static Size? _windowSize;

  /// Notifier to let external widgets listen to the visibility state
  static final ValueNotifier<bool> isShowingNotifier = ValueNotifier(false);

  static Future<void> init(BuildContext context) async {
    if (kReleaseMode) return;
    final isEnabled = SpUtil.getBool(logOverlayKey, defaultValue: true);
    isShowingNotifier.value = isEnabled;

    if (isEnabled && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) show(context);
      });
    }
  }

  static bool get isShowing => _overlayEntry != null;

  /// [startExpanded] if true, the overlay will open in window mode directly.
  static Future<void> show(BuildContext context, {bool startExpanded = false}) async {
    if (kReleaseMode) return;
    if (_overlayEntry != null) {
      if (startExpanded) {
        hide();
      } else {
        return;
      }
    }

    final size = MediaQuery.of(context).size;
    // Default position for floating button: top right area
    _offset ??= Offset(size.width - 150, 100);

    _overlayEntry = OverlayEntry(
      builder: (context) => _LogOverlayWidget(
        initialOffset: _offset!,
        initialWindowOffset: _windowOffset,
        initialWindowSize: _windowSize,
        startExpanded: startExpanded,
        onPositionChanged: (newOffset) => _offset = newOffset,
        onWindowChanged: (newOffset, newSize) {
          _windowOffset = newOffset;
          _windowSize = newSize;
        },
        onClose: () => hide(),
      ),
    );

    final overlayState = Overlay.maybeOf(context) ?? AppNavConfig.navigatorKey.currentState?.overlay;
    if (overlayState != null) {
      overlayState.insert(_overlayEntry!);
    } else {
      appLogger.e('LogOverlayManager: No OverlayState found!');
      return;
    }
    isShowingNotifier.value = true;

    await SpUtil.put(logOverlayKey, true);
  }

  static Future<void> hide() async {
    if (_overlayEntry == null) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    isShowingNotifier.value = false;

    await SpUtil.put(logOverlayKey, false);
  }
}
