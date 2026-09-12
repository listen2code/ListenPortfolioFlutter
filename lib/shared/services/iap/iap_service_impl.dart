import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:listen_core/core.dart';
import 'iap_service.dart';

/// Production implementation of [IIapService] utilizing the official `in_app_purchase` plugin.
///
/// Handles platform differences between Android (Google Play Billing client) and
/// iOS (StoreKit 1/2), with dedicated logic for consumable item consumption.
class IapServiceImpl implements IIapService {
  final InAppPurchase _iap = InAppPurchase.instance;

  @override
  Future<void> initialize() async {
    final available = await _iap.isAvailable();
    appLogger.i('IapService: Store availability check: $available');
  }

  @override
  Future<List<ProductDetails>> queryProducts(Set<String> productIds) async {
    try {
      final response = await _iap.queryProductDetails(productIds);
      if (response.notFoundIDs.isNotEmpty) {
        appLogger.w('IapService: Some product IDs were not found: ${response.notFoundIDs}');
      }
      return response.productDetails;
    } catch (e, stackTrace) {
      appLogger.e('IapService: Failed to query products', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> buyProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    try {
      await _iap.buyConsumable(purchaseParam: purchaseParam);
    } catch (e, stackTrace) {
      appLogger.e('IapService: Failed to buy consumable ${product.id}', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    try {
      // Android (Google Play) requires explicit consumption for consumable items (like buying coffee/tips).
      // If a purchase is not consumed via consumePurchase(), Google Play considers it owned by the user
      // and will block any future purchase attempts for the same product SKU with BillingResponseCode.ITEM_ALREADY_OWNED.
      if (Platform.isAndroid) {
        final androidAddition = _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        await androidAddition.consumePurchase(purchase);
        appLogger.i('IapService: Successfully consumed Android purchase ${purchase.purchaseID}');
      }
      
      // Both platforms require completing the purchase transaction (finishTransaction on iOS,
      // acknowledgePurchase on Android). This confirms to the billing server that the digital asset
      // was safely delivered. If omitted, Google Play and Apple will auto-refund the charge after a grace period.
      await _iap.completePurchase(purchase);
      appLogger.i('IapService: Completed purchase transaction ${purchase.purchaseID}');
    } catch (e, stackTrace) {
      appLogger.e('IapService: Failed to complete purchase ${purchase.purchaseID}', error: e, stackTrace: stackTrace);
    }
  }
}
