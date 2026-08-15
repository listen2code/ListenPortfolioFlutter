import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import '../../domain/entities/chat_message.dart';

class AiChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const AiChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        constraints: BoxConstraints(maxWidth: context.mediaQuery.size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser
              ? primaryColor.withValues(alpha: 0.85)
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: isUser ? const Radius.circular(16.0) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16.0),
          ),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              message.content,
              useFittedBox: false,
              style: TextStyle(
                color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
            Visibility(
              visible: message.isFailed,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 14),
                    const SizedBox(width: 4),
                    CommonText(
                      I18nKeys.aiChatSendFailed.tr,
                      style: TextStyle(color: theme.colorScheme.error, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
