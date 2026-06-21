import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';

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
          child: Text(
            I18nKeys.iapNotAvailable.tr,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(children: _products.map((product) => _buildProductCard(context, product)).toList());
  }

  Widget _buildProductCard(BuildContext context, ProductDetails product) {
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
        title: Text(
          _cleanTitle(product.title),
          style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          product.description,
          style: context.textTheme.labelSmall?.copyWith(color: Colors.grey),
        ),
        trailing: SizedBox(
          width: 90.f,
          child: CommonButton(
            text: product.price,
            onPressed: () => _buyProduct(product),
            isLoading: _isPurchasing && _purchasingProductId == product.id,
            isFullWidth: false,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  String _cleanTitle(String title) {
    return title.substring(0, title.indexOf('('));
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
                Text(
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
