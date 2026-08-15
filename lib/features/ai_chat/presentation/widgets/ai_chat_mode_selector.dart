import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import '../pages/ai_chat_intent.dart';
import '../pages/ai_chat_state.dart';
import '../pages/ai_chat_view_model.dart';

class AiChatModeSelector extends StatelessWidget {
  final AiChatViewModel chatViewModel;
  final AiChatState chatState;

  const AiChatModeSelector({super.key, required this.chatViewModel, required this.chatState});

  @override
  Widget build(BuildContext context) {
    final isVisitor = chatState.mode == 'visitor';
    final activeColor = context.colorScheme.primary;
    final inactiveTextColor = context.colorScheme.onSurface.withValues(alpha: 0.6);

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonClickable(
              onTap: () => chatViewModel.handleIntent(const AiChatIntent.changeMode('visitor')),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: isVisitor ? activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: CommonText(
                    I18nKeys.aiModeVisitor.tr,
                    style: TextStyle(
                      color: isVisitor ? context.colorScheme.onPrimary : inactiveTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: CommonClickable(
              onTap: () => chatViewModel.handleIntent(const AiChatIntent.changeMode('interviewer')),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: !isVisitor ? activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: CommonText(
                    I18nKeys.aiModeInterviewer.tr,
                    style: TextStyle(
                      color: !isVisitor ? context.colorScheme.onPrimary : inactiveTextColor,
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
}
