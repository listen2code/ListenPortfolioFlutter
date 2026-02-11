/// Interface for states that support navigation, error, and general messaging.
/// Pure Dart - No dependencies.
abstract class BaseState<T> {
  /// Target for pending navigation actions.
  T? get pendingNavigation;

  /// Global error message to be displayed.
  String? get errorMessage;

  /// Global general message (success/info) to be displayed.
  String? get message;
}

/// Interface for ViewModels that support consumption of UI states.
/// Pure Dart - No dependencies.
abstract class BaseViewModel {
  /// Resets the [BaseState.pendingNavigation] state to null.
  void navigationConsumed();

  /// Resets the [BaseState.errorMessage] state to null.
  void errorConsumed();

  /// Resets the [BaseState.message] state to null.
  void messageConsumed();
}

/// Mixin to handle navigation and error state consumption.
mixin ConsumeViewModel<S extends BaseState<dynamic>> implements BaseViewModel {
  @override
  void navigationConsumed() {
    final dynamic self = this;
    self.state = self.state.copyWith(pendingNavigation: null);
  }

  @override
  void errorConsumed() {
    final dynamic self = this;
    self.state = self.state.copyWith(errorMessage: null);
  }

  @override
  void messageConsumed() {
    final dynamic self = this;
    self.state = self.state.copyWith(message: null);
  }
}
