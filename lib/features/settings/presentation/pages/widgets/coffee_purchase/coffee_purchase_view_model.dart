import 'dart:async';

import 'package:collection/collection.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../shared/shared.dart';
import 'coffee_purchase_intent.dart';
import 'coffee_purchase_state.dart';

part 'coffee_purchase_view_model.g.dart';

/// ViewModel managing the In-App Purchase "Buy me a coffee" modal state machine.
///
/// ### Architecture & Responsibilities:
/// - Follows the MVI pattern via [ViewModelMixin].
/// - Subscribes to [IIapService.purchaseStream] on initialization and manages stream cleanup on dispose.
/// - Sorts available coffee product tiers in ascending order of raw price.
/// - Handles native purchase states ([PurchaseStatus.purchased], [PurchaseStatus.error], [PurchaseStatus.canceled]).
/// - Safely completes/consumes purchased items and triggers the golden-moment review prompt via [RateAppEffect].
/// - Incorporates an app lifecycle resumed watchdog timer (1000ms delay) to recover loading state if the
///   native billing sheet was dismissed without dispatching a cancel status.
@riverpod
class CoffeePurchaseViewModel extends _$CoffeePurchaseViewModel
    with ViewModelMixin<CoffeePurchaseState, CoffeePurchaseIntent> {
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  CoffeePurchaseState build() => const CoffeePurchaseState();

  @override
  void onInit() {
    super.onInit();
    // Subscribe to continuous purchase updates from store SDK
    _subscription = iapService.purchaseStream.listen(
      (purchases) => handleIntent(CoffeePurchaseIntent.purchaseUpdated(purchases)),
      onError: (Object err) {
        appLogger.e('CoffeePurchaseViewModel: Purchase stream error: $err');
      },
    );
    // Fetch available SKUs and pricing metadata
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

  /// Queries the store for coffee products and sorts them by price.
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

  /// Initiates a consumable purchase for the selected product tier.
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

  /// Processes transaction updates from Google Play / StoreKit purchase stream.
  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (AppConstants.coffeeProductIds.contains(purchase.productID)) {
        if (purchase.status == PurchaseStatus.purchased) {
          // Finalize and consume the purchase to allow repeated tipping
          await iapService.completePurchase(purchase);
          updateState(state.copyWith(isPurchasing: false, purchasingProductId: null));
          emitEffect(MessageEffect.info(I18nKeys.buyCoffeeSuccess.tr));
          // Golden Moment: Trigger in-app review prompt right after successful tipping
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

  /// Watchdog handler for app lifecycle resume events.
  ///
  /// On certain Android OEM devices (e.g. MIUI, EMUI), when the user taps outside or presses
  /// the system back button to cancel the native billing sheet, the billing client may close
  /// without dispatching a `PurchaseStatus.canceled` event into the purchase stream.
  /// Adding a 1000ms delay gives the purchase stream a final delivery window. If still in
  /// `isPurchasing` state, it gracefully resets the loading spinner to prevent UI freezing.
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
