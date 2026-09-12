import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import '../../domain/entities/chat_message.dart';

/// ============================================================================
/// AiChatMessageBubble
/// ============================================================================
/// Renders an individual conversation message bubble (User or Model).
///
/// ### Architecture & UX Rationale:
/// - **Role-Based Asymmetric Alignment & Styling**:
///   Aligns user prompts to [Alignment.centerRight] with a distinct primary
///   tint and asymmetric rounded corners (`bottomRight: Radius.zero`).
///   Aligns AI model responses to [Alignment.centerLeft] with a neutral surface
///   background and (`bottomLeft: Radius.zero`).
/// - **Error State Indication**:
///   Inspects [ChatMessage.isFailed] to display an inline error indicator
///   when transmission encounters network dropouts or API quota limits.
/// - **Readability Constraints**:
///   Caps width at 75% of screen width to prevent single-line text stretching
///   across wide tablets or desktop displays.
class AiChatMessageBubble extends StatelessWidget {
  /// The chat message entity to display
  final ChatMessage message;

  const AiChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;

    return Align(
      // Asymmetric alignment according to sender role
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        // Limit max width for optimal reading line-length
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
            // Message body text
            CommonText(
              message.content,
              useFittedBox: false,
              style: TextStyle(
                color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
            // Optional failure warning badge shown if message transmission failed
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

