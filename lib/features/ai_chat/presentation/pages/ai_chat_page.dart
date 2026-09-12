import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';

import '../../../home/presentation/pages/home_view_model.dart';
import '../pages/ai_chat_view_model.dart';
import '../widgets/ai_chat_header.dart';
import '../widgets/ai_chat_input_bar.dart';
import '../widgets/ai_chat_message_list.dart';
import '../widgets/ai_preset_questions.dart';

/// ============================================================================
/// AiChatPage
/// ============================================================================
/// Full-page route for the AI Architecture & Candidate Assistant ([Routes.aiChat]).
///
/// ### Architecture & UX Rationale:
/// - **Native Predictive Back & Swipe Gestures**:
///   By hosting the chat interface as a dedicated route rather than an overlay dialog
///   or modal bottom sheet, this page natively integrates into the Flutter Navigator
///   stack. This guarantees 100% compliance with Android 14+ Predictive Back gestures
///   and iOS full-edge interactive pop swipes without gesture collision.
/// - **Background Tab Synchronization**:
///   Listens to [homeViewModelProvider] to dynamically re-index contextual question chips
///   if the underlying home tab changes while the chat session is active.
/// - **Keyboard & Scroll Ergonomics**:
///   Ensures smooth automatic scrolling to the latest token chunk ([_scrollToBottom])
///   and provides tactile dismiss-on-tap gesture behaviors for on-screen soft keyboards.
class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  /// Controller managing user text prompt input
  final TextEditingController _inputController = TextEditingController();

  /// Scroll controller tracking the vertical position of the chat bubble list
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Refresh question recommendations and scroll to bottom after first frame renders
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

  /// Automatically scrolls the chat message list down to the latest message.
  ///
  /// Uses [WidgetsBinding.instance.addPostFrameCallback] to ensure layout passes
  /// are complete before querying [ScrollController.position.maxScrollExtent].
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

    // Synchronize contextual question chips when Home ViewModel tab transitions
    ref.listen(homeViewModelProvider, (previous, next) {
      chatViewModel.updatePresetQuestions();
    });

    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Unfocus keyboard when tapping empty spaces
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                // 1. Top Bar: Header with icon, title, persona badge & clear history action
                AiChatHeader(
                  chatViewModel: chatViewModel,
                  chatState: chatState,
                  onClose: () => AppNav.back(),
                ),
                const SizedBox(height: 12),

                // 2. Chat Stream: Scrollable message bubble list with typing indicator
                Expanded(
                  child: AiChatMessageList(
                    scrollController: _scrollController,
                    chatState: chatState,
                  ),
                ),

                // 3. Recommendation Bar: Contextual preset question chips
                AiPresetQuestions(
                  chatViewModel: chatViewModel,
                  chatState: chatState,
                  onSelectQuestion: _scrollToBottom,
                ),

                // 4. Input Bar: Bottom text field and send trigger button
                AiChatInputBar(
                  controller: _inputController,
                  chatViewModel: chatViewModel,
                  onSend: _scrollToBottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

