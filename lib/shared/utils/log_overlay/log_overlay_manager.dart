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
    appLogger.d('LogOverlayManager: init called, context mounted: ${context.mounted}');
    final isEnabled = SpUtil.getBool(logOverlayKey, defaultValue: true);
    isShowingNotifier.value = isEnabled;
    appLogger.d('LogOverlayManager: init - isEnabled: $isEnabled');

    if (isEnabled && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appLogger.d('LogOverlayManager: init - postFrameCallback triggered, mounted: ${context.mounted}');
        if (context.mounted) show(context);
      });
    }
  }

  static bool get isShowing => _overlayEntry != null;

  /// [startExpanded] if true, the overlay will open in window mode directly.
  static Future<void> show(BuildContext context, {bool startExpanded = false}) async {
    if (kReleaseMode) return;
    appLogger.d('LogOverlayManager: show called, startExpanded: $startExpanded, isAlreadyShowing: $isShowing');
    if (_overlayEntry != null) {
      if (startExpanded) {
        hide();
      } else {
        return;
      }
    }

    final size = MediaQuery.of(context).size;
    // Default position for floating button: top right area, protecting against zero width/height during early bootstrap
    if (size.width > 100) {
      _offset ??= Offset(size.width - 150, 100);
    } else {
      _offset ??= const Offset(200, 100); // Absolute safe fallback
    }
    appLogger.d('LogOverlayManager: show - default offset: $_offset');

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

    appLogger.d('LogOverlayManager: show - finding OverlayState...');
    final overlayState = Overlay.maybeOf(context) ?? AppNavConfig.navigatorKey.currentState?.overlay;
    appLogger.d('LogOverlayManager: show - overlayState found: ${overlayState != null}');
    if (overlayState != null) {
      try {
        overlayState.insert(_overlayEntry!);
        appLogger.d('LogOverlayManager: show - overlayState.insert success');
      } catch (e, stack) {
        appLogger.e('LogOverlayManager: show - overlayState.insert ERROR: $e\n$stack');
      }
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
