import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Interface for states that support navigation
abstract class NavigableState<T> {
  T? get pendingNavigation;
}

/// Mixin for ViewModels to handle navigation consumption automatically
mixin class NavigableViewModel {
  void navigationConsumed() {
    (this as dynamic).state = (this as dynamic).state.copyWith(pendingNavigation: null);
  }
}

/// Extension to automate navigation consumption in the View layer
extension MviNavigationListener on WidgetRef {
  void listenNavigation<S extends NavigableState<T>, T>(ProviderListenable<S> provider, void Function(T target) onNavigate) {
    listen<T?>(provider.select((state) => state.pendingNavigation), (previous, next) {
      if (next != null) {
        // 1. Execute navigation
        onNavigate(next);

        // 2. IMPORTANT: Consume the navigation state immediately
        // This allows the next trigger to be detected as a state change
        try {
          final notifier = read((provider as dynamic).notifier);
          if (notifier is NavigableViewModel) {
            notifier.navigationConsumed();
          }
        } catch (e) {
          // Silently fail if provider doesn't support notifier
        }
      }
    });
  }
}
