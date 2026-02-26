/// Global configuration for UIKit components to avoid hardcoded strings
/// and support internationalization through injection.
class UIKitConfig {
  UIKitConfig._();

  // Internal keys for string resources
  static const String kOk = 'OK';
  static const String kCancel = 'Cancel';
  static const String kLoading = 'loading';

  /// A callback that provides translated strings based on a key.
  /// Typically, this is hooked into your app's i18n system.
  static String Function(String key)? _stringProvider;

  /// Default fallback strings.
  static final Map<String, String> _defaults = {kOk: 'OK', kCancel: 'Cancel', kLoading: 'Loading'};

  /// Initializes the UIKit configuration.
  /// [stringProvider] A function that takes a key and returns a translated string.
  static void setup({String Function(String key)? stringProvider}) {
    _stringProvider = stringProvider;
  }

  /// Retrieves a string for the given key.
  /// It tries the provider first, then falls back to defaults.
  static String getString(String key) {
    return _stringProvider?.call(key) ?? _defaults[key] ?? key;
  }
}
