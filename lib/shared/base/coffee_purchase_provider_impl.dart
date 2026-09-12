import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';
import '../../features/settings/presentation/pages/widgets/coffee_purchase_bottom_sheet.dart';

/// Effect dispatched when a user triggers the "Buy me a coffee" action.
///
/// Decouples the triggering ViewModel (e.g., `SettingsViewModel`) from modal UI presentation,
/// ensuring zero direct dependencies on Flutter UI widgets within ViewModel code.
class CoffeePurchaseEffect extends BaseEffect {
  CoffeePurchaseEffect();
}

/// Global [BaseProvider] implementation that listens for [CoffeePurchaseEffect].
///
/// Intercepts the effect and uses the top-level navigation context from [AppNavConfig.context]
/// to present the [CoffeePurchaseBottomSheet] as a modal bottom sheet.
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
