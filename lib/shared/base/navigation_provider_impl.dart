import 'package:listen_portfolio_flutter/core/core.dart';

/// Concrete implementation for handling [NavigationEffect] using [AppNav].
class NavigationProviderImpl extends BaseProvider<NavigationEffect> {
  const NavigationProviderImpl();

  @override
  void handleEffect(NavigationEffect effect) {
    if (effect.isBack) {
      AppNav.back(effect.arguments);
    } else if (effect.isReplace) {
      AppNav.off(
        effect.target,
        needLogin: effect.needLogin,
        arguments: effect.arguments as Map<String, dynamic>?,
      );
    } else {
      AppNav.to(effect.target, needLogin: effect.needLogin, arguments: effect.arguments);
    }
  }
}
