import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

import 'languages/en.dart';
import 'languages/ja.dart';
import 'languages/zh.dart';

enum AppLanguage {
  system("System", null),
  english('English', Locale('en')),
  chinese('中文', Locale('zh')),
  japanese('日本語', Locale('ja'));

  final String _label;
  final Locale? _locale;

  const AppLanguage(this._label, this._locale);

  Locale get locale {
    if (this == AppLanguage.system) {
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final languageCode = systemLocale.languageCode;

      if (languageCode == 'zh') return const Locale('zh');
      if (languageCode == 'ja') return const Locale('ja');
      return const Locale('en');
    }
    return _locale!;
  }

  String get label {
    if (this == AppLanguage.system) {
      return I18nKeys.system.tr;
    }
    return _label;
  }

  static AppLanguage fromLabel(String? label) {
    return AppLanguage.values.firstWhere((e) => e.label == label, orElse: () => AppLanguage.system);
  }
}

extension TranslationExtension on String {
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

class Translations {
  static final Map<String, Map<String, String>> _data = {
    AppLanguage.english.locale.languageCode: en,
    AppLanguage.chinese.locale.languageCode: zh,
    AppLanguage.japanese.locale.languageCode: ja,
  };

  static String translate(String key) {
    final languageCode = settingManager.locale.languageCode;
    return _data[languageCode]?[key] ?? key;
  }
}
