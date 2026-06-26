import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/widgets/coffee_product_card.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class MockBuyCallback extends Mock {
  void call(ProductDetails product);
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      ProductDetails(
        id: 'fallback_id',
        title: 'fallback_title',
        description: 'fallback_desc',
        price: 'fallback_price',
        rawPrice: 0.0,
        currencyCode: 'USD',
      ),
    );
  });

  testWidgets('CoffeeProductCard displays title and triggers onBuyProduct', (WidgetTester tester) async {
    final mockCallback = MockBuyCallback();
    final product = ProductDetails(
      id: 'test_id',
      title: 'Coffee (Premium)',
      description: 'Test description',
      price: '\$4.99',
      rawPrice: 4.99,
      currencyCode: 'USD',
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CoffeeProductCard(
          product: product,
          isPurchasing: false,
          onBuyProduct: mockCallback,
        ),
      ),
    ));

    // Title is cleaned to 'Coffee '
    expect(find.text('Coffee '), findsOneWidget);

    // Tap the purchase button
    await tester.tap(find.text('\$4.99'));
    await tester.pump();

    verify(() => mockCallback(product)).called(1);
  });
}
