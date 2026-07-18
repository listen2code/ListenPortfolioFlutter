import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/widgets/coffee_purchase_bottom_sheet.dart';
import 'package:listen_portfolio_flutter/shared/services/iap/iap_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class MockIAPService extends Mock implements IIapService {}

void main() {
  testWidgets('CoffeePurchaseBottomSheet shows loading indicator initially', (WidgetTester tester) async {
    final mockIAP = MockIAPService();
    registerFallbackValue(<String>{});
    // Replace global iapService with mock
    iapService = mockIAP;
    when(() => mockIAP.queryProducts(any<Set<String>>())).thenAnswer((_) async => <ProductDetails>[]);
    when(() => mockIAP.purchaseStream).thenAnswer((_) => const Stream<List<PurchaseDetails>>.empty());

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: const CoffeePurchaseBottomSheet(),
          ),
        ),
      ),
    );
    // Loading state should show CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
