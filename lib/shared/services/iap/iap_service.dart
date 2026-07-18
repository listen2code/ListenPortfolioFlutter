import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IIapService {
  /// Initializes the In-App Purchase service, e.g. listening to streams or connection.
  Future<void> initialize();

  /// Queries the products from Apple Store/Google Play based on product IDs.
  Future<List<ProductDetails>> queryProducts(Set<String> productIds);

  /// Initiates a consumable purchase for a product.
  Future<void> buyProduct(ProductDetails product);

  /// Stream of purchase status updates.
  Stream<List<PurchaseDetails>> get purchaseStream;

  /// Completes a purchase transaction (and consumes it if necessary).
  Future<void> completePurchase(PurchaseDetails purchase);
}

/// Global instance of IapService, initialized at application start.
late IIapService iapService;
