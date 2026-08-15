import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/ai_chat_panel.dart';
import '../../../../shared/shared.dart';

class GlobalAiChatOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalAiChatOverlay({super.key, required this.child});

  @override
  ConsumerState<GlobalAiChatOverlay> createState() => _GlobalAiChatOverlayState();
}

class _GlobalAiChatOverlayState extends ConsumerState<GlobalAiChatOverlay> {
  bool _isPanelOpen = false;
  String? _currentRoute;
  
  // Drag coordinates for the floating button
  double? _posX;
  double? _posY;
  final double _buttonSize = 56.0;

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

  // Check if current route should show the floating AI button
  bool _shouldShowButton() {
    final route = _currentRoute ?? AppNav.currentRouteName;
    if (route == Routes.root ||
        route == Routes.login ||
        route == Routes.signUp) {
      return false;
    }
    return true;
  }

  void _togglePanel() {
    setState(() {
      _isPanelOpen = !_isPanelOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showButton = _shouldShowButton();
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // Initialize button coordinates to bottom-right of screen once valid screen dimensions are available
    if (screenWidth > 0 && screenHeight > 0) {
      if (_posX == null || _posX! < 0 || _posX! > screenWidth - _buttonSize) {
        _posX = screenWidth - _buttonSize - 16.0;
      }
      if (_posY == null || _posY! < 0 || _posY! > screenHeight - _buttonSize) {
        _posY = screenHeight - _buttonSize - 96.0;
      }
    }

    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => Stack(
            children: [
              // 1. Underlay (The main app Navigator)
              widget.child,

              // 2. Floating AI Assistant Button (Draggable)
              if (showButton && !_isPanelOpen)
                Positioned(
                  left: _posX,
                  top: _posY,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _posX = (_posX! + details.delta.dx).clamp(16.0, screenWidth - _buttonSize - 16.0);
                        _posY = (_posY! + details.delta.dy).clamp(
                          mediaQuery.padding.top + 16.0,
                          screenHeight - _buttonSize - mediaQuery.padding.bottom - 16.0,
                        );
                      });
                    },
                    onTap: _togglePanel,
                    child: Container(
                      width: _buttonSize,
                      height: _buttonSize,
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
                        border: Border.all(color: Colors.white24, width: 1.5),
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
                ),

              // 3. Sliding Full-Screen AI Panel Overlay with PopScope & Swipe-to-Dismiss
              if (_isPanelOpen)
                Positioned.fill(
                  child: PopScope(
                    canPop: !_isPanelOpen,
                    onPopInvokedWithResult: (didPop, result) {
                      if (!didPop && _isPanelOpen) {
                        _togglePanel();
                      }
                    },
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        // Swipe right (> 200 velocity) or left (< -200 velocity) to close panel
                        final velocity = details.primaryVelocity ?? 0;
                        if (velocity.abs() > 200) {
                          _togglePanel();
                        }
                      },
                      child: AiChatPanel(
                        onClose: _togglePanel,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
