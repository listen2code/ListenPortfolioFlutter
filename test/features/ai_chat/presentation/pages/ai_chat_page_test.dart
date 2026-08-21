import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_header.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_input_bar.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_message_list.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
  });

  group('AiChatPage Widget Tests', () {
    testWidgets('renders AiChatPage with header, message list, and input bar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AiChatPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AiChatPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AiChatHeader), findsOneWidget);
      expect(find.byType(AiChatMessageList), findsOneWidget);
      expect(find.byType(AiChatInputBar), findsOneWidget);
    });
  });
}
