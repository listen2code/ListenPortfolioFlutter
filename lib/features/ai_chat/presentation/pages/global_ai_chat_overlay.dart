import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';

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
    if (_currentRoute == null ||
        _currentRoute == Routes.root ||
        _currentRoute == Routes.login ||
        _currentRoute == Routes.signUp) {
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

    // Initialize button coordinates to bottom-right of screen
    if (_posX == null || _posY == null) {
      _posX = screenWidth - _buttonSize - 16.0;
      _posY = screenHeight - _buttonSize - 96.0; // Avoid standard navigation bars
    }

    return Stack(
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

        // 3. Sliding Full-Screen AI Panel Overlay
        if (_isPanelOpen)
          Positioned.fill(
            child: AiChatPanel(
              onClose: _togglePanel,
            ),
          ),
      ],
    );
  }
}
