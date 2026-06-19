import 'iap_service.dart';

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
      // If a purchase is not consumed, Google Play considers it owned by the user and will block
      // any future purchase attempts for the same product ID.
      if (Platform.isAndroid) {
        final androidAddition = _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        await androidAddition.consumePurchase(purchase);
        appLogger.i('IapService: Successfully consumed Android purchase ${purchase.purchaseID}');
      }
      
      // Both platforms require completing the purchase transaction (finishTransaction on iOS).
      // This tells the app store that the digital product has been successfully delivered to the user.
      // Failing to complete the purchase will result in the app store auto-refunding the user after a few days.
      await _iap.completePurchase(purchase);
      appLogger.i('IapService: Completed purchase transaction ${purchase.purchaseID}');
    } catch (e, stackTrace) {
      appLogger.e('IapService: Failed to complete purchase ${purchase.purchaseID}', error: e, stackTrace: stackTrace);
    }
  }
}
