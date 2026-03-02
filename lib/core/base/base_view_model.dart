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
  void onInit();

  void onReady();

  void onVisible();

  void onInVisible();

  void onResume();

  void onPause();

  void onInactive();

  void onDispose();

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

  CancelToken get cancelToken {
    if (_cancelToken.isCancelled) {
      _cancelToken = CancelToken();
    }
    return _cancelToken;
  }

  @override
  void emitEffect(BaseEffect effect) {
    appLogger.d('${runtimeType.toString()}: [EFFECT] -> ${effect.toString()}');
    _effectController.add(effect);
  }

  @override
  bool handleEffect(BaseEffect effect) {
    return ProviderRegistry.handle(effect);
  }

  /// Executes a single action and handles result/loading.
  /// [onSuccess] is a positional parameter.
  /// If [onFailure] is provided, it handles the error; otherwise, [_handleFailure] is used.
  Future<void> call<T>(
    Future<Either<Failure, T>> action, {
    required FutureOr<void> Function(T data) onSuccess,
    FutureOr<void> Function(Failure failure)? onFailure,
    bool showLoading = false,
    String? loadingMessage,
  }) async {
    if (showLoading) emitEffect(LoadingEffect(true, message: loadingMessage));
    try {
      final result = await action;
      await handleResult(result, onSuccess, onFailure: onFailure);
    } finally {
      if (showLoading) emitEffect(LoadingEffect(false));
    }
  }

  /// Executes multiple actions concurrently.
  /// If any action fails, the first encountered failure is processed.
  /// If [onFailure] is provided, it handles the error; otherwise, [_handleFailure] is used.
  Future<void> callAll(
    List<Future<Either<Failure, dynamic>>> actions, {
    required FutureOr<void> Function(List<dynamic> results) onSuccess,
    FutureOr<void> Function(Failure failure)? onFailure,
    bool showLoading = false,
    String? loadingMessage,
  }) async {
    if (showLoading) emitEffect(LoadingEffect(true, message: loadingMessage));
    try {
      final results = await Future.wait(actions);

      Failure? firstFailure;
      for (final r in results) {
        r.fold((f) => firstFailure ??= f, (_) {});
      }

      if (firstFailure != null) {
        if (onFailure != null) {
          await onFailure(firstFailure!);
        } else {
          _handleFailure(firstFailure!);
        }
      } else {
        final dataList = results.map((r) => r.getOrElse((_) => throw Exception())).toList();
        await onSuccess(dataList);
      }
    } finally {
      if (showLoading) emitEffect(LoadingEffect(false));
    }
  }

  /// Common failure handler to convert domain Failures into UI Effects.
  void _handleFailure(Failure failure) {
    if (failure is AuthFailure) {
      emitEffect(LogoutEffect(message: failure.message));
    } else if (failure is ServerApiFailure) {
      emitEffect(MessageEffect.dialog(failure.message, title: "API Error"));
    } else {
      emitEffect(MessageEffect.error(failure.message));
    }
  }

  /// Helper to handle Either results.
  /// If [onFailure] is provided, it handles the error; otherwise, [_handleFailure] is used.
  FutureOr<void> handleResult<T>(
    Either<Failure, T> result,
    FutureOr<void> Function(T data) onSuccess, {
    FutureOr<void> Function(Failure failure)? onFailure,
  }) async {
    await result.fold((failure) async {
      if (onFailure != null) {
        await onFailure(failure);
      } else {
        _handleFailure(failure);
      }
    }, (data) async => await onSuccess(data));
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
