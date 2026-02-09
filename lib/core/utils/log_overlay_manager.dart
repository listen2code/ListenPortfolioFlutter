import 'package:flutter/material.dart';
import 'log_manager.dart';

class LogOverlayManager {
  static OverlayEntry? _overlayEntry;
  static bool _isExpanded = false;
  static Offset _offset = const Offset(20, 100);

  static void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _LogOverlayWidget(
        initialOffset: _offset,
        onPositionChanged: (newOffset) => _offset = newOffset,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isExpanded = false;
  }

  static bool get isShowing => _overlayEntry != null;
}

class _LogOverlayWidget extends StatefulWidget {
  final Offset initialOffset;
  final Function(Offset) onPositionChanged;

  const _LogOverlayWidget({required this.initialOffset, required this.onPositionChanged});

  @override
  State<_LogOverlayWidget> createState() => _LogOverlayWidgetState();
}

class _LogOverlayWidgetState extends State<_LogOverlayWidget> {
  late Offset offset;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    offset = widget.initialOffset;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      left: isExpanded ? 0 : offset.dx,
      top: isExpanded ? 0 : offset.dy,
      child: Material(
        color: Colors.transparent,
        child: isExpanded
            ? _buildExpandedView(size)
            : _buildFloatingButton(),
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
                  const Text('App Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white70, size: 20),
                    onPressed: () => LogManager.clear(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_fullscreen_rounded, color: Colors.white, size: 20),
                    onPressed: () => setState(() => isExpanded = false),
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
                  reverse: true, // Show latest logs at bottom/start
                  itemBuilder: (context, index) {
                    final log = logs[logs.length - 1 - index];
                    Color logColor = _getLogColor(log.level);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                          children: [
                            TextSpan(text: '[${log.formattedTime}] ', style: const TextStyle(color: Colors.white38)),
                            TextSpan(text: log.message, style: TextStyle(color: logColor)),
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
      case LogLevel.error: return Colors.redAccent;
      case LogLevel.warning: return Colors.orangeAccent;
      case LogLevel.debug: return Colors.blueAccent;
      default: return Colors.white70;
    }
  }
}
