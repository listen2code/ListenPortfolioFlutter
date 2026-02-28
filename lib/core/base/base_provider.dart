import 'package:listen_portfolio_flutter/core/base/base_effect.dart';

/// A central registry for managing global provider implementations and effect routing.
class ProviderRegistry {
  ProviderRegistry._();

  static final Map<Type, BaseProvider<dynamic>> _effectRouteMap = {};

  /// Registers a list of global provider implementations.
  /// Automatically builds an effect-to-provider routing map based on [handledType].
  static void setup(List<BaseProvider<dynamic>> providers) {
    _effectRouteMap.clear();
    for (var provider in providers) {
      _effectRouteMap[provider.handledType] = provider;
    }
  }

  /// Dispatches an effect to its registered provider.
  /// Returns true if a handler was found and the effect was processed.
  static bool handle(BaseEffect effect) {
    final handler = _effectRouteMap[effect.runtimeType];

    if (handler != null) {
      handler.handle(effect);
      return true;
    }

    return false;
  }
}

/// Base interface for all architecture providers.
/// Establishes a type-safe 1-to-1 relationship between an effect [E] and its executor.
abstract class BaseProvider<E extends BaseEffect> {
  const BaseProvider();

  /// The specific [BaseEffect] type this provider is responsible for.
  Type get handledType => E;

  /// Polymorphic entry point to process an effect.
  /// Automatically casts the effect to its concrete type [E].
  void handle(BaseEffect effect) => handleEffect(effect as E);

  /// Concrete logic to process the specific effect [E].
  /// To be implemented by the shared layer providers.
  void handleEffect(E effect);
}
