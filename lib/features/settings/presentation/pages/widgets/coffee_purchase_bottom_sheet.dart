import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'coffee_product_card.dart';
import 'coffee_purchase/coffee_purchase_intent.dart';
import 'coffee_purchase/coffee_purchase_state.dart';
import 'coffee_purchase/coffee_purchase_view_model.dart';

class CoffeePurchaseBottomSheet extends ConsumerStatefulWidget {
  const CoffeePurchaseBottomSheet({super.key});

  @override
  ConsumerState<CoffeePurchaseBottomSheet> createState() => _CoffeePurchaseBottomSheetState();
}

class _CoffeePurchaseBottomSheetState extends ConsumerState<CoffeePurchaseBottomSheet>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref
          .read(coffeePurchaseViewModelProvider.notifier)
          .handleIntent(const CoffeePurchaseIntent.appResumed());
    }
  }

  Widget _buildBody(BuildContext context, CoffeePurchaseState state, CoffeePurchaseViewModel viewModel) {
    if (state.isLoading) {
      return const Center(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 40), child: CircularProgressIndicator()),
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: CommonText(
            I18nKeys.iapNotAvailable.tr,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: state.products
          .map(
            (product) => CoffeeProductCard(
              product: product,
              isPurchasing: state.isPurchasing && state.purchasingProductId == product.id,
              onBuyProduct: (prod) {
                viewModel.handleIntent(CoffeePurchaseIntent.buyProduct(prod.id));
              },
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coffeePurchaseViewModelProvider);
    final viewModel = ref.read(coffeePurchaseViewModelProvider.notifier);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.f, vertical: 24.f),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.f)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  I18nKeys.selectAmount.tr,
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                CommonIconButton(
                  icon: Icon(Icons.close, size: 20.f),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 16.f),
            _buildBody(context, state, viewModel),
            SizedBox(height: 12.f),
          ],
        ),
      ),
    );
  }
}
