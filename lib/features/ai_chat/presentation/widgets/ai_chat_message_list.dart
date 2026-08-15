import 'package:flutter/material.dart';
import '../pages/ai_chat_state.dart';
import 'ai_chat_message_bubble.dart';

class AiChatMessageList extends StatelessWidget {
  final ScrollController scrollController;
  final AiChatState chatState;

  const AiChatMessageList({super.key, required this.scrollController, required this.chatState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
