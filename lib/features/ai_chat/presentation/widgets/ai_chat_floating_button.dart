import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

/// ============================================================================
/// AiChatFloatingButton
/// ============================================================================
/// A custom frosted-glass circular floating button with gesture disambiguation.
///
/// ### Architecture & UX Rationale:
/// - **Touch Jitter Disambiguation (< 6.0px Threshold)**:
///   On mobile capacitive touchscreens, placing a finger down often produces
///   micro-movements of 1-3 pixels. Standard [GestureDetector] pan recognizers
///   will eagerly consume the gesture and abort `onTap`. To eliminate user
///   frustration, [_AiChatFloatingButtonState] tracks the cumulative displacement
///   in [_dragDelta]. If the net drag distance is under 6.0 pixels when the finger
///   lifts, it is treated as a high-confidence tap intent.
/// - **Modern Glassmorphic Aesthetic**:
///   Combines [BackdropFilter] with [BoxShadow] and high-opacity primary accent colors
///   to ensure high contrast across both light and dark background surfaces.
class AiChatFloatingButton extends StatefulWidget {
  /// The horizontal left coordinate on the screen.
  final double posX;

  /// The vertical top coordinate on the screen.
  final double posY;

  /// The circular diameter of the button.
  final double size;

  /// Callback emitted during active drag operations.
  final GestureDragUpdateCallback onPanUpdate;

  /// Callback emitted when the button is tapped or released after micro-drag.
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
  /// Cumulative offset tracked during a pan gesture session to detect jitter
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
        // Reset displacement accumulator on initial touch down
        onPanStart: (_) {
          _dragDelta = Offset.zero;
        },
        // Accumulate drag delta and forward update event to parent overlay
        onPanUpdate: (details) {
          _dragDelta += details.delta;
          widget.onPanUpdate(details);
        },
        // If movement was minimal (micro-jitter < 6px), resolve as tap
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
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.4),
                blurRadius: 16.0,
                spreadRadius: 2.0,
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.24),
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Center(
                child: Icon(
                  Icons.smart_toy_outlined,
                  color: theme.colorScheme.onPrimary,
                  size: 28.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

