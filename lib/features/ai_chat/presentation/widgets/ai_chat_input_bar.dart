import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import '../pages/ai_chat_intent.dart';
import '../pages/ai_chat_view_model.dart';

class AiChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final AiChatViewModel chatViewModel;
  final VoidCallback onSend;

  const AiChatInputBar({
    super.key,
    required this.controller,
    required this.chatViewModel,
    required this.onSend,
  });

  void _submit() {
    final text = controller.text;
    if (text.trim().isNotEmpty) {
      chatViewModel.handleIntent(AiChatIntent.sendMessage(text));
      controller.clear();
      onSend();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: I18nKeys.aiChatInputPlaceholder.tr,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ),
            CommonIconButton(
              icon: Icon(Icons.send_rounded, color: theme.colorScheme.primary),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
