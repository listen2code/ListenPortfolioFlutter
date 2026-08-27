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
    testWidgets('renders welcome title, referral source and triggers onConfirm', (tester) async {
      bool confirmed = false;
      final data = InstallReferrerData.fromRawReferrer('refer=ListenCommunity&target=projects');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferralWelcomeDialog(
              data: data,
              onConfirm: () {
                confirmed = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for festive emoji and referral source text
      expect(find.text('🎉'), findsOneWidget);
      expect(find.text('ListenCommunity'), findsOneWidget);
      expect(find.byType(CommonButton), findsOneWidget);

      // Tap Get Started button
      await tester.tap(find.byType(CommonButton));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
    });
  });
}
