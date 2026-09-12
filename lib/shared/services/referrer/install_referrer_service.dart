import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';

import '../../constants/app_constants.dart';
import 'install_referrer_data.dart';

/// Abstract service interface for Google Play Install Referrer and Deferred Deep Linking.
///
/// ### Architecture & Responsibilities:
/// - Provides platform abstraction over Google Play's `InstallReferrerClient`.
/// - Encapsulates SharedPreferences state checks (`has_checked_install_referrer`)
///   to ensure idempotency and prevent annoying duplicate dialog prompts on successive launches.
/// - Enables unit and integration testing via [mockInstance] injection.
abstract class IInstallReferrerService {
  /// Unified logging tag prefix for all Deferred Deep Link / Install Referrer operations.
  static const String tag = 'Deferred Deep Link';

  /// Fetches the install referrer payload and metadata from Google Play on Android.
  /// Safely returns [InstallReferrerData.empty] on non-Android platforms (iOS, Web).
  Future<InstallReferrerData> fetchInstallReferrer();

  /// Checks if the install referrer has already been processed on this device.
  /// Returns `true` if the user previously confirmed with "Don't show again" or completed onboarding.
  Future<bool> hasProcessedReferrer();

  /// Marks the install referrer as processed in local storage so that it won't trigger duplicate dialogs.
  Future<void> markReferrerProcessed();

  /// Resets the processed state in local storage so that the referrer will be fetched again on next startup.
  Future<void> resetReferrerProcessed();

  /// Persists the detected referral data to local storage for long-term offline attribution.
  Future<void> saveReferrerData(InstallReferrerData data);

  /// Retrieves previously saved referral data from local storage, if any exists.
  Future<InstallReferrerData?> getSavedReferrerData();

  /// Simulates an install referrer payload for local development, demoing, and automated testing.
  Future<InstallReferrerData> simulateReferrer(String mockReferrer);
}

/// Global Riverpod provider for accessing [IInstallReferrerService].
final installReferrerServiceProvider = Provider<IInstallReferrerService>((ref) {
  return InstallReferrerServiceImpl.instance;
});

/// Production implementation of [IInstallReferrerService] backed by Android MethodChannel and SpUtil.
class InstallReferrerServiceImpl implements IInstallReferrerService {
  static const MethodChannel _channel = MethodChannel(AppConstants.methodChannelInstallReferrer);

  /// Test hook allowing unit and widget tests to override the singleton instance.
  static IInstallReferrerService? mockInstance;

  /// Global singleton accessor with mock override support.
  static IInstallReferrerService get instance => mockInstance ?? InstallReferrerServiceImpl();

  @override
  Future<InstallReferrerData> fetchInstallReferrer() async {
    // 1. Install Referrer API is Android specific; return empty for Web or iOS
    if (kIsWeb || !Platform.isAndroid) {
      appLogger.d('[${IInstallReferrerService.tag}] Skipped fetch - Platform is Web or non-Android');
      return InstallReferrerData.empty;
    }

    try {
      appLogger.i(
        '[${IInstallReferrerService.tag}] Invoking MethodChannel [${AppConstants.methodChannelInstallReferrer}] getInstallReferrer...',
      );
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('getInstallReferrer');
      if (result == null) {
        appLogger.w('[${IInstallReferrerService.tag}] MethodChannel returned null result');
        return InstallReferrerData.empty;
      }

      final String raw = (result['installReferrer'] as String?) ?? '';
      final int? clickTimestamp = result['referrerClickTimestampSeconds'] as int?;
      final int? installTimestamp = result['installBeginTimestampSeconds'] as int?;
      final bool instant = (result['googlePlayInstant'] as bool?) ?? false;

      appLogger
        ..i('[${IInstallReferrerService.tag}] Native channel returned raw referrer: "$raw"')
        ..d(
          '[${IInstallReferrerService.tag}] Metadata -> clickTimestamp: $clickTimestamp, installTimestamp: $installTimestamp, instant: $instant',
        );

      final parsed = InstallReferrerData.fromRawReferrer(
        raw,
        clickTimestampSeconds: clickTimestamp,
        installTimestampSeconds: installTimestamp,
        googlePlayInstant: instant,
      );

      appLogger.i(
        '[${IInstallReferrerService.tag}] Successfully parsed referrer -> refer: "${parsed.refer}", targetRoute: "${parsed.targetRoute}", utmSource: "${parsed.utmSource}", utmCampaign: "${parsed.utmCampaign}", hasReferral: ${parsed.hasReferral}',
      );
      return parsed;
    } on PlatformException catch (e) {
      appLogger.w('[${IInstallReferrerService.tag}] Platform exception fetching install referrer: ${e.message}');
      return InstallReferrerData.empty;
    } catch (e, stack) {
      appLogger.e(
        '[${IInstallReferrerService.tag}] Unexpected error fetching install referrer: $e',
        error: e,
        stackTrace: stack,
      );
      return InstallReferrerData.empty;
    }
  }

  @override
  Future<bool> hasProcessedReferrer() async {
    final processed = (SpUtil.get(AppConstants.hasCheckedInstallReferrerKey) as bool?) ?? false;
    appLogger.d('[${IInstallReferrerService.tag}] hasProcessedReferrer check result -> $processed');
    return processed;
  }

  @override
  Future<void> markReferrerProcessed() async {
    appLogger.i(
      '[${IInstallReferrerService.tag}] Marking referrer as processed in SpUtil [${AppConstants.hasCheckedInstallReferrerKey} = true]',
    );
    await SpUtil.put(AppConstants.hasCheckedInstallReferrerKey, true);
  }

  @override
  Future<void> resetReferrerProcessed() async {
    appLogger.i(
      '[${IInstallReferrerService.tag}] Resetting processed state [removing ${AppConstants.hasCheckedInstallReferrerKey} from SpUtil]',
    );
    await SpUtil.remove(AppConstants.hasCheckedInstallReferrerKey);
  }

  @override
  Future<void> saveReferrerData(InstallReferrerData data) async {
    appLogger.i(
      '[${IInstallReferrerService.tag}] Saving referral data to SpUtil [${AppConstants.savedInstallReferrerKey}]: ${data.toJsonString()}',
    );
    await SpUtil.put(AppConstants.savedInstallReferrerKey, data.toJsonString());
  }

  @override
  Future<InstallReferrerData?> getSavedReferrerData() async {
    final jsonStr = (SpUtil.get(AppConstants.savedInstallReferrerKey) as String?) ?? '';
    if (jsonStr.isEmpty) return null;
    appLogger.d('[${IInstallReferrerService.tag}] Retrieved saved referral data: $jsonStr');
    return InstallReferrerData.fromJsonString(jsonStr);
  }

  @override
  Future<InstallReferrerData> simulateReferrer(String mockReferrer) async {
    appLogger.i(
      '[${IInstallReferrerService.tag}] [SIMULATION] Simulating install referrer with payload: "$mockReferrer"',
    );
    final data = InstallReferrerData.fromRawReferrer(
      mockReferrer,
      clickTimestampSeconds: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      installTimestampSeconds: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    appLogger.i(
      '[${IInstallReferrerService.tag}] [SIMULATION] Parsed simulation data -> refer: "${data.refer}", targetRoute: "${data.targetRoute}", hasReferral: ${data.hasReferral}',
    );
    await saveReferrerData(data);
    return data;
  }
}
