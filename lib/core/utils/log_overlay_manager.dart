import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'log_manager.dart';

class LogOverlayManager {
  static OverlayEntry? _overlayEntry;
  static Offset? _offset;

  /// Notifier to let external widgets listen to the visibility state
  static final ValueNotifier<bool> isShowingNotifier = ValueNotifier(false);

  static Future<void> init(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(AppConstants.logOverlayKey) ?? false;

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
        startExpanded: startExpanded,
        onPositionChanged: (newOffset) => _offset = newOffset,
        onClose: () => hide(),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    isShowingNotifier.value = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.logOverlayKey, true);
  }

  static Future<void> hide() async {
    if (_overlayEntry == null) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    isShowingNotifier.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.logOverlayKey, false);
  }
}

class _LogOverlayWidget extends StatefulWidget {
  final Offset initialOffset;
  final bool startExpanded;
  final Function(Offset) onPositionChanged;
  final VoidCallback onClose;

  const _LogOverlayWidget({
    required this.initialOffset,
    this.startExpanded = false,
    required this.onPositionChanged,
    required this.onClose,
  });

  @override
  State<_LogOverlayWidget> createState() => _LogOverlayWidgetState();
}

class _LogOverlayWidgetState extends State<_LogOverlayWidget> {
  late Offset buttonOffset; // Memory for floating button
  late Offset windowOffset; // Temporary position for expanded window
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    buttonOffset = widget.initialOffset;
    windowOffset = Offset(0, 20); // Always starts at top-left when expanded
    isExpanded = widget.startExpanded;
  }

  // Clamps and updates the relevant offset based on expansion state
  void _updateOffset(Offset delta, Size screenSize, Size widgetSize) {
    setState(() {
      if (isExpanded) {
        windowOffset += delta;
        // Clamp window within screen (allowing header to stay visible)
        double newX = windowOffset.dx.clamp(-widgetSize.width + 50, screenSize.width - 50);
        double newY = windowOffset.dy.clamp(0, screenSize.height - 50);
        windowOffset = Offset(newX, newY);
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final expandedWidth = screenSize.width;
    final expandedHeight = screenSize.height * 0.5;

    return Positioned(
      left: isExpanded ? windowOffset.dx : buttonOffset.dx,
      top: isExpanded ? windowOffset.dy : buttonOffset.dy,
      child: Material(
        color: Colors.transparent,
        child: isExpanded
            ? _buildExpandedView(screenSize, Size(expandedWidth, expandedHeight))
            : _buildFloatingButton(screenSize),
      ),
    );
  }

  Widget _buildFloatingButton(Size screenSize) {
    return GestureDetector(
      onPanUpdate: (details) => _updateOffset(details.delta, screenSize, const Size(50, 50)),
      onTap: () {
        setState(() {
          isExpanded = true;
          windowOffset = Offset(0, 20); // Reset to top-left on expansion
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
        ),
        child: const Icon(Icons.bug_report_rounded, color: Colors.greenAccent, size: 28),
      ),
    );
  }

  Widget _buildExpandedView(Size screenSize, Size windowSize) {
    return Container(
      width: windowSize.width,
      height: windowSize.height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
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
                  Expanded(
                    child: CommonText(
                      'App Logs',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  _buildHeaderAction(Icons.refresh_rounded, () {
                    LogManager.logNotifier.value = List.from(LogManager.logs);
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
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: ValueListenableBuilder<List<LogEntry>>(
              valueListenable: LogManager.logNotifier,
              builder: (context, logs, _) {
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[logs.length - 1 - index];
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
                            TextSpan(
                              text: log.message,
                              style: TextStyle(color: _getLogColor(log.level)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
