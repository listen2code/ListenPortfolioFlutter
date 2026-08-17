import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/ai_chat_floating_button.dart';
import '../../../../shared/shared.dart';

class GlobalAiChatOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalAiChatOverlay({super.key, required this.child});

  @override
  ConsumerState<GlobalAiChatOverlay> createState() => _GlobalAiChatOverlayState();
}

class _GlobalAiChatOverlayState extends ConsumerState<GlobalAiChatOverlay> {
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
        route == Routes.signUp ||
        route == Routes.aiChat) {
      return false;
    }
    return true;
  }

  void _openAiChatPage() {
    AppNav.to(Routes.aiChat);
  }

  @override
  Widget build(BuildContext context) {
    final showButton = _shouldShowButton();
    final mediaQuery = context.mediaQuery;
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Initialize button coordinates to bottom-right of screen once valid screen dimensions are available
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
        // 1. Main app Navigator
        widget.child,

        // 2. Floating AI Assistant Button (Draggable, navigates to Routes.aiChat on tap)
        if (showButton && _posX != null && _posY != null)
          AiChatFloatingButton(
            posX: _posX!,
            posY: _posY!,
            size: _buttonSize,
            onPanUpdate: (details) {
              setState(() {
                _posX = (_posX! + details.delta.dx).clamp(16.0, screenWidth - _buttonSize - 16.0);
                _posY = (_posY! + details.delta.dy).clamp(
                  mediaQuery.padding.top + 16.0,
                  screenHeight - _buttonSize - mediaQuery.padding.bottom - 16.0,
                );
              });
            },
            onTap: _openAiChatPage,
          ),
      ],
    );
  }
}
