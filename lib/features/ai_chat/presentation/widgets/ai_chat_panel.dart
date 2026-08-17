import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';

import '../../../home/presentation/pages/home_view_model.dart';
import '../pages/ai_chat_view_model.dart';
import 'ai_chat_header.dart';
import 'ai_chat_input_bar.dart';
import 'ai_chat_message_list.dart';
import 'ai_chat_mode_selector.dart';
import 'ai_preset_questions.dart';

class AiChatPanel extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const AiChatPanel({super.key, required this.onClose});

  @override
  ConsumerState<AiChatPanel> createState() => _AiChatPanelState();
}

class _AiChatPanelState extends ConsumerState<AiChatPanel> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
    final chatState = ref.watch(aiChatViewModelProvider);
    final chatViewModel = ref.read(aiChatViewModelProvider.notifier);

    ref.listen(homeViewModelProvider, (previous, next) {
      chatViewModel.updatePresetQuestions();
    });

    final theme = context.theme;

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              AiChatHeader(chatViewModel: chatViewModel, chatState: chatState, onClose: widget.onClose),
              const SizedBox(height: 12),
              AiChatModeSelector(chatViewModel: chatViewModel, chatState: chatState),
              const SizedBox(height: 12),
              Expanded(
                child: AiChatMessageList(scrollController: _scrollController, chatState: chatState),
              ),
              AiPresetQuestions(
                chatViewModel: chatViewModel,
                chatState: chatState,
                onSelectQuestion: _scrollToBottom,
              ),
              AiChatInputBar(
                controller: _inputController,
                chatViewModel: chatViewModel,
                onSend: _scrollToBottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
