import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/utils/routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Routes Utility Tests', () {
    test('makeHomeTabDeepLink builds correct URI with query parameters', () {
      final uri = Routes.makeHomeTabDeepLink('aboutMe');

      expect(uri.scheme, equals(AppConstants.deepLinkScheme));
      expect(uri.host, equals(AppConstants.deepLinkHostHome));
      expect(uri.queryParameters[AppConstants.deepLinkParamTab], equals('aboutMe'));
      expect(uri.toString(), contains('tab=aboutMe'));
    });

    test('routes map contains all defined path constants', () {
      final routeMap = Routes.routes;

      expect(routeMap.containsKey(Routes.root), isTrue);
      expect(routeMap.containsKey(Routes.home), isTrue);
      expect(routeMap.containsKey(Routes.aiChat), isTrue);
      expect(routeMap.containsKey(Routes.login), isTrue);
      expect(routeMap.containsKey(Routes.signUp), isTrue);
      expect(routeMap.containsKey(Routes.forgotPassword), isTrue);
      expect(routeMap.containsKey(Routes.changePassword), isTrue);
      expect(routeMap.containsKey(Routes.settings), isTrue);
      expect(routeMap.containsKey(Routes.appearance), isTrue);
      expect(routeMap.containsKey(Routes.deleteAccount), isTrue);
      expect(routeMap.containsKey(Routes.crashLogs), isTrue);
      expect(routeMap.containsKey(Routes.termsOfService), isTrue);
      expect(routeMap.containsKey(Routes.privacyPolicy), isTrue);
      expect(routeMap.containsKey(Routes.resume), isTrue);
      expect(routeMap.containsKey(Routes.playbackTapeList), isTrue);
      expect(routeMap.containsKey(Routes.faultInjection), isTrue);
      expect(routeMap.containsKey(Routes.webViewTest), isTrue);
    });

    test('route builders instantiate valid widget instances', () {
      final splashWidgetBuilder = Routes.routes[Routes.root];
      expect(splashWidgetBuilder, isNotNull);
      final splashWidget = splashWidgetBuilder!();
      expect(splashWidget, isNotNull);

      final settingsWidgetBuilder = Routes.routes[Routes.settings];
      expect(settingsWidgetBuilder, isNotNull);
      final settingsWidget = settingsWidgetBuilder!();
      expect(settingsWidget, isNotNull);
    });
  });
}
