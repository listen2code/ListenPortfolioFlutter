import 'package:listen_portfolio_flutter/core/core.dart';

/// Concrete implementation of [INavigationProvider] using the project's [AppNav] routing system.
class NavigationProviderImpl implements INavigationProvider {
  const NavigationProviderImpl();

  @override
  Future<T?>? to<T>(dynamic target, {bool needLogin = false, Object? arguments}) {
    return AppNav.to<T>(target, needLogin: needLogin, arguments: arguments);
  }

  @override
  Future<T?>? off<T>(dynamic target, {bool needLogin = false, Object? arguments}) {
    return AppNav.off<T>(target, needLogin: needLogin, arguments: arguments);
  }

  @override
  void back<T>([T? result]) {
    AppNav.back<T>(result);
  }
}
