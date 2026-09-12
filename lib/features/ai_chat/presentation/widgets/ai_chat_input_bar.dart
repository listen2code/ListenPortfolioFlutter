import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import '../pages/ai_chat_intent.dart';
import '../pages/ai_chat_view_model.dart';

/// ============================================================================
/// AiChatInputBar
/// ============================================================================
/// Bottom input bar providing prompt text editing and submission triggers.
///
/// ### Architecture & UX Rationale:
/// - **Keyboard Inset Adaptation**:
///   Uses `MediaQuery.of(context).viewInsets.bottom` to naturally elevate the
///   input bar when virtual on-screen soft keyboards animate upward.
/// - **Dual Submit Triggers**:
///   Supports both tapping the dedicated send icon button and pressing Enter/Return
///   on hardware or software keyboards (`TextInputAction.send` + `\n` detection).
/// - **Clean Dispatch**:
///   Dispatches [AiChatIntent.sendMessage] to the ViewModel and triggers
///   [onSend] callback to auto-scroll the conversation to the bottom.
class AiChatInputBar extends StatelessWidget {
  /// Controller managing text editing state
  final TextEditingController controller;

  /// ViewModel reference for intent dispatching
  final AiChatViewModel chatViewModel;

  /// Callback executed after a prompt is successfully submitted
  final VoidCallback onSend;

  const AiChatInputBar({
    super.key,
    required this.controller,
    required this.chatViewModel,
    required this.onSend,
  });

  /// Submits the non-empty text, clears the controller, and invokes [onSend].
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
      // Dynamic padding avoiding keyboard occlusion
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            // Text input field
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CommonTextField(
                  controller: controller,
                  hintText: I18nKeys.aiChatInputPlaceholder.tr,
                  textInputAction: TextInputAction.send,
                  onChanged: (val) {
                    // Detect Enter key newline insertion to trigger submission
                    if (val.endsWith('\n')) {
                      _submit();
                    }
                  },
                ),
              ),
            ),
            // Send icon button
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

