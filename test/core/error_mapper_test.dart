import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/shared/i18n/languages/ja.dart';
import 'package:listen_portfolio_flutter/shared/i18n/languages/zh.dart';
import 'package:listen_portfolio_flutter/shared/i18n/translations_key.dart';

void main() {
  late String currentLocale;

  setUpAll(() {
    Translations.register(
      data: {
        'zh': zh,
        'ja': ja,
      },
      languageCodeProvider: () => currentLocale,
    );
  });

  group('ErrorMapper Tests', () {
    test('Should translate ServerApiFailure messageId to Chinese', () {
      currentLocale = 'zh';
      final failure = const ServerApiFailure('Original Message', messageId: 'NET_0001');
      final mapped = ErrorMapper.map(failure);

      expect(mapped, isA<ServerApiFailure>());
      expect((mapped as ServerApiFailure).messageId, 'NET_0001');
      expect(mapped.message, '网络连接失败，请检查您的网络设置');
    });

    test('Should translate ServerApiFailure messageId to Japanese', () {
      currentLocale = 'ja';
      final failure = const ServerApiFailure('Original Message', messageId: 'NET_0001');
      final mapped = ErrorMapper.map(failure);

      expect(mapped, isA<ServerApiFailure>());
      expect((mapped as ServerApiFailure).messageId, 'NET_0001');
      expect(mapped.message, 'ネットワーク接続に失敗しました。接続設定を確認してください。');
    });

    test('Should translate raw message if messageId is missing but message has translation', () {
      currentLocale = 'zh';
      final failure = const ServerFailure('Reset All Settings');
      final mapped = ErrorMapper.map(failure);

      expect(mapped, isA<ServerFailure>());
      expect(mapped.message, '重置所有设置');
    });

    test('Should translate raw message if messageId is unknown but message has translation', () {
      currentLocale = 'zh';
      final failure = const ServerApiFailure('Reset All Settings', messageId: 'UNKNOWN_9999');
      final mapped = ErrorMapper.map(failure);

      expect(mapped, isA<ServerApiFailure>());
      expect((mapped as ServerApiFailure).messageId, 'UNKNOWN_9999');
      expect(mapped.message, '重置所有设置');
    });

    test('Should fallback to original message if no translation exists for messageId or raw message', () {
      currentLocale = 'zh';
      final failure = const ServerApiFailure('A completely random error message', messageId: 'UNKNOWN_9999');
      final mapped = ErrorMapper.map(failure);

      expect(mapped, isA<ServerApiFailure>());
      expect((mapped as ServerApiFailure).messageId, 'UNKNOWN_9999');
      expect(mapped.message, 'A completely random error message');
    });

    test('Should fallback to original message if non-ServerApiFailure has no translation', () {
      currentLocale = 'zh';
      final failure = const NetworkFailure('Unexpected network issue');
      final mapped = ErrorMapper.map(failure);

      expect(mapped, isA<NetworkFailure>());
      expect(mapped.message, 'Unexpected network issue');
    });

    test('Should support mapping all kinds of Failure subclasses to their matching subclass type', () {
      currentLocale = 'zh';

      expect(ErrorMapper.map(const ServerFailure('Reset All Settings')), isA<ServerFailure>());
      expect(ErrorMapper.map(const NetworkFailure('Reset All Settings')), isA<NetworkFailure>());
      expect(ErrorMapper.map(const CacheFailure('Reset All Settings')), isA<CacheFailure>());
      expect(ErrorMapper.map(const ValidationFailure('Reset All Settings')), isA<ValidationFailure>());
      expect(ErrorMapper.map(const AuthFailure('Reset All Settings')), isA<AuthFailure>());
      expect(ErrorMapper.map(const ParseFailure('Reset All Settings')), isA<ParseFailure>());
      expect(ErrorMapper.map(const UnknownFailure('Reset All Settings')), isA<UnknownFailure>());
    });
  });
}
