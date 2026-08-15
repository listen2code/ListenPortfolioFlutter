import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import '../pages/ai_chat_intent.dart';
import '../pages/ai_chat_state.dart';
import '../pages/ai_chat_view_model.dart';

class AiChatHeader extends StatelessWidget {
  final AiChatViewModel chatViewModel;
  final AiChatState chatState;
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
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
