import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/services/review/review_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ReviewService reviewService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    reviewService = ReviewService();
  });

  group('ReviewService Unit Tests', () {
    test('logAppLaunch increments launch count in SpUtil', () async {
      expect(SpUtil.getInt(AppConstants.appLaunchCountKey) ?? 0, equals(0));

      await reviewService.logAppLaunch();
      expect(SpUtil.getInt(AppConstants.appLaunchCountKey), equals(1));

      await reviewService.logAppLaunch();
      expect(SpUtil.getInt(AppConstants.appLaunchCountKey), equals(2));
    });

    test('checkAndPromptReview skips when user has already rated', () async {
      await SpUtil.put(AppConstants.hasReviewKey, true);
      await SpUtil.put(AppConstants.appLaunchCountKey, 10);

      // Should return without error and not prompt
      await reviewService.checkAndPromptReview();
      expect(SpUtil.getBool(AppConstants.hasReviewKey), isTrue);
    });

    test('checkAndPromptReview skips when launch count is below threshold', () async {
      await SpUtil.put(AppConstants.hasReviewKey, false);
      await SpUtil.put(AppConstants.appLaunchCountKey, 2);

      await reviewService.checkAndPromptReview();
      expect(SpUtil.getInt(AppConstants.lastReviewPromptTimeKey) ?? 0, equals(0));
    });

    test('checkAndPromptReview skips when last prompt was less than 90 days ago', () async {
      final recentTimestamp = DateTime.now().millisecondsSinceEpoch - (10 * 24 * 60 * 60 * 1000); // 10 days ago
      await SpUtil.put(AppConstants.hasReviewKey, false);
      await SpUtil.put(AppConstants.appLaunchCountKey, 10);
      await SpUtil.put(AppConstants.lastReviewPromptTimeKey, recentTimestamp);

      await reviewService.checkAndPromptReview();
      expect(SpUtil.getInt(AppConstants.lastReviewPromptTimeKey), equals(recentTimestamp));
    });

    test('checkAndPromptReview with force=true executes without checking launch count', () async {
      await SpUtil.put(AppConstants.appLaunchCountKey, 0);

      // Force = true bypasses checks
      await reviewService.checkAndPromptReview(force: true);
    });
  });
}
