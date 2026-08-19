import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_panel.dart';
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
    testWidgets('renders AiChatPage with AiChatPanel correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AiChatPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AiChatPage), findsOneWidget);
      expect(find.byType(AiChatPanel), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
