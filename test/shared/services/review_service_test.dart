import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/services/review/review_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Comprehensive unit test suite for [ReviewService].
///
/// Verifies application launch count tracking, local gatekeeping evaluation
/// (prior rating deduplication, launch frequency threshold, 90-day cooldown interval),
/// and the forced bypass mechanism for golden conversion moments.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ReviewService reviewService;

  setUp(() async {
    // Reset and isolate SharedPreferences mock state before each test
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
      // Simulate existing user rating state
      await SpUtil.put(AppConstants.hasReviewKey, true);
      await SpUtil.put(AppConstants.appLaunchCountKey, 10);

      // Gate 1: Should exit immediately without updating prompt timestamp
      await reviewService.checkAndPromptReview();
      expect(SpUtil.getBool(AppConstants.hasReviewKey), isTrue);
      expect(SpUtil.getInt(AppConstants.lastReviewPromptTimeKey) ?? 0, equals(0));
    });

    test('checkAndPromptReview skips when launch count is below threshold', () async {
      // Gate 2: Fewer than 5 launches should be skipped
      await SpUtil.put(AppConstants.hasReviewKey, false);
      await SpUtil.put(AppConstants.appLaunchCountKey, 2);

      await reviewService.checkAndPromptReview();
      expect(SpUtil.getInt(AppConstants.lastReviewPromptTimeKey) ?? 0, equals(0));
    });

    test('checkAndPromptReview skips when last prompt was less than 90 days ago', () async {
      // Gate 3: Prompted 10 days ago (within 90-day cooldown window)
      final recentTimestamp = DateTime.now().millisecondsSinceEpoch - (10 * 24 * 60 * 60 * 1000);
      await SpUtil.put(AppConstants.hasReviewKey, false);
      await SpUtil.put(AppConstants.appLaunchCountKey, 10);
      await SpUtil.put(AppConstants.lastReviewPromptTimeKey, recentTimestamp);

      await reviewService.checkAndPromptReview();
      // Timestamp must remain unchanged
      expect(SpUtil.getInt(AppConstants.lastReviewPromptTimeKey), equals(recentTimestamp));
    });

    test('checkAndPromptReview with force=true executes without checking launch count', () async {
      // Golden Moment: Force bypasses launch count and cooldown checks even on first run
      await SpUtil.put(AppConstants.appLaunchCountKey, 0);

      await reviewService.checkAndPromptReview(force: true);
      // Native prompt gracefully completes in headless test environment
    });
  });
}
