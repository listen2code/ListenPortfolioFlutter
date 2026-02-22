import 'dart:async';

import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/utils/logger.dart';
import 'package:listen_portfolio_flutter/core/utils/zone_manager.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_loading.dart';

/// Interface for states that support navigation, error, and general messaging.
abstract class BaseState<T> {
  T? get pendingNavigation;

  String? get errorMessage;

  String? get message;
}

/// Base interface for all ViewModels.
abstract class BaseViewModel {
  void navigationConsumed();

  void errorConsumed();

  void messageConsumed();

  // Lifecycle hooks
  void onInit() {}

  void onReady() {}

  void onVisible() {}

  void onInVisible() {}

  void onDispose() {}

  // Cancellation support
  CancelToken get cancelToken;

  void cancelRequests(String reason);
}

/// Mixin to handle common UI states, lifecycle logging, automatic request cancellation, and global loading.
mixin ConsumeViewModel<S extends BaseState<dynamic>> implements BaseViewModel {
  /// Token to cancel network requests. Will be re-created if the previous one was cancelled.
  CancelToken _cancelToken = CancelToken();

  @override
  CancelToken get cancelToken {
    if (_cancelToken.isCancelled) {
      _cancelToken = CancelToken();
    }
    return _cancelToken;
  }

  @override
  void cancelRequests(String reason) {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel(reason);
    }
  }

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
    appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onDispose');
    cancelRequests('${runtimeType.toString()} disposed');
  }

  /// Dispatcher for UI intents.
  /// [showLoading] Automatically shows/hides CommonLoading during the action.
  FutureOr<void> dispatch(dynamic intent, FutureOr<void> Function() handler, {bool showLoading = false}) {
    // We use ZoneManager to inject both Trace ID and CancelToken into the execution context.
    return ZoneManager.run(() {
      final tag = runtimeType.toString();
      appLogger.d('$tag: [INTENT] -> $intent');
      ZoneManager.mark('Intent [$intent] Started');

      if (showLoading) CommonLoading.show();

      try {
        final result = handler();

        if (result is Future) {
          return result.whenComplete(() {
            if (showLoading) CommonLoading.hide();
            final dynamic self = this;
            appLogger.d('$tag: [STATE] (Async) <- ${self.state}');
            ZoneManager.mark('Intent Async Finished');
          });
        }

        if (showLoading) CommonLoading.hide();
        final dynamic self = this;
        appLogger.d('$tag: [STATE] <- ${self.state}');
        ZoneManager.mark('Intent Sync Finished');
        return result;
      } catch (e) {
        if (showLoading) CommonLoading.hide();
        rethrow;
      }
    }, cancelToken: cancelToken);
  }
}
