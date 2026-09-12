import 'package:flutter/material.dart';
import '../pages/ai_chat_state.dart';
import 'ai_chat_message_bubble.dart';

/// ============================================================================
/// AiChatMessageList
/// ============================================================================
/// Virtualized scrollable list rendering message bubbles and loading indicators.
///
/// ### Architecture & UX Rationale:
/// - **Lazy List Virtualization**:
///   Uses [ListView.builder] to instantiate message widgets on-demand, ensuring
///   silky 60/120 fps scroll performance even as multi-turn conversations expand.
/// - **Integrated Typing / Streaming Spinner**:
///   Conditionally displays a centered [CircularProgressIndicator] when
///   [AiChatState.isLoading] is true, providing immediate visual feedback during
///   initial connection establishment.
class AiChatMessageList extends StatelessWidget {
  /// The scroll controller managed by the parent page
  final ScrollController scrollController;

  /// Current immutable chat state containing the message list and loading flag
  final AiChatState chatState;

  const AiChatMessageList({
    super.key,
    required this.scrollController,
    required this.chatState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Message Bubble Scroll Area
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: chatState.messages.length,
            itemBuilder: (context, index) {
              final msg = chatState.messages[index];
              return AiChatMessageBubble(message: msg);
            },
          ),
        ),

        // 2. Loading / Processing Indicator
        Visibility(
          visible: chatState.isLoading,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}

