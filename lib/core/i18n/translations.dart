

/// Extension to provide easy translation access on strings.
extension TranslationExtension on String {
  /// Translates the string key using the current locale.
  String get tr => Translations.translate(this);

  /// Supports argument replacement: "Hello %s" -> trArgs(["Listen"]) -> "Hello Listen"
  String trArgs(List<dynamic> args) {
    String translated = tr;
    for (var arg in args) {
      translated = translated.replaceFirst('%s', arg.toString());
    }
    return translated;
  }
}

/// Core translation engine.
/// This class is business-agnostic and relies on data registered at runtime.
class Translations {
  Translations._();

  static Map<String, Map<String, String>> _data = {};

  static String Function()? _languageCodeProvider;

  static void register({
    required Map<String, Map<String, String>> data,
    required String Function() languageCodeProvider, // 注入获取语言的方法
  }) {
    _data = data;
    _languageCodeProvider = languageCodeProvider;
  }

  static String translate(String key) {
    final languageCode = _languageCodeProvider?.call() ?? 'en';
    return _data[languageCode]?[key] ?? key;
  }
}
