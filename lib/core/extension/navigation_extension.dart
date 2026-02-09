import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/base_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Mixin to handle navigation state consumption.
/// Removed 'on Notifier<S>' constraint to support both Notifier and AutoDisposeNotifier.
mixin ConsumeNavigableViewModel<S extends BaseState<dynamic>> implements BaseViewModel {
  @override
  void navigationConsumed() {
    // Using dynamic to access 'state' property and 'copyWith' method
    // which are guaranteed to exist on a Riverpod Notifier with a Freezed state.
    final dynamic self = this;
    self.state = self.state.copyWith(pendingNavigation: null);
  }
}

extension NavigationExtension on WidgetRef {
  void listenNavigation<S extends BaseState<T>, T>(ProviderListenable<S> provider, void Function(T target) onNavigate) {
    listen<T?>(provider.select((state) => state.pendingNavigation), (previous, next) {
      if (next != null) {
        // 1. Execute the actual navigation in the View
        onNavigate(next);

        // 2. Automatically tell the ViewModel to reset the state
        try {
          final notifier = read((provider as dynamic).notifier);
          if (notifier is BaseViewModel) {
            notifier.navigationConsumed();
          }
        } catch (e) {
          // Silently fail if the provider doesn't have a notifier
        }
      }
    });
  }
}
