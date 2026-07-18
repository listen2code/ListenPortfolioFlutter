import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:listen_core/core.dart';

part 'coffee_purchase_state.freezed.dart';

@freezed
abstract class CoffeePurchaseState extends BaseState with _$CoffeePurchaseState {
  const factory CoffeePurchaseState({
    @Default(true) bool isLoading,
    @Default([]) List<ProductDetails> products,
    @Default(false) bool isPurchasing,
    String? purchasingProductId,
  }) = _CoffeePurchaseState;

  const CoffeePurchaseState._();
}
