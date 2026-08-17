import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

class AiChatFloatingButton extends StatefulWidget {
  final double posX;
  final double posY;
  final double size;
  final GestureDragUpdateCallback onPanUpdate;
  final VoidCallback onTap;

  const AiChatFloatingButton({
    super.key,
    required this.posX,
    required this.posY,
    required this.size,
    required this.onPanUpdate,
    required this.onTap,
  });

  @override
  State<AiChatFloatingButton> createState() => _AiChatFloatingButtonState();
}

class _AiChatFloatingButtonState extends State<AiChatFloatingButton> {
  Offset _dragDelta = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;

    return Positioned(
      left: widget.posX,
      top: widget.posY,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) {
          _dragDelta = Offset.zero;
        },
        onPanUpdate: (details) {
          _dragDelta += details.delta;
          widget.onPanUpdate(details);
        },
        onPanEnd: (_) {
          if (_dragDelta.distance < 6.0) {
            widget.onTap();
          }
        },
        onTap: widget.onTap,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withValues(alpha: 0.85),
            boxShadow: [
              BoxShadow(color: primaryColor.withValues(alpha: 0.4), blurRadius: 16.0, spreadRadius: 2.0),
            ],
            border: Border.all(color: theme.colorScheme.onPrimary.withValues(alpha: 0.24), width: 1.5),
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Center(
                child: Icon(Icons.smart_toy_outlined, color: theme.colorScheme.onPrimary, size: 28.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
