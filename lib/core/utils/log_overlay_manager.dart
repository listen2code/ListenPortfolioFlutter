import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/utils/snack_bar_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'log_manager.dart';

class LogOverlayManager {
  static OverlayEntry? _overlayEntry;
  static Offset _offset = const Offset(20, 100);
  static VoidCallback? _onStateChanged;

  static Future<void> init(BuildContext context, {VoidCallback? onStateChanged}) async {
    _onStateChanged = onStateChanged;
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(AppConstants.logOverlayKey) ?? false;

    if (isEnabled && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) show(context);
      });
    }
  }

  /// [startExpanded] if true, the overlay will open in full-dialog mode directly.
  static Future<void> show(BuildContext context, {bool startExpanded = false}) async {
    if (_overlayEntry != null) {
      // If already showing but we want to expand it
      if (startExpanded) {
        // We can't easily reach the state of the existing entry from here,
        // so we hide and re-show.
        hide();
      } else {
        return;
      }
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => _LogOverlayWidget(
        initialOffset: _offset,
        startExpanded: startExpanded,
        onPositionChanged: (newOffset) => _offset = newOffset,
        onClose: () {
          hide();
          if (_onStateChanged != null) _onStateChanged!();
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.logOverlayKey, true);
  }

  static Future<void> hide() async {
    _overlayEntry?.remove();
    _overlayEntry = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.logOverlayKey, false);
  }

  static bool get isShowing => _overlayEntry != null;
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
  late Offset offset;
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    offset = widget.initialOffset;
    isExpanded = widget.startExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      left: isExpanded ? 0 : offset.dx,
      top: isExpanded ? 0 : offset.dy,
      child: Material(
        color: Colors.transparent,
        child: isExpanded ? _buildExpandedView(size) : _buildFloatingButton(),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          offset += details.delta;
          widget.onPositionChanged(offset);
        });
      },
      onTap: () => setState(() => isExpanded = true),
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

  Widget _buildExpandedView(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.terminal_rounded, color: Colors.greenAccent, size: 20),
                  const SizedBox(width: 10),
                  const Text(
                    'App Logs',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: Colors.white70, size: 20),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: LogManager.getAllLogsAsText()));
                      SnackBarUtil.show('Logs copied to clipboard');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white70, size: 20),
                    onPressed: () => LogManager.clear(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_fullscreen_rounded, color: Colors.white, size: 20),
                    onPressed: () => setState(() => isExpanded = false),
                  ),
                  IconButton(
                    icon: const Icon(Icons.power_settings_new_rounded, color: Colors.redAccent, size: 20),
                    onPressed: widget.onClose,
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
                          style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
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
