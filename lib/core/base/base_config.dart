import 'package:listen_portfolio_flutter/core/core.dart';

/// Global configuration for core architecture components.
/// This allows registering project-wide implementations for providers
/// like Loading, Messaging, and Navigation.
class BaseConfig {
  BaseConfig._();

  static ILoadingProvider? loadingProvider;
  static IMessageProvider? messageProvider;
  static INavigationProvider? navigationProvider;

  /// Initializes the core framework with specific implementations.
  /// Typically called in main.dart.
  static void setup({
    ILoadingProvider? loadingProvider,
    IMessageProvider? messageProvider,
    INavigationProvider? navigationProvider,
  }) {
    if (loadingProvider != null) BaseConfig.loadingProvider = loadingProvider;
    if (messageProvider != null) BaseConfig.messageProvider = messageProvider;
    if (navigationProvider != null) BaseConfig.navigationProvider = navigationProvider;
  }
}
