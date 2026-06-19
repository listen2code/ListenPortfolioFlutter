import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

class CoffeePurchaseEffect extends BaseEffect {
  CoffeePurchaseEffect();
}

class CoffeePurchaseProviderImpl extends BaseProvider<CoffeePurchaseEffect> {
  const CoffeePurchaseProviderImpl();

  @override
  void handleEffect(CoffeePurchaseEffect effect) {
    final context = AppNavConfig.context;
    if (context != null) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(),
      );
    }
  }
}
