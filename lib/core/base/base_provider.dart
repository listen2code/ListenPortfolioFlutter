import 'package:listen_portfolio_flutter/core/base/base_effect.dart';

/// Base marker for all architecture providers.
abstract class IBaseProvider {}

/// Interface for showing/hiding loading UI.
abstract class ILoadingProvider implements IBaseProvider {
  void show({String? message});

  void hide();
}

/// Interface for showing messages/toasts.
abstract class IMessageProvider implements IBaseProvider {
  void show(String message, {MessageType type = MessageType.info});
}

/// Interface for navigation operations.
abstract class INavigationProvider implements IBaseProvider {
  Future<T?>? to<T>(dynamic target, {bool needLogin = false, Object? arguments});

  Future<T?>? off<T>(dynamic target, {bool needLogin = false, Object? arguments});

  void back<T>([T? result]);
}
