import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/base_view_model.dart';
import 'package:listen_portfolio_flutter/shared/utils/snack_bar_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

extension BaseRefExtension on WidgetRef {
  /// Listens to navigation targets and automatically resets the state after navigation.
  void listenNavigation<S extends BaseState<T>, T>(
    ProviderListenable<S> provider,
    void Function(T target) onNavigate,
  ) {
    listen<T?>(provider.select((state) => state.pendingNavigation), (previous, next) {
      if (next != null) {
        onNavigate(next);
        _getViewModel(provider)?.navigationConsumed();
      }
    });
  }

  /// Listens to error messages and automatically shows a SnackBar and resets the state.
  void listenError<S extends BaseState<dynamic>>(ProviderListenable<S> provider) {
    listen<String?>(provider.select((state) => state.errorMessage), (previous, next) {
      if (next != null && next.isNotEmpty) {
        SnackBarUtil.show(next, isError: true);
        _getViewModel(provider)?.errorConsumed();
      }
    });
  }

  /// Listens to error messages and automatically shows a SnackBar and resets the state.
  void listenMessage<S extends BaseState<dynamic>>(ProviderListenable<S> provider) {
    listen<String?>(provider.select((state) => state.message), (previous, next) {
      if (next != null && next.isNotEmpty) {
        SnackBarUtil.show(next, isError: false);
        _getViewModel(provider)?.messageConsumed();
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
