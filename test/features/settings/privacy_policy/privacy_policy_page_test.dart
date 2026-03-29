import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/privacy_policy/privacy_policy_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrivacyPolicyPage Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('Should display privacy policy page', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: PrivacyPolicyPage())));
      await tester.pumpAndSettle();
      expect(find.byType(PrivacyPolicyPage), findsOneWidget);
    });
  });
}
