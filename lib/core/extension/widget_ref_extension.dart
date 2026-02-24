import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/base_view_model.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

extension WidgetRefX on WidgetRef {
  /// Listens to navigation targets and automatically resets the state after navigation.
  void listenNavigation<S extends BaseState<T>, T>(
    ProviderListenable<S> provider,
    void Function(T target) onNavigate,
  ) {
    listen<T?>(provider.select((state) => state.pendingNavigation), (previous, next) {
      if (next != null) {
        onNavigate(next);

        // Delay state reset to the next microtask.
        // This ensures that the current state can be fully captured by other listeners
        // or logging mechanisms (like the dispatch logger) before being cleared.
        Future.microtask(() => _getViewModel(provider)?.navigationConsumed());
      }
    });
  }

  /// Listens to error messages and automatically shows a SnackBar and resets the state.
  void listenError<S extends BaseState<dynamic>>(ProviderListenable<S> provider) {
    listen<String?>(provider.select((state) => state.errorMessage), (previous, next) {
      if (next != null && next.isNotEmpty) {
        CommonToast.show(next, type: ToastType.error);

        // Delay consumption to allow the logging aspect to record the error state.
        Future.microtask(() => _getViewModel(provider)?.errorConsumed());
      }
    });
  }

  /// Listens to info messages and automatically shows a SnackBar and resets the state.
  void listenMessage<S extends BaseState<dynamic>>(ProviderListenable<S> provider) {
    listen<String?>(provider.select((state) => state.message), (previous, next) {
      if (next != null && next.isNotEmpty) {
        CommonToast.show(next);

        // Push state reset to next microtask to avoid interference with synchronous logs.
        Future.microtask(() => _getViewModel(provider)?.messageConsumed());
      }
    });
  }

  /// Internal helper to retrieve the ViewModel from a provider.
  BaseViewModel? _getViewModel(ProviderListenable<dynamic> provider) {
    try {
      final notifier = read((provider as dynamic).notifier);
      if (notifier is BaseViewModel) return notifier;
    } catch (_) {}
    return null;
  }
}
