import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import 'ai_chat_intent.dart';
import 'ai_chat_state.dart';
import 'ai_chat_view_model.dart';
import '../../../../shared/shared.dart';
import '../../../home/presentation/pages/home_view_model.dart';

class GlobalAiChatOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalAiChatOverlay({super.key, required this.child});

  @override
  ConsumerState<GlobalAiChatOverlay> createState() => _GlobalAiChatOverlayState();
}

class _GlobalAiChatOverlayState extends ConsumerState<GlobalAiChatOverlay> with SingleTickerProviderStateMixin {
  bool _isPanelOpen = false;
  
  // Drag coordinates for the floating button
  double? _posX;
  double? _posY;
  final double _buttonSize = 56.0;

  // Input controller
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _onRouteChanged() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    AppNav.routeChangeNotifier.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    AppNav.routeChangeNotifier.removeListener(_onRouteChanged);
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Check if current route should show the floating AI button
  bool _shouldShowButton() {
    final route = AppNav.currentRouteName;
    if (route == null || route == Routes.root || route == Routes.login || route == Routes.signUp) {
      return false;
    }
    return true;
  }

  void _togglePanel() {
    setState(() {
      _isPanelOpen = !_isPanelOpen;
    });

    if (_isPanelOpen) {
      // Re-evaluate preset questions based on current route/tab when panel opens
      ref.read(aiChatViewModelProvider.notifier).updatePresetQuestions();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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

    final chatState = ref.watch(aiChatViewModelProvider);
    final chatViewModel = ref.read(aiChatViewModelProvider.notifier);

    // Watch for route/tab changes. If active route changes, update preset questions automatically
    ref.listen(homeViewModelProvider, (previous, next) {
      if (_isPanelOpen) {
        chatViewModel.updatePresetQuestions();
      }
    });

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
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: Colors.black54,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        // Header
                        _buildHeader(theme, chatViewModel, chatState),
                        const SizedBox(height: 12),

                        // Mode Selector Tab Bar
                        _buildModeSelector(theme, chatViewModel, chatState),
                        const SizedBox(height: 12),

                        // Chat Message List
                        Expanded(
                          child: _buildChatList(chatState),
                        ),

                        // Loading Indicators
                        if (chatState.isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),

                        // Suggestion Chips (Preset questions for the current route)
                        if (chatState.presetQuestions.isNotEmpty)
                          _buildPresetQuestions(theme, chatViewModel, chatState),

                        // Input Bar
                        _buildInputBar(theme, chatViewModel, chatState),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, AiChatViewModel chatViewModel, AiChatState chatState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.smart_toy, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  I18nKeys.aiChatTitle.tr,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                CommonText(
                  I18nKeys.aiChatSubtitle.tr,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            CommonIconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.grey),
              tooltip: I18nKeys.clearCache.tr,
              onPressed: () {
                chatViewModel.handleIntent(const AiChatIntent.clearHistory());
              },
            ),
            CommonIconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: _togglePanel,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeSelector(ThemeData theme, AiChatViewModel chatViewModel, AiChatState chatState) {
    final isVisitor = chatState.mode == 'visitor';
    final activeColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => chatViewModel.handleIntent(const AiChatIntent.changeMode('visitor')),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: isVisitor ? activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: CommonText(
                    I18nKeys.aiModeVisitor.tr,
                    style: TextStyle(
                      color: isVisitor ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => chatViewModel.handleIntent(const AiChatIntent.changeMode('interviewer')),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: !isVisitor ? activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: CommonText(
                    I18nKeys.aiModeInterviewer.tr,
                    style: TextStyle(
                      color: !isVisitor ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(AiChatState chatState) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: chatState.messages.length,
      itemBuilder: (context, index) {
        final msg = chatState.messages[index];
        final isUser = msg.role == 'user';

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
                bottomLeft: isUser ? const Radius.circular(16.0) : Radius.zero,
                bottomRight: isUser ? Radius.zero : const Radius.circular(16.0),
              ),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  msg.content,
                  style: const TextStyle(color: Colors.white, height: 1.4),
                ),
                if (msg.isFailed)
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 14),
                        SizedBox(width: 4),
                        Text('发送失败', style: TextStyle(color: Colors.redAccent, fontSize: 10)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPresetQuestions(ThemeData theme, AiChatViewModel chatViewModel, AiChatState chatState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            I18nKeys.aiPresetQuestions.tr,
            style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: chatState.presetQuestions.length,
              itemBuilder: (context, index) {
                final question = chatState.presetQuestions[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    label: Text(
                      question,
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    side: const BorderSide(color: Colors.white24, width: 0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      chatViewModel.handleIntent(AiChatIntent.sendMessage(question));
                      _scrollToBottom();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme, AiChatViewModel chatViewModel, AiChatState chatState) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    hintText: I18nKeys.aiChatInputPlaceholder.tr,
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      chatViewModel.handleIntent(AiChatIntent.sendMessage(value));
                      _inputController.clear();
                      _scrollToBottom();
                    }
                  },
                ),
              ),
            ),
            CommonIconButton(
              icon: Icon(Icons.send_rounded, color: theme.colorScheme.primary),
              onPressed: () {
                final text = _inputController.text;
                if (text.trim().isNotEmpty) {
                  chatViewModel.handleIntent(AiChatIntent.sendMessage(text));
                  _inputController.clear();
                  _scrollToBottom();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
