import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

enum AppLanguage {
  system("System", null),
  english('English', Locale('en')),
  chinese('中文', Locale('zh')),
  japanese('日本語', Locale('ja'));

  final String _label;
  final Locale? _locale;

  const AppLanguage(this._label, this._locale);

  /// Gets the actual locale. If [system] is selected, it maps the system language
  /// to supported languages (en, zh, ja), defaulting to [en].
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

/// Extension to allow "string".tr syntax like GetX
extension TranslationExtension on String {
  String get tr => Translations.translate(this);
}

class Translations {
  static final Map<String, Map<String, String>> _data = {
    AppLanguage.english.locale.languageCode: {
      I18nKeys.settings: 'Settings',
      I18nKeys.appearance: 'Appearance',
      I18nKeys.appearanceSubtitle: 'Theme, colors, and fonts',
      I18nKeys.language: 'Language',
      I18nKeys.general: 'General',
      I18nKeys.changePassword: 'Change Password',
      I18nKeys.changePasswordSubtitle: 'Update your account security',
      I18nKeys.notifications: 'Notifications',
      I18nKeys.systemStorage: 'System & Storage',
      I18nKeys.clearCache: 'Clear Cache',
      I18nKeys.cacheCleared: 'Cache cleared successfully!',
      I18nKeys.connect: 'Connect',
      I18nKeys.licenses: 'Open Source Licenses',
      I18nKeys.contactMe: 'Contact Me',
      I18nKeys.contactMeSubtitle: 'Send an email to author',
      I18nKeys.about: 'About',
      I18nKeys.appVersion: 'App Version',
      I18nKeys.themeMode: 'Theme Mode',
      I18nKeys.accentColor: 'Accent Color',
      I18nKeys.fontSize: 'Font Size',
      I18nKeys.system: 'System',
      I18nKeys.light: 'Light',
      I18nKeys.dark: 'Dark',
      I18nKeys.standard: 'Standard',
      I18nKeys.large: 'Large',
      I18nKeys.selectLanguage: 'Select Language',
      I18nKeys.switchEnv: 'Switch Environment',
      I18nKeys.envDev: 'Development',
      I18nKeys.envTest: 'Testing',
      I18nKeys.envProd: 'Production',
      I18nKeys.currentlyActive: 'Currently Active',
      I18nKeys.envSwitched: 'Environment switched to:',
      I18nKeys.noEmailApp: 'No email apps installed',
    },
    AppLanguage.chinese.locale.languageCode: {
      I18nKeys.settings: '设置',
      I18nKeys.appearance: '外观',
      I18nKeys.appearanceSubtitle: '主题、颜色和字体',
      I18nKeys.language: '语言',
      I18nKeys.general: '常规',
      I18nKeys.changePassword: '修改密码',
      I18nKeys.changePasswordSubtitle: '更新您的账号安全',
      I18nKeys.notifications: '通知',
      I18nKeys.systemStorage: '系统与存储',
      I18nKeys.clearCache: '清理缓存',
      I18nKeys.cacheCleared: '缓存清理成功！',
      I18nKeys.connect: '连接',
      I18nKeys.licenses: '开源许可',
      I18nKeys.contactMe: '联系我',
      I18nKeys.contactMeSubtitle: '给作者发送邮件',
      I18nKeys.about: '关于',
      I18nKeys.appVersion: '版本信息',
      I18nKeys.themeMode: '主题模式',
      I18nKeys.accentColor: '强调色',
      I18nKeys.fontSize: '字体大小',
      I18nKeys.system: '跟随系统',
      I18nKeys.light: '浅色模式',
      I18nKeys.dark: '深色模式',
      I18nKeys.standard: '标准',
      I18nKeys.large: '大号',
      I18nKeys.selectLanguage: '选择语言',
      I18nKeys.switchEnv: '切换环境',
      I18nKeys.envDev: '开发环境',
      I18nKeys.envTest: '测试环境',
      I18nKeys.envProd: '正式环境',
      I18nKeys.currentlyActive: '当前生效',
      I18nKeys.envSwitched: '环境已切换至：',
      I18nKeys.noEmailApp: '未安装邮件应用',
    },
    AppLanguage.japanese.locale.languageCode: {
      I18nKeys.settings: '設定',
      I18nKeys.appearance: '外観',
      I18nKeys.appearanceSubtitle: 'テーマ、カラー、フォント',
      I18nKeys.language: '言語',
      I18nKeys.general: '一般',
      I18nKeys.changePassword: 'パスワード変更',
      I18nKeys.changePasswordSubtitle: 'アカウントのセキュリティ更新',
      I18nKeys.notifications: '通知',
      I18nKeys.systemStorage: 'システムとストレージ',
      I18nKeys.clearCache: 'キャッシュ削除',
      I18nKeys.cacheCleared: 'キャッシュを削除しました！',
      I18nKeys.connect: '連携',
      I18nKeys.licenses: 'オープンソースライセンス',
      I18nKeys.contactMe: 'お問い合わせ',
      I18nKeys.contactMeSubtitle: '開発者にメールを送る',
      I18nKeys.about: '情報',
      I18nKeys.appVersion: 'アプリバージョン',
      I18nKeys.themeMode: 'テーマモード',
      I18nKeys.accentColor: 'アクセントカラー',
      I18nKeys.fontSize: 'フォントサイズ',
      I18nKeys.system: 'システム設定',
      I18nKeys.light: 'ライトモード',
      I18nKeys.dark: 'ダークモード',
      I18nKeys.standard: '標準',
      I18nKeys.large: '大',
      I18nKeys.selectLanguage: '言語選択',
      I18nKeys.switchEnv: '環境切替',
      I18nKeys.envDev: '開発用',
      I18nKeys.envTest: 'テスト用',
      I18nKeys.envProd: '本番用',
      I18nKeys.currentlyActive: '現在有効',
      I18nKeys.envSwitched: '環境を切り替えました：',
      I18nKeys.noEmailApp: 'メールアプリが見つかりません',
    },
  };

  static String translate(String key) {
    // 获取经过跟随系统逻辑处理后的实际 languageCode
    final languageCode = settingManager.locale.languageCode;
    return _data[languageCode]?[key] ?? key;
  }
}
