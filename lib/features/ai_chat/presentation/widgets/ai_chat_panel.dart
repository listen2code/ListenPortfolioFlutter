import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_uikit/uikit.dart';

import 'ai_preset_questions.dart';
import '../pages/ai_chat_intent.dart';
import '../pages/ai_chat_state.dart';
import '../pages/ai_chat_view_model.dart';
import '../../../../shared/shared.dart';
import '../../../home/presentation/pages/home_view_model.dart';

class AiChatPanel extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const AiChatPanel({
    super.key,
    required this.onClose,
  });

  @override
  ConsumerState<AiChatPanel> createState() => _AiChatPanelState();
}

class _AiChatPanelState extends ConsumerState<AiChatPanel> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Re-evaluate preset questions based on current route/tab when panel opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatViewModelProvider.notifier).updatePresetQuestions();
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
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
    final theme = Theme.of(context);
    final chatState = ref.watch(aiChatViewModelProvider);
    final chatViewModel = ref.read(aiChatViewModelProvider.notifier);

    // Watch for route/tab changes. If active route changes, update preset questions automatically
    ref.listen(homeViewModelProvider, (previous, next) {
      chatViewModel.updatePresetQuestions();
    });

    return Material(
      color: Colors.transparent,
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
                Visibility(
                  visible: chatState.isLoading,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),

                // Suggestion Chips (Preset questions for the current route)
                AiPresetQuestions(
                  chatViewModel: chatViewModel,
                  chatState: chatState,
                  onSelectQuestion: _scrollToBottom,
                ),

                // Input Bar
                _buildInputBar(theme, chatViewModel, chatState),
              ],
            ),
          ),
        ),
      ),
    ),
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
              onPressed: widget.onClose,
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
                  useFittedBox: false,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    height: 1.5,
                  ),
                ),
                Visibility(
                  visible: msg.isFailed,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          I18nKeys.aiChatSendFailed.tr,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
