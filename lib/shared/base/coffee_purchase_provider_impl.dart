import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';
import '../../features/settings/presentation/pages/widgets/coffee_purchase_bottom_sheet.dart';

class CoffeePurchaseEffect extends BaseEffect {
  CoffeePurchaseEffect();
}

class CoffeePurchaseProviderImpl extends BaseProvider<CoffeePurchaseEffect> {
  const CoffeePurchaseProviderImpl();

  @override
  void handleEffect(CoffeePurchaseEffect effect) {
    final context = AppNavConfig.context;
    if (context != null) {
      CommonBottomSheet.show<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const CoffeePurchaseBottomSheet(),
      );
    }
  }
}
