import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/i18n/languages/ja.dart';
import 'package:listen_portfolio_flutter/shared/i18n/languages/zh.dart';

void main() {
  test('I18n Translation Keys Integrity Test', () {
    // 1. Read translations_key.dart file
    final file = File('lib/shared/i18n/translations_key.dart');
    expect(file.existsSync(), true, reason: 'translations_key.dart should exist');

    final content = file.readAsStringSync();
    
    // Regex using triple-quoted raw string to match single and double quotes
    final regExp = RegExp(r'''static const String \w+\s*=\s*["']([^"']+)["'];''');
    final matches = regExp.allMatches(content);
    
    expect(matches.isNotEmpty, true, reason: 'Should find at least some translation keys');

    final List<String> missingZh = [];
    final List<String> missingJa = [];
    final List<String> allKeys = [];

    for (final match in matches) {
      final keyVal = match.group(1)!.replaceAll(r'\n', '\n');
      allKeys.add(keyVal);

      // Verify keyVal exists in zh map
      if (!zh.containsKey(keyVal) || zh[keyVal] == null || zh[keyVal]!.isEmpty) {
        missingZh.add(keyVal);
      }

      // Verify keyVal exists in ja map
      if (!ja.containsKey(keyVal) || ja[keyVal] == null || ja[keyVal]!.isEmpty) {
        missingJa.add(keyVal);
      }
    }

    print('Total translation keys verified: ${allKeys.length}');

    expect(missingZh, isEmpty, reason: 'Chinese translation map (zh) is missing keys: $missingZh');
    expect(missingJa, isEmpty, reason: 'Japanese translation map (ja) is missing keys: $missingJa');
  });
}
