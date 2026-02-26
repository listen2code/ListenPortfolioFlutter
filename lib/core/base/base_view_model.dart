import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:listen_portfolio_flutter/core/utils/crash_manager.dart';
import 'package:listen_portfolio_flutter/core/utils/logger.dart';
import 'package:listen_portfolio_flutter/core/utils/zone_manager.dart';

/// Interface for showing/hiding loading UI.
/// This allows core to stay independent of specific UI implementations.
abstract class ILoadingProvider {
  void show({String? message});

  void hide();

  /// Reactive state to indicate if loading is currently active.
  ValueListenable<bool> get isLoading;
}

/// Interface for showing messages/toasts.
/// This allows core to stay independent of specific UI implementations.
abstract class IMessageProvider {
  void showInfo(String message);

  void showError(String message);
}

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

  /// Optional loading provider for dispatch actions.
  ILoadingProvider? get loadingProvider;

  set loadingProvider(ILoadingProvider? value);

  /// Optional message provider for showing alerts/toasts.
  IMessageProvider? get messageProvider;

  set messageProvider(IMessageProvider? value);
}

/// Mixin to handle common UI states, lifecycle logging, automatic request cancellation, and global loading.
mixin ConsumeViewModel<S extends BaseState<dynamic>> implements BaseViewModel {
  /// Token to cancel network requests. Will be re-created if the previous one was cancelled.
  CancelToken _cancelToken = CancelToken();

  @override
  CancelToken get cancelToken {
    // If the current token is already cancelled, we must create a new one.
    // Otherwise, all subsequent network requests using this token will fail immediately.
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

  ILoadingProvider? _loadingProvider;

  @override
  ILoadingProvider? get loadingProvider => _loadingProvider;

  @override
  set loadingProvider(ILoadingProvider? value) => _loadingProvider = value;

  IMessageProvider? _messageProvider;

  @override
  IMessageProvider? get messageProvider => _messageProvider;

  @override
  set messageProvider(IMessageProvider? value) => _messageProvider = value;

  /// Dispatcher for UI intents.
  /// [showLoading] Automatically shows/hides CommonLoading during the action.
  Future<void> dispatch(dynamic intent, FutureOr<void> Function() handler, {bool showLoading = false}) {
    // We use ZoneManager to inject both Trace ID and CancelToken into the execution context.
    return ZoneManager.run(() {
      final tag = runtimeType.toString();
      appLogger.d('$tag: [INTENT] -> $intent');
      ZoneManager.mark('Intent [$intent] Started');

      if (showLoading) loadingProvider?.show();

      try {
        final result = handler();

        void onComplete() {
          if (showLoading) loadingProvider?.hide();
          final dynamic self = this;
          // Log state immediately. For sync handlers, this runs before microtask cleanup.
          appLogger.d('$tag: [STATE] <- ${self.state}');

          // INJECTED CRASH CHECK: Moved inside the Zone to ensure the Trace ID is correctly associated.
          CrashManager.checkAndTriggerInjectedCrash();

          ZoneManager.mark('Intent Finished');
        }

        if (result is Future) {
          return result.then(
            (_) => onComplete(),
            onError: (e, s) {
              if (showLoading) loadingProvider?.hide();
              throw e;
            },
          );
        } else {
          onComplete();
          return Future.value();
        }
      } catch (e) {
        if (showLoading) loadingProvider?.hide();
        rethrow;
      }
    }, cancelToken: cancelToken);
  }
}
