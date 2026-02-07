/// Interface for states that support navigation.
/// Pure Dart - No dependencies.
abstract class BaseState<T> {
  T? get pendingNavigation;
}

/// Interface for ViewModels that support navigation consumption.
/// Pure Dart - No dependencies.
abstract class BaseViewModel {
  /// Should reset pendingNavigation state to null.
  void navigationConsumed();
}
