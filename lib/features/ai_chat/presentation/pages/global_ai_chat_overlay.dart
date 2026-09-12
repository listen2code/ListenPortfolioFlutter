import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/ai_chat_floating_button.dart';
import '../../../../shared/shared.dart';

/// ============================================================================
/// GlobalAiChatOverlay
/// ============================================================================
/// A root-level overlay widget wrapping the entire application navigator stack.
///
/// ### Architecture & UX Rationale:
/// - **Global Floating Entry Point**:
///   Maintains a persistent, floating AI Assistant bubble across all authenticated
///   application views (Home, Settings, Overview, Resume, Architecture) without
///   requiring individual widget trees to re-declare or manage the floating button.
/// - **Route-Aware Dynamic Visibility**:
///   Listens to [AppNav.routeChangeNotifier] to dynamically toggle button visibility.
///   Suppresses the button on login, signup, splash, and when the user is already on
///   [Routes.aiChat] to eliminate visual interference.
/// - **Screen Boundary Clamping & Responsive Coordinates**:
///   Calculates coordinate boundaries based on [MediaQueryData], safely clamping
///   within safe-area insets and preventing the button from drifting off-screen
///   during screen orientation shifts or keyboard pop-ups.
class GlobalAiChatOverlay extends ConsumerStatefulWidget {
  /// The underlying child widget tree, typically the root [MaterialApp] navigator.
  final Widget child;

  const GlobalAiChatOverlay({super.key, required this.child});

  @override
  ConsumerState<GlobalAiChatOverlay> createState() => _GlobalAiChatOverlayState();
}

class _GlobalAiChatOverlayState extends ConsumerState<GlobalAiChatOverlay> {
  /// The active route name tracked via AppNav navigation observer
  String? _currentRoute;

  /// Drag X coordinate for the floating button
  double? _posX;

  /// Drag Y coordinate for the floating button
  double? _posY;

  /// Fixed diameter of the circular floating bubble
  final double _buttonSize = 56.0;

  /// Triggered whenever the global navigation stack transitions to a new route.
  void _onRouteChanged() {
    if (mounted) {
      final newRoute = AppNav.currentRouteName;
      if (newRoute != _currentRoute) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _currentRoute = newRoute;
            });
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _currentRoute = AppNav.currentRouteName;
    AppNav.routeChangeNotifier.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    AppNav.routeChangeNotifier.removeListener(_onRouteChanged);
    super.dispose();
  }

  /// Determines whether the floating AI trigger should be visible on the current route.
  ///
  /// Hidden on auth screens (splash, login, signup) and on the AI chat page itself.
  bool _shouldShowButton() {
    final route = _currentRoute ?? AppNav.currentRouteName;
    if (route == Routes.root ||
        route == Routes.login ||
        route == Routes.signUp ||
        route == Routes.aiChat) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final showButton = _shouldShowButton();
    final mediaQuery = context.mediaQuery;
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Initialize floating coordinates to bottom-right corner once valid screen dimensions exist
    if (screenWidth > 0 && screenHeight > 0) {
      if (_posX == null || _posX! < 0 || _posX! > screenWidth - _buttonSize) {
        _posX = screenWidth - _buttonSize - 16.0;
      }
      if (_posY == null || _posY! < 0 || _posY! > screenHeight - _buttonSize) {
        _posY = screenHeight - _buttonSize - 96.0;
      }
    }

    return Stack(
      children: [
        // 1. Primary App Navigator / UI tree
        widget.child,

        // 2. Persistent Floating AI Assistant Bubble (Draggable & Clickable)
        if (showButton && _posX != null && _posY != null)
          AiChatFloatingButton(
            posX: _posX!,
            posY: _posY!,
            size: _buttonSize,
            onPanUpdate: (details) {
              setState(() {
                // Clamp X coordinate within horizontal screen margins
                _posX = (_posX! + details.delta.dx).clamp(16.0, screenWidth - _buttonSize - 16.0);
                // Clamp Y coordinate within vertical safe areas
                _posY = (_posY! + details.delta.dy).clamp(
                  mediaQuery.padding.top + 16.0,
                  screenHeight - mediaQuery.padding.bottom - _buttonSize - 16.0,
                );
              });
            },
            onTap: () => AppNav.to(Routes.aiChat),
          ),
      ],
    );
  }
}
