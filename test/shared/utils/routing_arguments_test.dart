import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/utils/routing_arguments.dart';

void main() {
  group('Routing Arguments Tests', () {
    test('SignUpArguments fromMap parses username, initial_username, and name', () {
      final fromUsername = SignUpArguments.fromMap({'username': 'alice'});
      expect(fromUsername.initialUsername, 'alice');
      expect(fromUsername.toString(), contains('alice'));

      final fromInitial = SignUpArguments.fromMap({'initial_username': 'bob'});
      expect(fromInitial.initialUsername, 'bob');

      final fromName = SignUpArguments.fromMap({'name': 'charlie'});
      expect(fromName.initialUsername, 'charlie');

      final empty = SignUpArguments.fromMap({});
      expect(empty.initialUsername, isNull);
    });

    test('SettingsArguments fromMap handles boolean and string boolean values', () {
      final boolTrue = SettingsArguments.fromMap({'check_update': true});
      expect(boolTrue.checkUpdate, isTrue);
      expect(boolTrue.toString(), contains('true'));

      final stringTrue = SettingsArguments.fromMap({'check_update': 'true'});
      expect(stringTrue.checkUpdate, isTrue);

      final camelTrue = SettingsArguments.fromMap({'checkUpdate': true});
      expect(camelTrue.checkUpdate, isTrue);

      final boolFalse = SettingsArguments.fromMap({'check_update': false});
      expect(boolFalse.checkUpdate, isFalse);

      final stringFalse = SettingsArguments.fromMap({'check_update': 'false'});
      expect(stringFalse.checkUpdate, isFalse);

      final empty = SettingsArguments.fromMap({});
      expect(empty.checkUpdate, isFalse);
    });

    test('CrashLogListArguments fromMap parses file_path and filePath', () {
      final snake = CrashLogListArguments.fromMap({'file_path': '/path/to/log.txt'});
      expect(snake.filePath, '/path/to/log.txt');
      expect(snake.toString(), contains('/path/to/log.txt'));

      final camel = CrashLogListArguments.fromMap({'filePath': '/alt/path.txt'});
      expect(camel.filePath, '/alt/path.txt');

      final empty = CrashLogListArguments.fromMap({});
      expect(empty.filePath, isNull);
    });
  });
}
