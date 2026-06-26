import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import 'widgets/coffee_product_card.dart';

class CoffeePurchaseBottomSheet extends StatefulWidget {
  const CoffeePurchaseBottomSheet({super.key});

  @override
  State<CoffeePurchaseBottomSheet> createState() => _CoffeePurchaseBottomSheetState();
}

class _CoffeePurchaseBottomSheetState extends State<CoffeePurchaseBottomSheet> with WidgetsBindingObserver {
  List<ProductDetails> _products = [];
  bool _isLoading = true;
  bool _isPurchasing = false;
  String? _purchasingProductId;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadProducts();
    _subscription = iapService.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object err) {
        appLogger.e('CoffeeDialog: Purchase stream error: $err');
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // If the app resumes and we are still in purchasing state,
      // it means the native payment dialog was closed.
      // We add a slight delay to allow the purchaseStream to fire and process.
      // If no success event pops the sheet, we restore the button state.
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted && _isPurchasing) {
          setState(() {
            _isPurchasing = false;
            _purchasingProductId = null;
          });
        }
      });
    }
  }

  Future<void> _loadProducts() async {
    try {
      final products = await iapService.queryProducts(AppConstants.coffeeProductIds);
      if (mounted) {
        setState(() {
          _products = products..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      CommonToast.show(I18nKeys.iapNotAvailable.tr, type: ToastType.error);
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      // Eliminate string hardcoding by verifying against the defined product ID constants.
      if (AppConstants.coffeeProductIds.contains(purchase.productID)) {
        if (purchase.status == PurchaseStatus.purchased) {
          iapService.completePurchase(purchase);
          if (mounted) {
            setState(() {
              _isPurchasing = false;
              _purchasingProductId = null;
            });
          }
          CommonToast.show(I18nKeys.buyCoffeeSuccess.tr, type: ToastType.success);
          ReviewService().checkAndPromptReview(force: true);
          Navigator.of(context).pop();
        } else if (purchase.status == PurchaseStatus.error) {
          if (mounted) {
            setState(() {
              _isPurchasing = false;
              _purchasingProductId = null;
            });
          }
          CommonToast.show(I18nKeys.buyCoffeeFailed.tr, type: ToastType.error);
        } else if (purchase.status == PurchaseStatus.canceled) {
          if (mounted) {
            setState(() {
              _isPurchasing = false;
              _purchasingProductId = null;
            });
          }
        }
      }
    }
  }

  void _buyProduct(ProductDetails product) async {
    setState(() {
      _isPurchasing = true;
      _purchasingProductId = product.id;
    });
    try {
      await iapService.buyProduct(product);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPurchasing = false;
          _purchasingProductId = null;
        });
      }
      CommonToast.show(I18nKeys.buyCoffeeFailed.tr, type: ToastType.error);
    }
  }

  /// Flat conditional rendering using early returns.
  /// This keeps the widget hierarchy flat and easy to read.
  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 40), child: CircularProgressIndicator()),
      );
    }

    if (_products.isEmpty) {
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
      children: _products
          .map(
            (product) => CoffeeProductCard(
              product: product,
              isPurchasing: _isPurchasing && _purchasingProductId == product.id,
              onBuyProduct: _buyProduct,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                IconButton(
                  icon: Icon(Icons.close, size: 20.f),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 16.f),
            _buildBody(context),
            SizedBox(height: 12.f),
          ],
        ),
      ),
    );
  }
}
