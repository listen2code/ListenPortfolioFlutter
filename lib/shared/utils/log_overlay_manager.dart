import 'dart:async';
import 'dart:ui' show PointMode;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../shared.dart';

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

class _LogOverlayWidget extends StatefulWidget {
  final Offset initialOffset;
  final Offset? initialWindowOffset;
  final Size? initialWindowSize;
  final bool startExpanded;
  final void Function(Offset) onPositionChanged;
  final void Function(Offset, Size) onWindowChanged;
  final VoidCallback onClose;

  const _LogOverlayWidget({
    required this.initialOffset,
    this.initialWindowOffset,
    this.initialWindowSize,
    this.startExpanded = false,
    required this.onPositionChanged,
    required this.onWindowChanged,
    required this.onClose,
  });

  @override
  State<_LogOverlayWidget> createState() => _LogOverlayWidgetState();
}

enum OverlayTab { logs, perf }

class _LogOverlayWidgetState extends State<_LogOverlayWidget> {
  late Offset buttonOffset; // Memory for floating button
  late Offset windowOffset; // Temporary position for expanded window
  late Size windowSize; // Dimensions of the expanded window
  late bool isExpanded;
  LogFilter currentFilter = LogFilter.all;
  OverlayTab currentTab = OverlayTab.logs;
  bool isFilterVisible = false;
  final TextEditingController _traceController = TextEditingController();

  // Explicitly tracked playback progress state
  PlaybackProgress? _playbackProgress;

  static const double minWidth = 250.0;
  static const double minHeight = 200.0;
  static const double handleSize = 30.0;

  @override
  void initState() {
    super.initState();
    buttonOffset = widget.initialOffset;
    windowOffset = widget.initialWindowOffset ?? const Offset(0, 50);
    windowSize = widget.initialWindowSize ?? Size.zero;
    isExpanded = widget.startExpanded;

    _playbackProgress = MviPlaybackPlayer.instance.progress;

    // Start monitoring frame metrics on overlay initialization
    FrameMonitor.instance.start();

    _traceController.addListener(() {
      setState(() {});
    });
    // Listen to playback player progress changes to explicitly update local widget state
    MviPlaybackPlayer.instance.onProgressChanged = (progress) {
      if (mounted) {
        setState(() {
          _playbackProgress = progress;
        });
      }
    };
  }

  @override
  void dispose() {
    // Stop frame timing callbacks to release resources
    FrameMonitor.instance.stop();
    _traceController.dispose();
    // Clean up playback progress listener
    MviPlaybackPlayer.instance.onProgressChanged = null;
    super.dispose();
  }

  // Clamps and updates the relevant offset based on expansion state
  void _updateOffset(Offset delta, Size screenSize, Size widgetSize) {
    setState(() {
      if (isExpanded) {
        windowOffset += delta;
        // Clamp window within screen boundaries
        final double newX = windowOffset.dx.clamp(0, screenSize.width - windowSize.width);
        final double newY = windowOffset.dy.clamp(0, screenSize.height - windowSize.height);
        windowOffset = Offset(newX, newY);
        widget.onWindowChanged(windowOffset, windowSize);
      } else {
        buttonOffset += delta;
        // Clamp button
        final double newX = buttonOffset.dx.clamp(0, screenSize.width - widgetSize.width);
        final double newY = buttonOffset.dy.clamp(0, screenSize.height - widgetSize.height);
        buttonOffset = Offset(newX, newY);
        widget.onPositionChanged(buttonOffset);
      }
    });
  }

  // Logic to handle resizing from corners and edges
  void _handleResize(Offset delta, Alignment alignment, Size screenSize) {
    setState(() {
      double newX = windowOffset.dx;
      double newY = windowOffset.dy;
      double newW = windowSize.width;
      double newH = windowSize.height;

      if (alignment == Alignment.topLeft) {
        newX += delta.dx;
        newY += delta.dy;
        newW -= delta.dx;
        newH -= delta.dy;
      } else if (alignment == Alignment.topRight) {
        newY += delta.dy;
        newW += delta.dx;
        newH -= delta.dy;
      } else if (alignment == Alignment.bottomLeft) {
        newX += delta.dx;
        newW -= delta.dx;
        newH += delta.dy;
      } else if (alignment == Alignment.bottomRight) {
        newW += delta.dx;
        newH += delta.dy;
      } else if (alignment == Alignment.bottomCenter) {
        newH += delta.dy;
      }

      // Enforce minimum size and screen boundaries
      if (newW >= minWidth && (newX >= 0 && newX + newW <= screenSize.width)) {
        windowOffset = Offset(newX, windowOffset.dy);
        windowSize = Size(newW, windowSize.height);
      }
      if (newH >= minHeight && (newY >= 0 && newY + newH <= screenSize.height)) {
        windowOffset = Offset(windowOffset.dx, newY);
        windowSize = Size(windowSize.width, newH);
      }
      widget.onWindowChanged(windowOffset, windowSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Initialize default window size if not set (first expansion)
    if (windowSize == Size.zero) {
      windowSize = Size(screenSize.width, screenSize.height * 0.5);
    }

    return Positioned(
      left: isExpanded ? windowOffset.dx : buttonOffset.dx,
      top: isExpanded ? windowOffset.dy : buttonOffset.dy,
      child: Material(
        color: Colors.transparent,
        child: isExpanded ? _buildExpandedViewWithHandles(screenSize) : _buildFloatingButton(screenSize),
      ),
    );
  }

  Future<void> _showSaveDialog({bool shouldExpandAfter = false}) async {
    final controller = TextEditingController();
    await CommonDialog.showCustom<void>(
      title: I18nKeys.saveTape.tr,
      barrierDismissible: false,
      body: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: I18nKeys.enterTapeName.tr),
      ),
      actions: [
        CommonButton(
          text: I18nKeys.discard.tr,
          type: ButtonType.text,
          foregroundColor: Colors.grey,
          isFullWidth: false,
          onPressed: () {
            MviPlaybackRecorder.instance.stopRecording();
            AppNav.back();
            CommonToast.show(I18nKeys.discardTapeMsg.tr);
          },
        ),
        CommonButton(
          text: I18nKeys.save.tr,
          type: ButtonType.text,
          isFullWidth: false,
          onPressed: () async {
            final name = await MviPlaybackRecorder.instance.stopRecording(customName: controller.text);
            AppNav.back();
            CommonToast.show(I18nKeys.saveTapeSuccessMsg.tr.replaceAll('%s', name));
            AppNav.to(Routes.playbackTapeList);
          },
        ),
      ],
    );
    if (mounted) {
      setState(() {
        if (shouldExpandAfter) {
          isExpanded = true;
        }
      });
    }
  }

  Widget _buildFloatingButton(Size screenSize) {
    final isRecording = MviPlaybackRecorder.instance.isRecording;

    // ignore: use_common_clickable
    return GestureDetector(
      onPanUpdate: (details) => _updateOffset(details.delta, screenSize, const Size(130, 50)),
      onTap: () {
        if (isRecording) {
          // Click to stop recording directly from the collapsed button,
          // prompt save dialog, and expand the log manager window upon completion.
          _showSaveDialog(shouldExpandAfter: false);
        } else {
          setState(() => isExpanded = true);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 130.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(color: Colors.white10, width: 0.5),
              boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black45, offset: Offset(0, 4))],
            ),
            child: Row(
              children: [
                // Left-side circular control icon
                Container(
                  width: 50.0,
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Icon(
                    isRecording
                        ? Icons.stop_rounded
                        : (_playbackProgress?.isPlaying == true
                              ? Icons.play_arrow_rounded
                              : Icons.bug_report_rounded),
                    color: isRecording
                        ? Colors.redAccent
                        : (_playbackProgress?.isPlaying == true ? Colors.blueAccent : Colors.greenAccent),
                    size: 26.0,
                  ),
                ),
                const VerticalDivider(color: Colors.white10, width: 1, indent: 10, endIndent: 10),
                // Right-side real-time FPS mini line chart
                const Expanded(child: Center(child: _FpsMiniChart())),
                const SizedBox(width: 8),
              ],
            ),
          ),
          if (_playbackProgress?.isPlaying == true &&
              _playbackProgress?.currentStepName.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: CommonText(
                '${_playbackProgress?.currentStepIndex}/${_playbackProgress?.totalSteps}\n${_playbackProgress?.currentStepName}',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedViewWithHandles(Size screenSize) {
    return Stack(
      children: [
        _buildWindowContent(screenSize),
        // Corner Resize Handles
        _buildResizeHandle(Alignment.topLeft, screenSize),
        _buildResizeHandle(Alignment.topRight, screenSize),
        _buildResizeHandle(Alignment.bottomLeft, screenSize),
        _buildResizeHandle(Alignment.bottomRight, screenSize),
        // Bottom Edge Resize Handle
        _buildResizeHandle(Alignment.bottomCenter, screenSize),
      ],
    );
  }

  Widget _buildResizeHandle(Alignment alignment, Size screenSize) {
    double? left, top, width, height;

    if (alignment == Alignment.bottomCenter) {
      left = handleSize;
      top = windowSize.height - handleSize;
      width = windowSize.width - (handleSize * 2);
      height = handleSize;
    } else {
      left = (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft)
          ? 0
          : windowSize.width - handleSize;
      top = (alignment == Alignment.topLeft || alignment == Alignment.topRight)
          ? 0
          : windowSize.height - handleSize;
      width = handleSize;
      height = handleSize;
    }

    return Positioned(
      left: left,
      top: top,
      // ignore: use_common_clickable
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) => _handleResize(details.delta, alignment, screenSize),
        child: Container(
          width: width,
          height: height,
          color: Colors.transparent, // Invisible interactive area
        ),
      ),
    );
  }

  Widget _buildWindowContent(Size screenSize) {
    return Container(
      width: windowSize.width,
      height: windowSize.height,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10, width: 0.5),
        boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black54)],
      ),
      child: Column(
        children: [
          // Draggable Header Bar
          // ignore: use_common_clickable
          GestureDetector(
            onPanUpdate: (details) => _updateOffset(details.delta, screenSize, windowSize),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(
                    currentTab == OverlayTab.logs ? Icons.terminal_rounded : Icons.bar_chart_rounded,
                    color: Colors.greenAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CommonText(
                      currentTab == OverlayTab.logs
                          ? I18nKeys.appLogs.tr
                          : (I18nKeys.appLogs.tr == '日志' ? '性能分析面板' : 'Performance APM'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  if (currentTab == OverlayTab.logs)
                    _buildHeaderAction(
                      isFilterVisible ? Icons.filter_list_off_rounded : Icons.filter_list_rounded,
                      () {
                        setState(() => isFilterVisible = !isFilterVisible);
                      },
                      color: isFilterVisible ? Colors.greenAccent : Colors.white70,
                    ),
                  _buildHeaderAction(Icons.refresh_rounded, () {
                    if (currentTab == OverlayTab.logs) {
                      LogManager.refresh();
                    } else {
                      // Reset Performance Stats and force a pipeline refresh
                      FrameMonitor.instance.stop();
                      FrameMonitor.instance.start();
                      WidgetsBinding.instance.scheduleFrame();
                      CommonToast.show(I18nKeys.appLogs.tr == '日志' ? '性能数据已重置' : 'Performance metrics reset');
                    }
                  }),
                  _buildHeaderAction(Icons.copy_rounded, () {
                    if (currentTab == OverlayTab.logs) {
                      Clipboard.setData(ClipboardData(text: LogManager.getAllLogsAsText()));
                      CommonToast.show(I18nKeys.copiedToClipboard.tr);
                    } else {
                      // Copy performance summary
                      final buffer = StringBuffer('=== PERFORMANCE APM SUMMARY ===\n');
                      final snapshot = FrameMonitor.instance.snapshot.value;
                      if (snapshot != null) {
                        buffer.writeln('FPS: ${snapshot.fps.toStringAsFixed(1)}');
                        buffer.writeln('Janks: ${snapshot.jankCount} (Severe: ${snapshot.severeJankCount})');
                        buffer.writeln(
                          'Worst Frame: ${(snapshot.worstFrameUs / 1000.0).toStringAsFixed(1)} ms',
                        );
                        buffer.writeln('Memory RSS: ${snapshot.memoryMB} MB');
                      }
                      Clipboard.setData(ClipboardData(text: buffer.toString()));
                      CommonToast.show(I18nKeys.copiedToClipboard.tr);
                    }
                  }),
                  _buildHeaderAction(Icons.delete_sweep_outlined, () {
                    if (currentTab == OverlayTab.logs) {
                      LogManager.clear();
                    } else {
                      PerfTraceStore.instance.clear();
                    }
                  }),
                  _buildHeaderAction(Icons.fiber_manual_record, () {
                    if (!(_playbackProgress?.isPlaying ?? false)) {
                      MviPlaybackRecorder.instance.startRecording();
                      // Collapse overlay when starting recording
                      setState(() => isExpanded = false);
                      CommonToast.show(I18nKeys.recordingStartedMsg.tr);
                    }
                  }, color: Colors.red),
                  _buildHeaderAction(Icons.video_library_rounded, () {
                    if (!(_playbackProgress?.isPlaying ?? false)) {
                      // Collapse overlay when navigating to tape list
                      setState(() => isExpanded = false);
                      AppNav.to(Routes.playbackTapeList);
                    }
                  }, color: Colors.blueAccent),
                  _buildHeaderAction(
                    Icons.close_fullscreen_rounded,
                    () => setState(() => isExpanded = false),
                  ),
                  _buildHeaderAction(
                    Icons.power_settings_new_rounded,
                    widget.onClose,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white.withValues(alpha: 0.02),
            child: Row(
              children: [
                _tabChip('📋 Logs', OverlayTab.logs),
                const SizedBox(width: 8),
                _tabChip('📊 Perf Dashboard', OverlayTab.perf),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),

          // Collapsible Filter Bar (Only visible in Logs Tab)
          if (currentTab == OverlayTab.logs)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildFilterBar(),
              crossFadeState: isFilterVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          if (currentTab == OverlayTab.logs) const Divider(color: Colors.white10, height: 1),

          // Tab Content
          Expanded(
            child: currentTab == OverlayTab.logs
                ? _buildLogsTabContent()
                : _PerfDashboardTab(traceFilter: _traceController.text),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(String label, OverlayTab tab) {
    final bool isSelected = currentTab == tab;
    return CommonClickable(
      onTap: () => setState(() => currentTab = tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.greenAccent.withValues(alpha: 0.15) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.greenAccent.withValues(alpha: 0.4) : Colors.white10,
            width: 0.5,
          ),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            color: isSelected ? Colors.greenAccent : Colors.white38,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLogsTabContent() {
    return ValueListenableBuilder<List<LogEntry>>(
      valueListenable: LogManager.logNotifier,
      builder: (context, logs, _) {
        final traceFilter = _traceController.text.trim();
        // Apply source, Trace ID and Performance filtering
        final filteredLogs = logs.where((log) {
          // Trace ID filter
          if (traceFilter.isNotEmpty && !log.message.contains(traceFilter)) {
            return false;
          }

          // Source, Perf, and Playback filter
          final bool isMock = log.message.contains(LogManager.mockServerTag);
          final bool isPerf =
              log.message.contains(LogManager.summaryTag) || log.message.contains(LogManager.termTag);
          final bool isPlayback = log.message.contains('[${MviPlaybackPlayer.tag}]');

          switch (currentFilter) {
            case LogFilter.all:
              return true;
            case LogFilter.server:
              return isMock;
            case LogFilter.app:
              return !isMock && !isPerf && !isPlayback;
            case LogFilter.perf:
              return isPerf;
            case LogFilter.playback:
              return isPlayback;
          }
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: filteredLogs.length,
          itemBuilder: (context, index) {
            final log = filteredLogs[filteredLogs.length - 1 - index];
            return _buildLogRow(log);
          },
        );
      },
    );
  }

  Widget _buildLogRow(LogEntry log) {
    // Attempt to extract traceId from format [uuid-v4] or mainTraceId
    final traceRegex = RegExp('\\[([a-f0-9-]{36}|${ZoneManager.mainTraceId})\\]');
    final match = traceRegex.firstMatch(log.message);
    final String? traceId = match?.group(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 10),
          children: [
            TextSpan(
              text: '[${log.formattedTime}] ',
              style: const TextStyle(color: Colors.white38),
            ),
            if (traceId != null) ...[
              const TextSpan(
                text: '[',
                style: TextStyle(color: Colors.white24),
              ),
              TextSpan(
                text: traceId,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      currentTab = OverlayTab.perf;
                      _traceController.text = traceId;
                    });
                    if (!isFilterVisible) setState(() => isFilterVisible = true);
                  },
              ),
              const TextSpan(
                text: '] ',
                style: TextStyle(color: Colors.white24),
              ),
              TextSpan(
                text: log.message.replaceFirst('[$traceId]', ''),
                style: TextStyle(color: _getLogColor(log.level)),
              ),
            ] else
              TextSpan(
                text: log.message,
                style: TextStyle(color: _getLogColor(log.level)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white.withValues(alpha: 0.02),
      child: Column(
        children: [
          Row(
            children: [
              _filterChip('All', LogFilter.all),
              const SizedBox(width: 6),
              _filterChip('Server', LogFilter.server, color: Colors.orangeAccent),
              const SizedBox(width: 6),
              _filterChip('App', LogFilter.app, color: Colors.blueAccent),
              const SizedBox(width: 6),
              _filterChip('Perf', LogFilter.perf, color: Colors.purpleAccent),
              const SizedBox(width: 6),
              _filterChip('playback', LogFilter.playback, color: Colors.redAccent),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, size: 14, color: Colors.white24),
                const SizedBox(width: 8),
                Expanded(
                  // ignore: use_common_text_field
                  child: TextField(
                    controller: _traceController,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                    decoration: const InputDecoration(
                      hintText: 'Filter by Trace ID...',
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 11),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (_traceController.text.isNotEmpty)
                  CommonClickable(
                    onTap: () => _traceController.clear(),
                    child: const Icon(Icons.close_rounded, size: 14, color: Colors.white24),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, LogFilter filter, {Color? color}) {
    final bool isSelected = currentFilter == filter;
    return CommonClickable(
      onTap: () => setState(() => currentFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? Colors.greenAccent).withValues(alpha: 0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? (color ?? Colors.greenAccent).withValues(alpha: 0.5) : Colors.white10,
            width: 0.5,
          ),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            color: isSelected ? (color ?? Colors.greenAccent) : Colors.white38,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap, {Color color = Colors.white70}) {
    return CommonClickable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 5, top: 5, bottom: 5),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Color _getLogColor(LogLevel level) {
    switch (level) {
      case LogLevel.error:
        return Colors.redAccent;
      case LogLevel.warning:
        return Colors.orangeAccent;
      case LogLevel.debug:
        return Colors.blueAccent;
      default:
        return Colors.white70;
    }
  }
}

/// A mini real-time FPS chart widget drawn using CustomPainter.
///
/// Implements [RepaintBoundary] and disables anti-aliasing for optimized drawing.
class _FpsMiniChart extends StatelessWidget {
  const _FpsMiniChart();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FrameMonitorSnapshot?>(
      valueListenable: FrameMonitor.instance.snapshot,
      builder: (context, snapshot, _) {
        if (snapshot == null) return const SizedBox.shrink();

        final double fps = snapshot.fps;
        final Color color = _fpsColor(fps);

        return RepaintBoundary(
          child: SizedBox(
            width: 70,
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(60, 16),
                  painter: _MiniChartPainter(frames: snapshot.recentFrames, color: color),
                ),
                const SizedBox(height: 2),
                CommonText(
                  '${fps.round()} FPS',
                  style: TextStyle(color: color, fontSize: 8.0, fontWeight: FontWeight.bold, height: 1.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _fpsColor(double fps) {
    if (fps >= 55) return Colors.greenAccent;
    if (fps >= 50) return Colors.yellowAccent;
    if (fps >= 30) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}

/// Fast CustomPainter for drawing chronological frame latencies on a mini canvas.
class _MiniChartPainter extends CustomPainter {
  final RingBuffer<FrameMetric> frames;
  final Color color;

  _MiniChartPainter({required this.frames, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (frames.isEmpty) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = false; // Disable anti-aliasing for batch-rendering acceleration

    final int len = frames.length;
    final int displayCount = len > 25 ? 25 : len;
    final int startIndex = len - displayCount;

    final double stepX = size.width / 24.0;
    // Cap vertical latency range at 50ms for scaling
    final double maxLatencyUs = 50000.0;

    final path = Path();
    bool first = true;

    for (int i = 0; i < displayCount; i++) {
      final metric = frames[startIndex + i];

      // Perform pixel snapping to avoid sub-pixel rendering blur
      final double x = (i * stepX).roundToDouble();
      final double yFraction = (metric.totalDurationUs / maxLatencyUs).clamp(0.0, 1.0);
      final double y = (size.height - (yFraction * size.height)).roundToDouble();

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MiniChartPainter oldDelegate) {
    if (oldDelegate.frames.length != frames.length) return true;
    if (frames.isNotEmpty && oldDelegate.frames.isNotEmpty) {
      return oldDelegate.frames[oldDelegate.frames.length - 1].totalDurationUs !=
          frames[frames.length - 1].totalDurationUs;
    }
    return false;
  }
}

/// The main dashboard tab content for APM performance monitoring.
class _PerfDashboardTab extends StatefulWidget {
  final String? traceFilter;

  const _PerfDashboardTab({this.traceFilter});

  @override
  State<_PerfDashboardTab> createState() => _PerfDashboardTabState();
}

class _PerfDashboardTabState extends State<_PerfDashboardTab> {
  final Map<String, bool> _expandedIntents = {};
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Periodically request a frame and notify listeners every 500ms to keep chart scrolling alive even when idle
    _refreshTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        WidgetsBinding.instance.scheduleFrame();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FrameMonitorSnapshot?>(
      valueListenable: FrameMonitor.instance.snapshot,
      builder: (context, snapshot, _) {
        if (snapshot == null) {
          return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Large Real-Time FPS Line Chart
            _buildChartSection(snapshot),
            const SizedBox(height: 16),

            // 2. Stats Cards
            _buildStatsGrid(snapshot),
            const SizedBox(height: 16),

            // 3. Structure Trace Records (Pages and Intents)
            _buildTraceLogsSection(),
          ],
        );
      },
    );
  }

  Widget _buildChartSection(FrameMonitorSnapshot snapshot) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                'FPS Trend (5s)',
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              CommonText('Target Budget: Auto', style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(height: 100, child: _FpsLineChart(snapshot: snapshot)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(FrameMonitorSnapshot snapshot) {
    final worstMs = snapshot.worstFrameUs / 1000.0;

    return Row(
      children: [
        // Jank Count Card
        Expanded(
          child: _buildStatCard(
            'Jank Statistics',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatItem('Janks (Total)', '${snapshot.jankCount}', Colors.orangeAccent),
                _buildStatItem('Severe Janks', '${snapshot.severeJankCount}', Colors.redAccent),
                _buildStatItem('Worst Frame', '${worstMs.toStringAsFixed(1)} ms', Colors.purpleAccent),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Memory Card
        Expanded(
          child: _buildStatCard(
            'Memory Usage',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  '${snapshot.memoryMB} MB',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const CommonText(
                  'Dart RSS Footprint (Excludes Native Cache)',
                  style: TextStyle(color: Colors.white38, fontSize: 10, height: 1.3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, Widget content) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title,
            style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          content,
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String val, Color valColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          CommonText(
            val,
            style: TextStyle(color: valColor, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTraceLogsSection() {
    return ValueListenableBuilder<List<PerfTraceEntry>>(
      valueListenable: PerfTraceStore.instance.traces,
      builder: (context, traces, _) {
        final filter = widget.traceFilter?.trim() ?? '';
        final filteredTraces = traces.where((t) {
          if (filter.isNotEmpty && t.traceId != filter) return false;
          return true;
        }).toList();

        if (filteredTraces.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            alignment: Alignment.center,
            child: const CommonText(
              'No Trace Records Captured Yet.\nNavigate pages or execute actions to populate.',
              style: TextStyle(color: Colors.white24, fontSize: 11, height: 1.4),
            ),
          );
        }

        // Partition traces into Page Render and Intent Traces
        final pages = filteredTraces.where((t) => t.label == 'Page Render').toList();
        final intents = filteredTraces.where((t) => t.label == 'Intent').toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pages.isNotEmpty) ...[
              CommonSettingsSectionTitle(
                title: I18nKeys.appLogs.tr == '日志' ? '页面渲染跟踪 (Page Render)' : 'Page Render Traces',
              ),
              const SizedBox(height: 8),
              _buildPageTracesCard(pages),
              const SizedBox(height: 20),
            ],
            if (intents.isNotEmpty) ...[
              CommonSettingsSectionTitle(
                title: I18nKeys.appLogs.tr == '日志' ? '业务行为耗时 (Intent Traces)' : 'Intent Traces',
              ),
              const SizedBox(height: 8),
              _buildIntentTracesCard(intents),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPageTracesCard(List<PerfTraceEntry> pages) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pages.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
        itemBuilder: (context, idx) {
          final page = pages[pages.length - 1 - idx];
          final color = _pageLatencyColor(page.totalMs);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        page.name,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      CommonText(
                        'Trace ID: ${page.traceId}',
                        style: const TextStyle(color: Colors.white24, fontSize: 9),
                      ),
                    ],
                  ),
                ),
                CommonText(
                  '${page.totalMs} ms',
                  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _pageLatencyColor(int ms) {
    if (ms <= 16) return Colors.greenAccent;
    if (ms <= 32) return Colors.yellowAccent;
    return Colors.redAccent;
  }

  Widget _buildIntentTracesCard(List<PerfTraceEntry> intents) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: intents.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
        itemBuilder: (context, idx) {
          final intent = intents[intents.length - 1 - idx];
          final isExpanded = _expandedIntents[intent.traceId] ?? (widget.traceFilter == intent.traceId);

          return Column(
            children: [
              CommonClickable(
                onTap: () {
                  setState(() {
                    _expandedIntents[intent.traceId] = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                        color: Colors.white30,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              intent.name,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            CommonText(
                              'Trace ID: ${intent.traceId}',
                              style: const TextStyle(color: Colors.white24, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      CommonText(
                        '${intent.totalMs} ms',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded) ...[
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 16, bottom: 12),
                  child: Column(
                    children: intent.stages.map((stage) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              '├ ${stage.name}',
                              style: const TextStyle(color: Colors.white38, fontSize: 10),
                            ),
                            CommonText(
                              '${stage.durationMs} ms',
                              style: const TextStyle(color: Colors.white54, fontSize: 10),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// A line chart displaying real-time FPS frame rendering latency with reference lines.
class _FpsLineChart extends StatelessWidget {
  final FrameMonitorSnapshot snapshot;

  const _FpsLineChart({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _LineChartPainter(frames: snapshot.recentFrames),
      ),
    );
  }
}

/// Canvas painter optimized using batch-rendering instruction.
class _LineChartPainter extends CustomPainter {
  final RingBuffer<FrameMetric> frames;

  const _LineChartPainter({required this.frames});

  @override
  void paint(Canvas canvas, Size size) {
    if (frames.isEmpty) return;

    final int len = frames.length;
    // Map to maximum 120 frames in the viewport (~2 seconds of timeline)
    final int displayCount = len > 120 ? 120 : len;
    final int startIndex = len - displayCount;

    final double stepX = size.width / 119.0;
    final double maxLatencyUs = 50000.0; // 50ms cap

    // 1. Draw horizontal reference threshold grid lines
    _drawReferenceLine(
      canvas,
      size,
      16670,
      maxLatencyUs,
      '16.6ms (60Hz)',
      Colors.yellowAccent.withValues(alpha: 0.15),
    );
    _drawReferenceLine(
      canvas,
      size,
      8333,
      maxLatencyUs,
      '8.3ms (120Hz)',
      Colors.redAccent.withValues(alpha: 0.15),
    );

    // 2. Prepare paths for UI Frame build lines and GPU raster lines
    final path = Path();
    bool first = true;
    final List<Offset> jankPoints = [];

    for (int i = 0; i < displayCount; i++) {
      final metric = frames[startIndex + i];
      final double x = (i * stepX).roundToDouble(); // Pixel snapping

      final double yFraction = (metric.totalDurationUs / maxLatencyUs).clamp(0.0, 1.0);
      final double y = (size.height - (yFraction * size.height)).roundToDouble();

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }

      if (metric.isJank) {
        jankPoints.add(Offset(x, y));
      }
    }

    // 3. Render core latency line
    final linePaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..isAntiAlias = true;

    canvas.drawPath(path, linePaint);

    // 4. Batch-draw drop-frame Jank anchors as red dots
    if (jankPoints.isNotEmpty) {
      final dotPaint = Paint()
        ..color = Colors.redAccent
        ..style = PaintingStyle.fill
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;

      canvas.drawPoints(PointMode.points, jankPoints, dotPaint);
    }
  }

  void _drawReferenceLine(
    Canvas canvas,
    Size size,
    double targetUs,
    double maxUs,
    String label,
    Color color,
  ) {
    final double yFraction = (targetUs / maxUs).clamp(0.0, 1.0);
    final double y = (size.height - (yFraction * size.height)).roundToDouble();

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw dashed threshold line
    double curX = 0;
    const double dashWidth = 4.0;
    const double spaceWidth = 4.0;

    while (curX < size.width) {
      canvas.drawLine(Offset(curX, y), Offset(curX + dashWidth, y), linePaint);
      curX += dashWidth + spaceWidth;
    }

    // Draw indicator label text
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(8, y - 10));
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    if (oldDelegate.frames.length != frames.length) return true;
    if (frames.isNotEmpty && oldDelegate.frames.isNotEmpty) {
      return oldDelegate.frames[oldDelegate.frames.length - 1].totalDurationUs !=
          frames[frames.length - 1].totalDurationUs;
    }
    return false;
  }
}
