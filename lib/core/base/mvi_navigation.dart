/// Interface for states that support navigation.
/// Pure Dart - No dependencies.
abstract class NavigableState<T> {
  T? get pendingNavigation;
}

/// Interface for ViewModels that support navigation consumption.
/// Pure Dart - No dependencies.
abstract class NavigableViewModel {
  /// Should reset pendingNavigation state to null.
  void navigationConsumed();
}
