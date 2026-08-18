import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/services/review/review_service.dart';
import 'package:listen_core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReviewService Tests', () {
    late ReviewService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');
      service = ReviewService();
    });

    test('logAppLaunch should increment launch count in SpUtil', () async {
      expect(SpUtil.getInt(AppConstants.appLaunchCountKey) ?? 0, 0);

      await service.logAppLaunch();
      expect(SpUtil.getInt(AppConstants.appLaunchCountKey), 1);

      await service.logAppLaunch();
      expect(SpUtil.getInt(AppConstants.appLaunchCountKey), 2);
    });

    test('checkAndPromptReview should not throw when rating already recorded', () async {
      await SpUtil.put(AppConstants.hasReviewKey, true);
      await service.checkAndPromptReview();
    });
  });
}
