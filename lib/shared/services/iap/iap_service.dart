import 'package:in_app_purchase/in_app_purchase.dart';

/// Abstract service defining the cross-platform In-App Purchase (IAP) contract.
///
/// Decouples the presentation and domain layers from the underlying store billing SDK
/// (Google Play Billing for Android and StoreKit for iOS).
///
/// ### Core Responsibilities:
/// 1. Hardware/Store capability detection: [initialize].
/// 2. SKU and catalog querying with localized pricing: [queryProducts].
/// 3. Consumable purchase initiation: [buyProduct].
/// 4. Asynchronous purchase lifecycle observation: [purchaseStream].
/// 5. Transaction finalization and Android consumable acknowledgement: [completePurchase].
abstract class IIapService {
  /// Initializes the In-App Purchase service and verifies store connectivity.
  ///
  /// Checks whether the underlying app store (Google Play or Apple App Store)
  /// is currently available and accessible on the host device.
  Future<void> initialize();

  /// Queries product metadata (pricing, localized title, currency, description)
  /// from the app store for a given set of registered product SKUs.
  ///
  /// [productIds] A set of unique store SKU strings (e.g. 'coffee1', 'coffee2').
  /// Returns a list of valid [ProductDetails] fetched from the store.
  Future<List<ProductDetails>> queryProducts(Set<String> productIds);

  /// Initiates an in-app consumable purchase flow for the specified [product].
  ///
  /// Triggers the native platform checkout bottom sheet/modal. Asynchronous
  /// results are dispatched via the global [purchaseStream].
  Future<void> buyProduct(ProductDetails product);

  /// Continuous stream broadcasting purchase status updates across platforms.
  ///
  /// Subscribers receive lists of [PurchaseDetails] representing purchases that are
  /// pending, purchased, canceled, or errored.
  Stream<List<PurchaseDetails>> get purchaseStream;

  /// Completes a purchase transaction and tells the app store that product delivery succeeded.
  ///
  /// For Android, this also explicitly calls `consumePurchase` to ensure the consumable
  /// item can be re-purchased in subsequent sessions without triggering `ITEM_ALREADY_OWNED`.
  /// On iOS, this finalizes the StoreKit transaction.
  Future<void> completePurchase(PurchaseDetails purchase);
}

/// Global service locator instance for In-App Purchases, initialized conditionally
/// during application bootstrapping (guarded against Web environments).
late IIapService iapService;
