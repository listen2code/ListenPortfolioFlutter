import 'package:listen_portfolio_flutter/core/base/base_provider.dart';

/// Global configuration for core architecture components.
/// Stores a list of global provider implementations and retrieves them by type.
class BaseConfig {
  BaseConfig._();

  static final List<IBaseProvider> _globalProviders = [];

  /// Registers a list of global provider implementations.
  /// Typically called in main.dart during app initialization.
  static void setup(List<IBaseProvider> providers) {
    _globalProviders.clear();
    _globalProviders.addAll(providers);
  }

  /// Retrieves a global provider implementation that matches type [T].
  static T? getProvider<T extends IBaseProvider>() {
    for (var provider in _globalProviders) {
      if (provider is T) return provider;
    }
    return null;
  }
}
