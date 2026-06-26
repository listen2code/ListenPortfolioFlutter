import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';

class CoffeeProductCard extends StatelessWidget {
  final ProductDetails product;
  final bool isPurchasing;
  final ValueChanged<ProductDetails> onBuyProduct;

  const CoffeeProductCard({
    super.key,
    required this.product,
    required this.isPurchasing,
    required this.onBuyProduct,
  });

  String _cleanTitle(String title) {
    if (title.contains('(')) {
      return title.substring(0, title.indexOf('('));
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;
    final isTier3 = product.id == AppConstants.coffeeTier3;
    final isTier2 = product.id == AppConstants.coffeeTier2;
    final icon = isTier3
        ? Icons.local_fire_department_rounded
        : (isTier2 ? Icons.coffee_maker : Icons.coffee);

    return Card(
      margin: EdgeInsets.only(bottom: 12.f),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.f)),
      elevation: 0,
      color: context.theme.cardColor,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 8.f),
        leading: Container(
          padding: EdgeInsets.all(10.f),
          decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.08), shape: BoxShape.circle),
          child: Icon(icon, color: accentColor, size: 24.f),
        ),
        title: CommonText(
          _cleanTitle(product.title),
          style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: CommonText(
          product.description,
          style: context.textTheme.labelSmall?.copyWith(color: Colors.grey),
        ),
        trailing: SizedBox(
          width: 90.f,
          child: CommonButton(
            text: product.price,
            onPressed: () => onBuyProduct(product),
            isLoading: isPurchasing,
            isFullWidth: false,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
