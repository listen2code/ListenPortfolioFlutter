import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/utils/routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Routes Utility Tests', () {
    test('makeHomeTabDeepLink generates valid URI with scheme and tab name', () {
      final uri = Routes.makeHomeTabDeepLink('architecture');
      expect(uri.scheme, AppConstants.deepLinkScheme);
      expect(uri.host, AppConstants.deepLinkHostHome);
      expect(uri.queryParameters[AppConstants.deepLinkParamTab], 'architecture');
    });

    test('routes map contains all required screen builders', () {
      final routesMap = Routes.routes;

      expect(routesMap.containsKey(Routes.root), isTrue);
      expect(routesMap.containsKey(Routes.home), isTrue);
      expect(routesMap.containsKey(Routes.aiChat), isTrue);
      expect(routesMap.containsKey(Routes.login), isTrue);
      expect(routesMap.containsKey(Routes.signUp), isTrue);
      expect(routesMap.containsKey(Routes.forgotPassword), isTrue);
      expect(routesMap.containsKey(Routes.changePassword), isTrue);
      expect(routesMap.containsKey(Routes.settings), isTrue);
      expect(routesMap.containsKey(Routes.appearance), isTrue);
      expect(routesMap.containsKey(Routes.deleteAccount), isTrue);
      expect(routesMap.containsKey(Routes.crashLogs), isTrue);
      expect(routesMap.containsKey(Routes.termsOfService), isTrue);
      expect(routesMap.containsKey(Routes.privacyPolicy), isTrue);
      expect(routesMap.containsKey(Routes.resume), isTrue);
      expect(routesMap.containsKey(Routes.playbackTapeList), isTrue);
      expect(routesMap.containsKey(Routes.webViewTest), isTrue);

      // Verify widget instance creation from builders
      expect(routesMap[Routes.root]!(), isNotNull);
      expect(routesMap[Routes.home]!(), isNotNull);
      expect(routesMap[Routes.aiChat]!(), isNotNull);
      expect(routesMap[Routes.login]!(), isNotNull);
      expect(routesMap[Routes.signUp]!(), isNotNull);
      expect(routesMap[Routes.forgotPassword]!(), isNotNull);
      expect(routesMap[Routes.changePassword]!(), isNotNull);
      expect(routesMap[Routes.settings]!(), isNotNull);
      expect(routesMap[Routes.appearance]!(), isNotNull);
      expect(routesMap[Routes.deleteAccount]!(), isNotNull);
      expect(routesMap[Routes.crashLogs]!(), isNotNull);
      expect(routesMap[Routes.termsOfService]!(), isNotNull);
      expect(routesMap[Routes.privacyPolicy]!(), isNotNull);
      expect(routesMap[Routes.resume]!(), isNotNull);
      expect(routesMap[Routes.playbackTapeList]!(), isNotNull);
      expect(routesMap[Routes.webViewTest]!(), isNotNull);
    });
  });
}
