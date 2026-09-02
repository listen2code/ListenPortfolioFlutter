import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/services/referrer/install_referrer_data.dart';
import 'package:listen_portfolio_flutter/shared/widgets/dialogs/referral_welcome_dialog.dart';
import 'package:listen_uikit/uikit.dart';

import '../../test_helpers/test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setupTestEnvironment();
  });

  group('ReferralWelcomeDialog Widget Tests', () {
    testWidgets('renders welcome title, referral source, checkbox and triggers onConfirm with checked state', (tester) async {
      bool? resultDoNotShow;
      final data = InstallReferrerData.fromRawReferrer('refer=ListenCommunity&target=projects&utm_source=twitter&utm_campaign=spring2026');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferralWelcomeDialog(
              data: data,
              onConfirm: (doNotShowAgain) {
                resultDoNotShow = doNotShowAgain;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for festive emoji, parameter details card, refer and utm_source texts
      expect(find.text('🎉'), findsOneWidget);
      expect(find.text('ListenCommunity'), findsOneWidget);
      expect(find.text('projects'), findsOneWidget);
      expect(find.text('twitter'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(CommonButton), findsOneWidget);

      // Default is unchecked
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);

      // Tap the Checkbox to check it
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);

      // Ensure button is visible before tapping
      await tester.ensureVisible(find.byType(CommonButton));
      await tester.pumpAndSettle();

      // Tap Get Started button
      await tester.tap(find.byType(CommonButton));
      await tester.pumpAndSettle();

      expect(resultDoNotShow, isTrue);
    });

    testWidgets('unchecking / leaving checkbox unchecked passes false to onConfirm', (tester) async {
      bool? resultDoNotShow;
      final data = InstallReferrerData.fromRawReferrer('refer=ListenVIP');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferralWelcomeDialog(
              data: data,
              onConfirm: (doNotShowAgain) {
                resultDoNotShow = doNotShowAgain;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure button is visible before tapping
      await tester.ensureVisible(find.byType(CommonButton));
      await tester.pumpAndSettle();

      // Tap Get Started button directly (leaving unchecked)
      await tester.tap(find.byType(CommonButton));
      await tester.pumpAndSettle();

      expect(resultDoNotShow, isFalse);
    });
  });
}
