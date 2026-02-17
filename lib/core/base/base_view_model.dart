import 'dart:async';

import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/utils/logger.dart';

/// Key used to store the CancelToken in the current Zone.
const Symbol kCancelTokenKey = Symbol('dio_cancel_token');

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

  // Lifecycle hooks
  void onInit() {}

  void onReady() {}

  void onVisible() {}

  void onInVisible() {}

  void onDispose() {}
}

/// Mixin to handle common UI states, lifecycle logging, and automatic request cancellation.
mixin ConsumeViewModel<S extends BaseState<dynamic>> implements BaseViewModel {
  /// Token to cancel network requests when this ViewModel is disposed.
  final CancelToken _cancelToken = CancelToken();

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

  @override
  void onInit() {
    appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onInit');
  }

  @override
  void onReady() {
    appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onReady');
  }

  @override
  void onVisible() {
    appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onVisible');
  }

  @override
  void onInVisible() {
    appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onInVisible');
  }

  @override
  void onDispose() {
    appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onDispose (Cancelling requests)');

    // Cancel all pending requests associated with this ViewModel
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel('${runtimeType.toString()} disposed');
    }
  }

  /// Dispatcher for UI intents.
  /// Uses runZoned to propagate the CancelToken down to the network layer automatically.
  FutureOr<void> dispatch(dynamic intent, FutureOr<void> Function() handler) {
    final tag = runtimeType.toString();
    appLogger.d('$tag: [INTENT] -> $intent');

    // Run the handler in a zone that carries our cancel token
    return runZoned(() {
      final result = handler();

      if (result is Future) {
        return result.then((_) {
          final dynamic self = this;
          appLogger.d('$tag: [STATE] (Async) <- ${self.state}');
        });
      }

      final dynamic self = this;
      appLogger.d('$tag: [STATE] <- ${self.state}');
      return result;
    }, zoneValues: {kCancelTokenKey: _cancelToken});
  }
}
