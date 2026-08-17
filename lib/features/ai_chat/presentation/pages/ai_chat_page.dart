import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';

import '../widgets/ai_chat_panel.dart';

/// Full-page route for AI Chat Assistant.
class AiChatPage extends ConsumerWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: AiChatPanel(
          onClose: () => AppNav.back(),
        ),
      ),
    );
  }
}
