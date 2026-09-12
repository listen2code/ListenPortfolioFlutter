import 'package:in_app_review/in_app_review.dart';
import 'package:listen_core/core.dart';

import '../../constants/app_constants.dart';

/// Service managing in-app rating and review workflows utilizing native store APIs.
///
/// ### Core Architecture & Quota Governance:
/// Modern mobile app stores (Google Play and Apple App Store) strictly throttle in-app review requests:
/// - **Google Play Quota**: Enforces an opaque, server-side per-user quota. Calling the API too frequently
///   silently resolves without rendering the review bottom sheet.
/// - **Apple App Store Policy**: Limits review prompts to a maximum of 3 times within a 365-day period in production.
///
/// To prevent exhausting precious native prompt quotas and provide an unobtrusive user experience,
/// this service enforces three local gatekeeping criteria before attempting a prompt:
/// 1. **Launch Frequency Guard**: Requires at least [limitCount] (default 5) application launches.
/// 2. **Cooldown Period Guard**: Requires at least [limitDays] (default 90 days) between successive prompts.
/// 3. **Prior Review Deduplication**: Skips prompting if the user has already submitted a review or rating.
///
/// ### Golden Moment Bypass ([force]):
/// When a user completes a high-satisfaction milestone (e.g. successfully tipping via In-App Purchase),
/// [checkAndPromptReview] accepts `force: true`, immediately attempting native presentation while
/// remaining fully compliant with app store developer guidelines.
class ReviewService {
  static final ReviewService _instance = ReviewService._internal();

  /// Minimum number of app launches required before the automated review prompt is eligible.
  static final int limitCount = 5;

  /// Minimum cooldown interval (in days) between automated review prompts to prevent user fatigue.
  static final int limitDays = 90;

  factory ReviewService() => _instance;

  ReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;

  /// Increments and records the cumulative application launch counter in local persistent storage ([SpUtil]).
  ///
  /// Typically called during bootstrap in `AppInitializer.init()` (guarded by `!kIsWeb`).
  Future<void> logAppLaunch() async {
    final count = SpUtil.getInt(AppConstants.appLaunchCountKey) ?? 0;
    await SpUtil.put(AppConstants.appLaunchCountKey, count + 1);
  }

  /// Flags the user as having rated or received a review dialog in local persistent storage.
  ///
  /// Prevents future automated rate-limit checks from interrupting the user.
  Future<void> _markAsRated() async {
    await SpUtil.put(AppConstants.hasReviewKey, true);
  }

  /// Directly invokes the platform-native in-app review dialog via [InAppReview.requestReview].
  ///
  /// Handles hardware/store availability checks via [InAppReview.isAvailable] to prevent crashes
  /// on unsupported platforms (e.g. Android devices missing Google Play Services, Web, or Desktop).
  Future<void> _requestReviewDirectly() async {
    try {
      final isAvailable = await _inAppReview.isAvailable();
      if (isAvailable) {
        await _inAppReview.requestReview();
        await _markAsRated();
      } else {
        appLogger.w('ReviewService: In-app review is not available on this device.');
      }
    } catch (e) {
      appLogger.e('ReviewService: Failed to request in-app review: $e');
    }
  }

  /// Directs the user to the application's native listing page on Google Play or Apple App Store.
  ///
  /// Used for explicit user actions (e.g., tapping "Rate App" in the Settings page), completely
  /// bypassing in-app dialog quotas and rate-limiting rules.
  Future<void> openStoreRating() async {
    try {
      await _inAppReview.openStoreListing(
        // Configured in AppConstants for iOS App Store identification
        appStoreId: AppConstants.appStoreId,
      );
      await _markAsRated();
    } catch (e) {
      appLogger.e('ReviewService: Failed to open store listing: $e');
    }
  }

  /// Evaluates rate-limiting conditions and prompts the in-app review dialog if eligible.
  ///
  /// ### Gatekeeping Conditions (when [force] is `false`):
  /// 1. User has NOT previously rated (`hasReviewKey == false`).
  /// 2. User has launched the app at least [limitCount] times (`launchCount >= 5`).
  /// 3. At least [limitDays] (90 days) have elapsed since the last review prompt timestamp.
  ///
  /// When [force] is `true`, bypasses all gatekeeping checks and directly attempts
  /// [_requestReviewDirectly] (e.g. after a completed tip/coffee purchase).
  Future<void> checkAndPromptReview({bool force = false}) async {
    if (force) {
      await _requestReviewDirectly();
      return;
    }

    // Gate 1: Check if already rated or permanently dismissed
    final hasRated = SpUtil.getBool(AppConstants.hasReviewKey, defaultValue: false);
    if (hasRated) {
      appLogger.d('ReviewService: User has already rated. Skipping prompt.');
      return;
    }

    // Gate 2: Verify launch count threshold
    final launchCount = SpUtil.getInt(AppConstants.appLaunchCountKey) ?? 0;
    if (launchCount < limitCount) {
      appLogger.d('ReviewService: Launch count ($launchCount) is less than $limitCount. Skipping prompt.');
      return;
    }

    // Gate 3: Verify 90-day cooldown interval
    final lastPromptTime = SpUtil.getInt(AppConstants.lastReviewPromptTimeKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Minimum interval: 90 days
    final int ninetyDaysMs = limitDays * 24 * 60 * 60 * 1000;
    if (lastPromptTime > 0 && (now - lastPromptTime) < ninetyDaysMs) {
      appLogger.d('ReviewService: Less than $limitDays days since last prompt. Skipping.');
      return;
    }

    appLogger.i('ReviewService: Rate limits passed. Prompting in-app review dialog.');
    await SpUtil.put(AppConstants.lastReviewPromptTimeKey, now);
    await _requestReviewDirectly();
  }
}
