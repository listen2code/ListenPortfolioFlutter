import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
  });

  group('Routes Utility Tests', () {
    test('makeHomeTabDeepLink produces expected Uri scheme, host, and tab parameter', () {
      final uri = Routes.makeHomeTabDeepLink('projects');
      expect(uri.scheme, AppConstants.deepLinkScheme);
      expect(uri.host, AppConstants.deepLinkHostHome);
      expect(uri.queryParameters[AppConstants.deepLinkParamTab], 'projects');
    });

    test('Route constants are distinct and formatted correctly', () {
      final routeList = [
        Routes.root,
        Routes.home,
        Routes.aiChat,
        Routes.login,
        Routes.signUp,
        Routes.forgotPassword,
        Routes.changePassword,
        Routes.settings,
        Routes.appearance,
        Routes.deleteAccount,
        Routes.crashLogs,
        Routes.termsOfService,
        Routes.privacyPolicy,
        Routes.webViewTest,
        Routes.resume,
        Routes.playbackTapeList,
        Routes.faultInjection,
      ];

      // Verify all routes are unique
      expect(routeList.toSet().length, routeList.length);

      // Verify all start with '/'
      for (final r in routeList) {
        expect(r.startsWith('/'), isTrue);
      }
    });

    test('Routes.routes map contains builders for all declared routes', () {
      final map = Routes.routes;

      expect(map.containsKey(Routes.root), isTrue);
      expect(map.containsKey(Routes.home), isTrue);
      expect(map.containsKey(Routes.aiChat), isTrue);
      expect(map.containsKey(Routes.login), isTrue);
      expect(map.containsKey(Routes.signUp), isTrue);
      expect(map.containsKey(Routes.forgotPassword), isTrue);
      expect(map.containsKey(Routes.changePassword), isTrue);
      expect(map.containsKey(Routes.settings), isTrue);
      expect(map.containsKey(Routes.appearance), isTrue);
      expect(map.containsKey(Routes.deleteAccount), isTrue);
      expect(map.containsKey(Routes.crashLogs), isTrue);
      expect(map.containsKey(Routes.termsOfService), isTrue);
      expect(map.containsKey(Routes.privacyPolicy), isTrue);
      expect(map.containsKey(Routes.resume), isTrue);
      expect(map.containsKey(Routes.playbackTapeList), isTrue);
      expect(map.containsKey(Routes.faultInjection), isTrue);
      expect(map.containsKey(Routes.webViewTest), isTrue);

      // Ensure each synchronous builder returns a non-null Widget
      for (final entry in map.entries) {
        final widget = entry.value();
        expect(widget, isNotNull);
      }
    });
  });
}
