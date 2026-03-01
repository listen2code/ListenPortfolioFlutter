import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

/// Interface for states. Should only contain persistent UI data.
abstract class BaseState<T> {}

/// Interface for any object that maintains a reactive state.
abstract class IStateOwner<S> {
  S get state;
}

/// Base interface for all ViewModels.
abstract class BaseViewModel {
  // Lifecycle hooks
  void onInit() {}

  void onReady() {}

  /// Called when the page becomes visible in the navigation stack.
  void onVisible() {}

  /// Called when the page becomes invisible in the navigation stack.
  void onInVisible() {}

  /// Called when the App transitions from background to foreground.
  void onResume() {}

  /// Called when the App transitions from foreground to background.
  void onPause() {}

  void onInactive() {}

  void onDispose() {}

  // Cancellation support
  CancelToken get cancelToken;

  void cancelRequests(String reason);

  /// Reactive stream for one-time UI effects.
  Stream<BaseEffect> get effectStream;

  void emitEffect(BaseEffect effect);

  /// Handles standard UI effects (Loading, Message, Navigation).
  /// Returns true if the effect was handled.
  bool handleEffect(BaseEffect effect);
}

/// Mixin to handle common UI states, lifecycle logging, and side effects.
mixin ViewModelMixin<S extends BaseState<dynamic>> implements BaseViewModel, IStateOwner<S> {
  @override
  S get state;

  final _effectController = StreamController<BaseEffect>.broadcast();
  CancelToken _cancelToken = CancelToken();

  @override
  Stream<BaseEffect> get effectStream => _effectController.stream;

  @override
  void emitEffect(BaseEffect effect) {
    appLogger.d('${runtimeType.toString()}: [EFFECT] -> ${effect.toString()}');
    _effectController.add(effect);
  }

  @override
  bool handleEffect(BaseEffect effect) {
    return ProviderRegistry.handle(effect);
  }

  /// Helper to handle Either results from UseCases/Repositories.
  /// Automatically calls UI effects on Left, and executes [onSuccess] on Right.
  /// Returns the result of [onSuccess] or null if failure.
  FutureOr<void> handleResult<T>(Either<Failure, T> result, FutureOr<void> Function(T data) onSuccess) async {
    await result.fold((failure) async {
      if (failure is AuthFailure) {
        // Trigger global logout effect for auth expiration
        emitEffect(LogoutEffect(message: failure.message));
      } else if (failure is ServerApiFailure) {
        // Global API Business Error: show as a dialog
        emitEffect(MessageEffect.dialog(failure.message, title: "API Error"));
      } else {
        // Default fallback for other failure types (Network, Validation etc.)
        emitEffect(MessageEffect.error(failure.message));
      }
    }, (data) async => await onSuccess(data));
  }

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
  void onInit() => appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onInit');

  @override
  void onReady() => appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onReady');

  @override
  void onVisible() => appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onVisible');

  @override
  void onInVisible() => appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onInVisible');

  @override
  void onResume() => appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onResume');

  @override
  void onPause() => appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onPause');

  @override
  void onInactive() => appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onInactive');

  @override
  void onDispose() {
    appLogger.i('${runtimeType.toString()}: [LIFECYCLE] -> onDispose');
    cancelRequests('${runtimeType.toString()} disposed');
    _effectController.close();
  }

  /// Dispatcher for UI intents.
  Future<void> dispatch(dynamic intent, FutureOr<void> Function() handler, {bool showLoading = false}) {
    return ZoneManager.run(() {
      final tag = runtimeType.toString();
      appLogger.d('$tag: [INTENT] -> $intent');
      ZoneManager.mark('Intent [$intent] Started');

      if (showLoading) emitEffect(LoadingEffect(true));

      try {
        final result = handler();

        void onComplete() {
          if (showLoading) emitEffect(LoadingEffect(false));
          appLogger.d('$tag: [STATE] <- $state');

          // INJECTED CRASH CHECK: Moved inside the Zone to ensure the Trace ID is correctly associated.
          CrashManager.checkAndTriggerInjectedCrash();
          ZoneManager.mark('Intent Finished');
        }

        if (result is Future) {
          return result.then(
            (_) => onComplete(),
            onError: (e, s) {
              if (showLoading) emitEffect(LoadingEffect(false));
              throw e;
            },
          );
        } else {
          onComplete();
          return Future.value();
        }
      } catch (e) {
        if (showLoading) emitEffect(LoadingEffect(false));
        rethrow;
      }
    }, cancelToken: cancelToken);
  }
}
