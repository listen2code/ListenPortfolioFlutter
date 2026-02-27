import 'package:flutter/foundation.dart';

/// Interface for showing/hiding loading UI.
abstract class ILoadingProvider {
  void show({String? message});
  void hide();
  ValueListenable<bool> get isLoading;
}

/// Interface for showing messages/toasts.
abstract class IMessageProvider {
  void showInfo(String message);
  void showError(String message);
}

/// Interface for navigation operations.
abstract class INavigationProvider {
  Future<T?>? to<T>(dynamic target, {bool needLogin = false, Object? arguments});
  Future<T?>? off<T>(dynamic target, {bool needLogin = false, Object? arguments});
  void back<T>([T? result]);
}
