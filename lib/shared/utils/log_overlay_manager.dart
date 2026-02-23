import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listen_portfolio_flutter/core/constants/constants.dart';
import 'package:listen_portfolio_flutter/core/utils/log_manager.dart';
import 'package:listen_portfolio_flutter/core/utils/sp_util.dart';
import 'package:listen_portfolio_flutter/core/utils/zone_manager.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

enum LogFilter { all, server, app, perf }

class LogOverlayManager {
  static OverlayEntry? _overlayEntry;
  static Offset? _offset;
  static Offset? _windowOffset;
  static Size? _windowSize;

  /// Notifier to let external widgets listen to the visibility state
  static final ValueNotifier<bool> isShowingNotifier = ValueNotifier(true);

  static Future<void> init(BuildContext context) async {
    final isEnabled = SpUtil.getBool(Constants.logOverlayKey, defaultValue: true);

    if (isEnabled && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) show(context);
      });
    }
  }

  static bool get isShowing => _overlayEntry != null;

  /// [startExpanded] if true, the overlay will open in window mode directly.
  static Future<void> show(BuildContext context, {bool startExpanded = false}) async {
    if (_overlayEntry != null) {
      if (startExpanded) {
        hide();
      } else {
        return;
      }
    }

    final size = MediaQuery.of(context).size;
    // Default position for floating button: top right area
    _offset ??= Offset(size.width - 70, 100);

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

    Overlay.of(context).insert(_overlayEntry!);
    isShowingNotifier.value = true;

    await SpUtil.put(Constants.logOverlayKey, true);
  }

  static Future<void> hide() async {
    if (_overlayEntry == null) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    isShowingNotifier.value = false;

    await SpUtil.put(Constants.logOverlayKey, false);
  }
}

class _LogOverlayWidget extends StatefulWidget {
  final Offset initialOffset;
  final Offset? initialWindowOffset;
  final Size? initialWindowSize;
  final bool startExpanded;
  final Function(Offset) onPositionChanged;
  final Function(Offset, Size) onWindowChanged;
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

class _LogOverlayWidgetState extends State<_LogOverlayWidget> {
  late Offset buttonOffset; // Memory for floating button
  late Offset windowOffset; // Temporary position for expanded window
  late Size windowSize; // Dimensions of the expanded window
  late bool isExpanded;
  LogFilter currentFilter = LogFilter.all;
  bool isFilterVisible = false;
  final TextEditingController _traceController = TextEditingController();

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
    _traceController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _traceController.dispose();
    super.dispose();
  }

  // Clamps and updates the relevant offset based on expansion state
  void _updateOffset(Offset delta, Size screenSize, Size widgetSize) {
    setState(() {
      if (isExpanded) {
        windowOffset += delta;
        // Clamp window within screen boundaries
        double newX = windowOffset.dx.clamp(0, screenSize.width - windowSize.width);
        double newY = windowOffset.dy.clamp(0, screenSize.height - windowSize.height);
        windowOffset = Offset(newX, newY);
        widget.onWindowChanged(windowOffset, windowSize);
      } else {
        buttonOffset += delta;
        // Clamp button
        double newX = buttonOffset.dx.clamp(0, screenSize.width - widgetSize.width);
        double newY = buttonOffset.dy.clamp(0, screenSize.height - widgetSize.height);
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

  Widget _buildFloatingButton(Size screenSize) {
    return GestureDetector(
      onPanUpdate: (details) => _updateOffset(details.delta, screenSize, const Size(50, 50)),
      onTap: () {
        setState(() {
          isExpanded = true;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
        ),
        child: const Icon(Icons.bug_report_rounded, color: Colors.greenAccent, size: 28),
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
                  const Icon(Icons.terminal_rounded, color: Colors.greenAccent, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: CommonText(
                      'App Logs',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  _buildHeaderAction(
                    isFilterVisible ? Icons.filter_list_off_rounded : Icons.filter_list_rounded,
                    () {
                      setState(() => isFilterVisible = !isFilterVisible);
                    },
                    color: isFilterVisible ? Colors.greenAccent : Colors.white70,
                  ),
                  _buildHeaderAction(Icons.refresh_rounded, () {
                    LogManager.refresh();
                  }),
                  _buildHeaderAction(Icons.copy_rounded, () {
                    Clipboard.setData(ClipboardData(text: LogManager.getAllLogsAsText()));
                    CommonToast.show('Logs copied');
                  }),
                  _buildHeaderAction(Icons.delete_sweep_outlined, () => LogManager.clear()),
                  _buildHeaderAction(Icons.close_fullscreen_rounded, () {
                    setState(() => isExpanded = false);
                  }),
                  _buildHeaderAction(
                    Icons.power_settings_new_rounded,
                    widget.onClose,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
          // Collapsible Filter Bar
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildFilterBar(),
            crossFadeState: isFilterVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: ValueListenableBuilder<List<LogEntry>>(
              valueListenable: LogManager.logNotifier,
              builder: (context, logs, _) {
                final traceFilter = _traceController.text.trim();
                // Apply source, Trace ID and Performance filtering
                final filteredLogs = logs.where((log) {
                  // Trace ID filter
                  if (traceFilter.isNotEmpty && !log.message.contains(traceFilter)) {
                    return false;
                  }

                  // Source & Perf filter
                  final bool isMock = log.message.contains(LogManager.mockServerTag);
                  final bool isPerf =
                      log.message.contains(LogManager.summaryTag) || log.message.contains(LogManager.termTag);

                  switch (currentFilter) {
                    case LogFilter.all:
                      return true;
                    case LogFilter.server:
                      return isMock;
                    case LogFilter.app:
                      return !isMock && !isPerf;
                    case LogFilter.perf:
                      return isPerf;
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
            ),
          ),
        ],
      ),
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
                    _traceController.text = traceId;
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
              const SizedBox(width: 8),
              _filterChip('Server', LogFilter.server, color: Colors.orangeAccent),
              const SizedBox(width: 8),
              _filterChip('App', LogFilter.app, color: Colors.blueAccent),
              const SizedBox(width: 8),
              _filterChip('Perf', LogFilter.perf, color: Colors.purpleAccent),
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
                  GestureDetector(
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
    return GestureDetector(
      onTap: () => setState(() => currentFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? Colors.greenAccent).withOpacity(0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? (color ?? Colors.greenAccent).withOpacity(0.5) : Colors.white10,
            width: 0.5,
          ),
        ),
        child: Text(
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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
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
