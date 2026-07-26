import 'dart:async';

import 'package:collection/collection.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../shared/shared.dart';
import 'coffee_purchase_intent.dart';
import 'coffee_purchase_state.dart';

part 'coffee_purchase_view_model.g.dart';

@riverpod
class CoffeePurchaseViewModel extends _$CoffeePurchaseViewModel
    with ViewModelMixin<CoffeePurchaseState, CoffeePurchaseIntent> {
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  CoffeePurchaseState build() => const CoffeePurchaseState();

  @override
  void onInit() {
    super.onInit();
    _subscription = iapService.purchaseStream.listen(
      (purchases) => handleIntent(CoffeePurchaseIntent.purchaseUpdated(purchases)),
      onError: (Object err) {
        appLogger.e('CoffeePurchaseViewModel: Purchase stream error: $err');
      },
    );
    handleIntent(const CoffeePurchaseIntent.init());
  }

  @override
  void onDispose() {
    _subscription?.cancel();
    super.onDispose();
  }

  @override
  FutureOr<void> onIntent(CoffeePurchaseIntent intent) {
    return intent.when<FutureOr<void>>(
      init: _onInit,
      buyProduct: (productId) => _onBuyProduct(productId),
      purchaseUpdated: (purchases) => _onPurchaseUpdated(purchases),
      appResumed: _onAppResumed,
    );
  }

  Future<void> _onInit() async {
    try {
      final products = await iapService.queryProducts(AppConstants.coffeeProductIds);
      updateState(
        state.copyWith(
          products: products..sort((a, b) => a.rawPrice.compareTo(b.rawPrice)),
          isLoading: false,
        ),
      );
    } catch (e) {
      updateState(state.copyWith(isLoading: false));
      emitEffect(MessageEffect.error(I18nKeys.iapNotAvailable.tr));
    }
  }

  Future<void> _onBuyProduct(String productId) async {
    final product = state.products.firstWhereOrNull((p) => p.id == productId);
    if (product == null) return;

    updateState(state.copyWith(isPurchasing: true, purchasingProductId: productId));

    try {
      await iapService.buyProduct(product);
    } catch (e) {
      updateState(state.copyWith(isPurchasing: false, purchasingProductId: null));
      emitEffect(MessageEffect.error(I18nKeys.buyCoffeeFailed.tr));
    }
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (AppConstants.coffeeProductIds.contains(purchase.productID)) {
        if (purchase.status == PurchaseStatus.purchased) {
          await iapService.completePurchase(purchase);
          updateState(state.copyWith(isPurchasing: false, purchasingProductId: null));
          emitEffect(MessageEffect.info(I18nKeys.buyCoffeeSuccess.tr));
          emitEffect(RateAppEffect(action: RateAppAction.checkAndPrompt, force: true));
          emitEffect(NavigationEffect<void>.back());
        } else if (purchase.status == PurchaseStatus.error) {
          updateState(state.copyWith(isPurchasing: false, purchasingProductId: null));
          emitEffect(MessageEffect.error(I18nKeys.buyCoffeeFailed.tr));
        } else if (purchase.status == PurchaseStatus.canceled) {
          updateState(state.copyWith(isPurchasing: false, purchasingProductId: null));
        }
      }
    }
  }

  Future<void> _onAppResumed() async {
    if (state.isPurchasing) {
      // If native dialog closed without triggering status stream
      await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
      if (state.isPurchasing) {
        updateState(state.copyWith(isPurchasing: false, purchasingProductId: null));
      }
    }
  }
}
