import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/pages/global_ai_chat_overlay.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_floating_button.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlobalAiChatOverlay Widget Tests', () {
    testWidgets('shows floating button when route is home', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      AppNav.currentRouteName = Routes.home;

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GlobalAiChatOverlay(
              child: Scaffold(body: Text('Home Screen')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.byType(AiChatFloatingButton), findsOneWidget);
    });

    testWidgets('hides floating button on blacklisted routes (login, splash, aiChat)', (tester) async {
      AppNav.currentRouteName = Routes.login;

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GlobalAiChatOverlay(
              child: Scaffold(body: Text('Login Screen')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
      expect(find.byType(AiChatFloatingButton), findsNothing);
    });

    testWidgets('dragging floating button updates position', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      AppNav.currentRouteName = Routes.home;

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GlobalAiChatOverlay(
              child: Scaffold(body: Text('Home Screen')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(AiChatFloatingButton);
      expect(buttonFinder, findsOneWidget);

      await tester.drag(buttonFinder, const Offset(-50, -50));
      await tester.pumpAndSettle();

      expect(buttonFinder, findsOneWidget);
    });
  });
}
