import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

class AiChatFloatingButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;

    return Positioned(
      left: posX,
      top: posY,
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
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
