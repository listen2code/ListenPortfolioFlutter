import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

/// Concrete implementation for handling [LoadingEffect] using [CommonLoading].
class LoadingProviderImpl extends BaseProvider<LoadingEffect> {
  const LoadingProviderImpl();

  @override
  void handleEffect(LoadingEffect effect) {
    if (effect.type == LoadingType.page) return;

    if (effect.show) {
      CommonLoading.show(message: effect.message);
    } else {
      CommonLoading.hide();
    }
  }
}
