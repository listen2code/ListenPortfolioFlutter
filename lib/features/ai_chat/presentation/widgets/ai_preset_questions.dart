import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import '../pages/ai_chat_intent.dart';
import '../pages/ai_chat_state.dart';
import '../pages/ai_chat_view_model.dart';

class AiPresetQuestions extends StatelessWidget {
  final AiChatViewModel chatViewModel;
  final AiChatState chatState;
  final VoidCallback onSelectQuestion;

  const AiPresetQuestions({
    super.key,
    required this.chatViewModel,
    required this.chatState,
    required this.onSelectQuestion,
  });

  @override
  Widget build(BuildContext context) {
    if (chatState.presetQuestions.isEmpty) return const SizedBox.shrink();
    final theme = context.theme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            I18nKeys.aiPresetQuestions.tr,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
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
                    label: CommonText(
                      question,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      ),
                    ),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                    side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.12), width: 0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      chatViewModel.handleIntent(AiChatIntent.sendMessage(question));
                      onSelectQuestion();
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
}
