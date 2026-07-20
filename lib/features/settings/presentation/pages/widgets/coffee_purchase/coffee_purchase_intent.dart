import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_registry_init.dart';

part 'coffee_purchase_intent.freezed.dart';

@freezed
class CoffeePurchaseIntent extends BaseIntent with _$CoffeePurchaseIntent {
  const factory CoffeePurchaseIntent.init() = _Init;
  const factory CoffeePurchaseIntent.buyProduct(String productId) = _BuyProduct;
  const factory CoffeePurchaseIntent.purchaseUpdated(List<PurchaseDetails> purchases) = _PurchaseUpdated;
  const factory CoffeePurchaseIntent.appResumed() = _AppResumed;

  const CoffeePurchaseIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('CoffeePurchaseIntent', 'init', (args) => const CoffeePurchaseIntent.init());
    MviPlaybackRegistry.register('CoffeePurchaseIntent', 'buyProduct', (args) {
      final productId = args['productId'] ?? '';
      return CoffeePurchaseIntent.buyProduct(productId);
    });
    MviPlaybackRegistry.register('CoffeePurchaseIntent', 'purchaseUpdated', (args) {
      // In playback mode, background updates are usually simulated or mocked in tests,
      // so we return an empty purchase list deserializer as a fallback.
      return const CoffeePurchaseIntent.purchaseUpdated([]);
    });
    MviPlaybackRegistry.register('CoffeePurchaseIntent', 'appResumed', (args) => const CoffeePurchaseIntent.appResumed());
  }
}
