import 'package:in_app_review/in_app_review.dart';
import 'package:listen_core/core.dart';

import '../../constants/app_constants.dart';

/// Service to manage app review requests using the In-App Review API.
/// Incorporates rate-limiting to comply with Google Play Store guidelines.
class ReviewService {
  static final ReviewService _instance = ReviewService._internal();

  factory ReviewService() => _instance;

  ReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;

  /// Logs the app launch event. Call this during the app initialization phase.
  Future<void> logAppLaunch() async {
    final count = SpUtil.getInt(AppConstants.appLaunchCountKey) ?? 0;
    await SpUtil.put(AppConstants.appLaunchCountKey, count + 1);
  }

  /// Marks that the user has rated or successfully prompted the review dialog.
  Future<void> markAsRated() async {
    await SpUtil.put(AppConstants.hasReviewKey, true);
  }

  /// Explicitly requests the in-app review dialog.
  Future<void> requestReviewDirectly() async {
    try {
      final isAvailable = await _inAppReview.isAvailable();
      if (isAvailable) {
        await _inAppReview.requestReview();
        await markAsRated();
      } else {
        appLogger.w('ReviewService: In-app review is not available on this device.');
      }
    } catch (e) {
      appLogger.e('ReviewService: Failed to request in-app review: $e');
    }
  }

  /// Opens the store listing page directly.
  /// Typically used when the user clicks an explicit "Rate App" button.
  Future<void> openStoreRating() async {
    try {
      await _inAppReview.openStoreListing(
        // Replace with your iOS App Store ID when publishing on Apple App Store
        appStoreId: AppConstants.appStoreId,
      );
      await markAsRated();
    } catch (e) {
      appLogger.e('ReviewService: Failed to open store listing: $e');
    }
  }

  /// Checks the rate limits and prompts the review dialog if eligible.
  ///
  /// Eligible criteria:
  /// - User has launched the app at least 5 times.
  /// - User has not rated the app yet.
  /// - At least 90 days have passed since the last review prompt.
  ///
  /// Set [force] to true to bypass rate-limits (e.g. after a purchase).
  Future<void> checkAndPromptReview({bool force = false}) async {
    if (force) {
      await requestReviewDirectly();
      return;
    }

    final hasRated = SpUtil.getBool(AppConstants.hasReviewKey, defaultValue: false);
    if (hasRated) {
      appLogger.d('ReviewService: User has already rated. Skipping prompt.');
      return;
    }

    final launchCount = SpUtil.getInt(AppConstants.appLaunchCountKey) ?? 0;
    if (launchCount < 5) {
      appLogger.d('ReviewService: Launch count ($launchCount) is less than 5. Skipping prompt.');
      return;
    }

    final lastPromptTime = SpUtil.getInt(AppConstants.lastReviewPromptTimeKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Minimum interval: 90 days
    const int ninetyDaysMs = 90 * 24 * 60 * 60 * 1000;
    if (lastPromptTime > 0 && (now - lastPromptTime) < ninetyDaysMs) {
      appLogger.d('ReviewService: Less than 90 days since last prompt. Skipping.');
      return;
    }

    appLogger.i('ReviewService: Rate limits passed. Prompting in-app review dialog.');
    await SpUtil.put(AppConstants.lastReviewPromptTimeKey, now);
    await requestReviewDirectly();
  }
}
