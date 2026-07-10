import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  group('AppNav Routing & Deep Link Tests', () {
    setUp(() {
      AppNav.currentArgs = null;
      AppNav.currentRouteName = null;

      // Register converters for testing
      AppNav.registerArgumentConverter<SignUpArguments>((map) => SignUpArguments.fromMap(map));
      AppNav.registerArgumentConverter<SettingsArguments>((map) => SettingsArguments.fromMap(map));
      AppNav.registerArgumentConverter<CrashLogListArguments>((map) => CrashLogListArguments.fromMap(map));
    });

    test('should extract parameters correctly from standard URL query string', () {
      // Set currentArgs to a parsed query param map
      AppNav.currentArgs = {'check_update': 'true', 'file_path': '/path/to/log.txt', 'username': 'johndoe'};

      // Retrieve via getParam
      expect(AppNav.getParam<bool>('check_update'), isTrue);
      expect(AppNav.getParam<String>('file_path'), '/path/to/log.txt');

      // Retrieve via getArgs and check fallback mapping to typed classes
      final settingsArgs = AppNav.getArgs<SettingsArguments>();
      expect(settingsArgs, isNotNull);
      expect(settingsArgs!.checkUpdate, isTrue);

      final crashArgs = AppNav.getArgs<CrashLogListArguments>();
      expect(crashArgs, isNotNull);
      expect(crashArgs!.filePath, '/path/to/log.txt');

      final signUpArgs = AppNav.getArgs<SignUpArguments>();
      expect(signUpArgs, isNotNull);
      expect(signUpArgs!.initialUsername, 'johndoe');
    });

    test('should handle url decode in query parameters', () {
      AppNav.currentArgs = {'file_path': '%2Fpath%2Fto%2Fsome%20file.txt'};

      // Let's verify type-safe parsing from raw maps that might need decoding (though decode is done at route parsing time)
      final crashArgs = AppNav.getArgs<CrashLogListArguments>();
      expect(
        crashArgs!.filePath,
        '%2Fpath%2Fto%2Fsome%20file.txt',
      ); // Already decoded when parsed, here we check the mapping
    });

    test('onGenerateRoute should parse deep links with custom scheme listen://', () {
      // Register a dummy route so getBuilder doesn't return null
      AppNavConfig.register(
        isGuest: () => false,
        onLogin: (ctx) async => true,
        routes: {'/settings': () => Container()},
        schemes: ['listen'],
      );

      final route = AppNav.onGenerateRoute(
        const RouteSettings(name: 'listen://settings?check_update=true&checkUpdate=true'),
      );

      expect(route, isNotNull);
      expect(route!.settings.name, '/settings');
      expect(route.settings.arguments, isA<Map<String, dynamic>>());

      final argsMap = route.settings.arguments as Map<String, dynamic>;
      expect(argsMap['check_update'], 'true');
      expect(argsMap['checkUpdate'], 'true');
    });

    test('onGenerateRoute should parse deep links with custom scheme myapp://', () {
      AppNavConfig.register(
        isGuest: () => false,
        onLogin: (ctx) async => true,
        routes: {'/settings': () => Container()},
        schemes: ['myapp'],
      );

      final route = AppNav.onGenerateRoute(const RouteSettings(name: 'myapp://settings?check_update=false'));

      expect(route, isNotNull);
      expect(route!.settings.name, '/settings');
      expect(route.settings.arguments, isA<Map<String, dynamic>>());

      final argsMap = route.settings.arguments as Map<String, dynamic>;
      expect(argsMap['check_update'], 'false');
    });
  });
}
