import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

import '../../../../shared/utils/playback_registry_init.dart';

part 'ai_chat_intent.freezed.dart';

@freezed
class AiChatIntent extends BaseIntent with _$AiChatIntent {
  const factory AiChatIntent.init() = _Init;
  const factory AiChatIntent.sendMessage(String text) = _SendMessage;
  const factory AiChatIntent.changeMode(String mode) = _ChangeMode;
  const factory AiChatIntent.clearHistory() = _ClearHistory;

  const AiChatIntent._();

  static void registerPlayback() {
    MviPlaybackRegistry.register(
      'AiChatIntent',
      'init',
      (args) => const AiChatIntent.init(),
    );
    MviPlaybackRegistry.register(
      'AiChatIntent',
      'sendMessage',
      (args) => AiChatIntent.sendMessage(args['text'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'AiChatIntent',
      'changeMode',
      (args) => AiChatIntent.changeMode(args['mode'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'AiChatIntent',
      'clearHistory',
      (args) => const AiChatIntent.clearHistory(),
    );
  }
}
