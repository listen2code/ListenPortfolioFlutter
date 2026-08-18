import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/pages/common_web_view_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CommonWebViewPage Tests', () {
    test('CommonWebViewPage property initialization', () {
      final page = CommonWebViewPage(
        title: 'Terms of Service',
        url: 'https://example.com/terms',
        onLoadStart: (url) {},
        onLoadStop: (url) {},
        shouldOverrideUrlLoading: (url) => false,
        javascriptHandlers: {
          'nativeBridge': (args) => 'success',
        },
      );

      expect(page.title, 'Terms of Service');
      expect(page.url, 'https://example.com/terms');
      expect(page.preventSwipeBack, isTrue);
      expect(page.onLoadStart, isNotNull);
      expect(page.onLoadStop, isNotNull);
      expect(page.shouldOverrideUrlLoading, isNotNull);
      expect(page.javascriptHandlers?.containsKey('nativeBridge'), isTrue);
    });
  });
}
