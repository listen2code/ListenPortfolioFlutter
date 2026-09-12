import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import '../pages/ai_chat_intent.dart';
import '../pages/ai_chat_state.dart';
import '../pages/ai_chat_view_model.dart';

/// ============================================================================
/// AiChatHeader
/// ============================================================================
/// The top navigation and control bar for the AI Assistant chat page.
///
/// ### Architecture & UX Rationale:
/// - **Text Truncation Defense**:
///   Uses [Expanded] and [TextOverflow.ellipsis] to protect title and subtitle
///   labels from overflowing on compact mobile devices or with long translated CJK text.
/// - **Session Controls**:
///   Includes a clear history icon button ([AiChatIntent.clearHistory]) to allow
///   users to reset conversational memory at will, and a standard close button.
class AiChatHeader extends StatelessWidget {
  /// Reference to ViewModel for intent dispatching
  final AiChatViewModel chatViewModel;

  /// Current immutable chat state
  final AiChatState chatState;

  /// Callback executed when tapping the close navigation icon
  final VoidCallback onClose;

  const AiChatHeader({
    super.key,
    required this.chatViewModel,
    required this.chatState,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. Left Section: AI Robot Branding, Title and Status Subtitle
        Expanded(
          child: Row(
            children: [
              Icon(Icons.smart_toy, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      I18nKeys.aiChatTitle.tr,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    CommonText(
                      I18nKeys.aiChatSubtitle.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // 2. Right Section: Session Actions (Clear History & Close View)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonIconButton(
              icon: Icon(
                Icons.delete_sweep_outlined,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              tooltip: I18nKeys.clearCache.tr,
              onPressed: () {
                chatViewModel.handleIntent(const AiChatIntent.clearHistory());
              },
            ),
            CommonIconButton(icon: const Icon(Icons.close_rounded), onPressed: onClose),
          ],
        ),
      ],
    );
  }
}

