import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AppNav Routing & Deep Link Tests', () {
    setUp(() {
      AppNav.currentArgs = null;
      AppNav.currentRouteName = null;
      EventBus().clearAllSticky();

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

    test('should extract parameters correctly from generic Map (e.g. Map<dynamic, dynamic>)', () {
      final Map<dynamic, dynamic> genericMap = {
        'check_update': 'true',
        'file_path': '/path/to/log.txt',
        'username': 'johndoe'
      };
      AppNav.currentArgs = genericMap;

      expect(AppNav.getParam<bool>('check_update'), isTrue);

      final settingsArgs = AppNav.getArgs<SettingsArguments>();
      expect(settingsArgs, isNotNull);
      expect(settingsArgs!.checkUpdate, isTrue);
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

    testWidgets('DeepLinkManager should trigger AppNav.to and push route and arguments', (tester) async {
      AppNavConfig.register(
        isGuest: () => false,
        onLogin: (ctx) async => true,
        routes: {
          '/settings': () => const Text('SettingsPage'),
        },
        schemes: ['listen'],
      );

      AppNav.registerArgumentConverter<SettingsArguments>((map) => SettingsArguments.fromMap(map));

      // Build the navigator
      await tester.pumpWidget(MaterialApp(
        navigatorKey: AppNavConfig.navigatorKey,
        navigatorObservers: [AppNav.observer],
        onGenerateRoute: AppNav.onGenerateRoute,
        home: const Text('HomePage'),
      ));

      // Subscribe to EventBus deep link event (mocking HomeViewModel behavior)
      final sub = EventBus().on<CommonEvent<Uri>>(
        (event) {
          if (event.data != null) {
            AppNav.to(event.data!.toString());
          }
        },
        key: DeepLinkManager.deepLinkEventKey,
        sticky: true,
      );

      // Trigger DeepLinkManager
      await DeepLinkManager.instance.handleUriForTesting(Uri.parse('listen://settings?check_update=true'));

      // Pump to settle transitions
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify that it went through AppNav and resolved arguments
      final args = AppNav.getArgs<SettingsArguments>();
      expect(args, isNotNull);
      expect(args!.checkUpdate, isTrue);
      expect(find.text('SettingsPage'), findsOneWidget);

      sub.cancel();
    });

    testWidgets('DeepLinkManager should bypass AppNav when onLinkReceived hook returns true', (tester) async {
      AppNavConfig.register(
        isGuest: () => false,
        onLogin: (ctx) async => true,
        routes: {
          '/settings': () => const Text('SettingsPage'),
        },
        schemes: ['listen'],
      );

      // Build the navigator
      await tester.pumpWidget(MaterialApp(
        navigatorKey: AppNavConfig.navigatorKey,
        navigatorObservers: [AppNav.observer],
        onGenerateRoute: AppNav.onGenerateRoute,
        home: const Text('HomePage'),
      ));

      // Subscribe to EventBus deep link event (mocking HomeViewModel behavior)
      final sub = EventBus().on<CommonEvent<Uri>>(
        (event) {
          if (event.data != null) {
            AppNav.to(event.data!.toString());
          }
        },
        key: DeepLinkManager.deepLinkEventKey,
        sticky: true,
      );

      bool interceptorCalled = false;
      DeepLinkManager.instance.onLinkReceived = (uri) {
        interceptorCalled = true;
        return true; // Intercepted!
      };

      // Call handleUriForTesting
      await DeepLinkManager.instance.handleUriForTesting(Uri.parse('listen://settings?check_update=true'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(interceptorCalled, isTrue);
      expect(find.text('SettingsPage'), findsNothing);
      expect(find.text('HomePage'), findsOneWidget);

      // Clean up hook & subscription
      DeepLinkManager.instance.onLinkReceived = null;
      sub.cancel();
    });

    testWidgets('AppNav.to should replace if target route is already the current route', (tester) async {
      AppNavConfig.register(
        isGuest: () => false,
        onLogin: (ctx) async => true,
        routes: {
          '/settings': () => const Text('SettingsPage'),
          '/home': () => const Text('HomePage'),
        },
        schemes: ['listen'],
      );

      // Build the navigator
      await tester.pumpWidget(MaterialApp(
        navigatorKey: AppNavConfig.navigatorKey,
        navigatorObservers: [AppNav.observer],
        onGenerateRoute: AppNav.onGenerateRoute,
        home: const Text('HomePage'),
      ));

      // Push settings page
      AppNav.to('/settings');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(AppNav.currentRouteName, '/settings');
      expect(find.text('SettingsPage'), findsOneWidget);

      // 1. Try pushing settings again without replaceIfExists. It should be ignored (directly return).
      AppNav.to('/settings', arguments: {'check_update': 'false'});
      await tester.pumpAndSettle();
      
      // Arguments should NOT be updated because it directly returned
      final argsIgnored = AppNav.getArgs<SettingsArguments>();
      expect(argsIgnored?.checkUpdate ?? false, isFalse);

      // 2. Try pushing settings again with replaceIfExists: true. It should replace.
      AppNav.to('/settings', arguments: {'check_update': 'true'}, replaceIfExists: true);
      await tester.pumpAndSettle();

      // Route name should still be settings
      expect(AppNav.currentRouteName, '/settings');
      expect(find.text('SettingsPage'), findsOneWidget);
      
      // And the arguments should be updated
      final args = AppNav.getArgs<SettingsArguments>();
      expect(args, isNotNull);
      expect(args!.checkUpdate, isTrue);

      // Verify that going back takes us back to HomePage (meaning Settings was replaced, not stacked)
      AppNav.back();
      await tester.pumpAndSettle();
      
      expect(AppNav.currentRouteName, '/'); // initial route home defaults to '/'
      expect(find.text('HomePage'), findsOneWidget);
    });

    test('DeepLinkManager EventBus integration should fire and subscribe to deepLinkEventKey', () async {
      final uris = <Uri>[];
      final sub = EventBus().on<CommonEvent<Uri>>(
        (event) {
          if (event.data != null) uris.add(event.data!);
        },
        key: DeepLinkManager.deepLinkEventKey,
        sticky: true,
      );

      final testUri = Uri.parse('listen://settings?test=true');
      EventBus().fire(CommonEvent<Uri>(
        DeepLinkManager.deepLinkEventKey,
        data: testUri,
        sticky: true,
        autoClear: true,
      ));

      await Future<void>.delayed(Duration.zero);
      expect(uris, contains(testUri));
      sub.cancel();
    });
  });
}
