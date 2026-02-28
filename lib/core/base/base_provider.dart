import 'package:flutter/foundation.dart';
import 'package:listen_portfolio_flutter/core/base/base_effect.dart';

/// Interface for showing/hiding loading UI.
abstract class ILoadingProvider {
  void show({String? message});

  void hide();

  ValueListenable<bool> get isLoading;
}

/// Interface for showing messages/toasts.
abstract class IMessageProvider {
  /// Shows a message with a specific type (info or error).
  void show(String message, {MessageType type = MessageType.info});
}

/// Interface for navigation operations.
abstract class INavigationProvider {
  Future<T?>? to<T>(dynamic target, {bool needLogin = false, Object? arguments});

  Future<T?>? off<T>(dynamic target, {bool needLogin = false, Object? arguments});

  void back<T>([T? result]);
}
