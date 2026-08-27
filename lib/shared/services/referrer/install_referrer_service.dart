import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';

import '../../constants/app_constants.dart';
import 'install_referrer_data.dart';

/// Abstract service interface for Google Play Install Referrer and Deferred Deep Linking.
abstract class IInstallReferrerService {
  /// Fetches the install referrer from Google Play on Android.
  Future<InstallReferrerData> fetchInstallReferrer();

  /// Checks if the install referrer has already been processed on this device.
  Future<bool> hasProcessedReferrer();

  /// Marks the install referrer as processed so that it won't trigger duplicate dialogs.
  Future<void> markReferrerProcessed();

  /// Resets the processed state so that the referrer will be fetched again on next startup.
  Future<void> resetReferrerProcessed();

  /// Persists the detected referral data to local storage.
  Future<void> saveReferrerData(InstallReferrerData data);

  /// Retrieves previously saved referral data, if any.
  Future<InstallReferrerData?> getSavedReferrerData();

  /// Simulates an install referrer for development and testing.
  Future<InstallReferrerData> simulateReferrer(String mockReferrer);
}

/// Global provider for [IInstallReferrerService].
final installReferrerServiceProvider = Provider<IInstallReferrerService>((ref) {
  return InstallReferrerServiceImpl.instance;
});

/// Default implementation of [IInstallReferrerService].
class InstallReferrerServiceImpl implements IInstallReferrerService {
  static const MethodChannel _channel = MethodChannel(AppConstants.methodChannelInstallReferrer);

  /// For unit testing overrides.
  static IInstallReferrerService? mockInstance;

  static IInstallReferrerService get instance => mockInstance ?? InstallReferrerServiceImpl();

  @override
  Future<InstallReferrerData> fetchInstallReferrer() async {
    // 1. Install Referrer API is Android specific; return empty for Web or iOS
    if (kIsWeb || !Platform.isAndroid) {
      appLogger.d('InstallReferrerService: Skipped fetch - Platform is Web or non-Android');
      return InstallReferrerData.empty;
    }

    try {
      appLogger.i(
        'InstallReferrerService: Invoking MethodChannel [${AppConstants.methodChannelInstallReferrer}] getInstallReferrer...',
      );
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('getInstallReferrer');
      if (result == null) {
        appLogger.w('InstallReferrerService: MethodChannel returned null result');
        return InstallReferrerData.empty;
      }

      final String raw = (result['installReferrer'] as String?) ?? '';
      final int? clickTimestamp = result['referrerClickTimestampSeconds'] as int?;
      final int? installTimestamp = result['installBeginTimestampSeconds'] as int?;
      final bool instant = (result['googlePlayInstant'] as bool?) ?? false;

      appLogger
        ..i('InstallReferrerService: Native channel returned raw referrer: "$raw"')
        ..d(
          'InstallReferrerService: Metadata -> clickTimestamp: $clickTimestamp, installTimestamp: $installTimestamp, instant: $instant',
        );

      final parsed = InstallReferrerData.fromRawReferrer(
        raw,
        clickTimestampSeconds: clickTimestamp,
        installTimestampSeconds: installTimestamp,
        googlePlayInstant: instant,
      );

      appLogger.i(
        'InstallReferrerService: Successfully parsed referrer -> refer: "${parsed.refer}", targetRoute: "${parsed.targetRoute}", utmSource: "${parsed.utmSource}", utmCampaign: "${parsed.utmCampaign}", hasReferral: ${parsed.hasReferral}',
      );
      return parsed;
    } on PlatformException catch (e) {
      appLogger.w('InstallReferrerService: Platform exception fetching install referrer: ${e.message}');
      return InstallReferrerData.empty;
    } catch (e, stack) {
      appLogger.e(
        'InstallReferrerService: Unexpected error fetching install referrer: $e',
        error: e,
        stackTrace: stack,
      );
      return InstallReferrerData.empty;
    }
  }

  @override
  Future<bool> hasProcessedReferrer() async {
    final processed = (SpUtil.get(AppConstants.hasCheckedInstallReferrerKey) as bool?) ?? false;
    appLogger.d('InstallReferrerService: hasProcessedReferrer check result -> $processed');
    return processed;
  }

  @override
  Future<void> markReferrerProcessed() async {
    appLogger.i(
      'InstallReferrerService: Marking referrer as processed in SpUtil [${AppConstants.hasCheckedInstallReferrerKey} = true]',
    );
    await SpUtil.put(AppConstants.hasCheckedInstallReferrerKey, true);
  }

  @override
  Future<void> resetReferrerProcessed() async {
    appLogger.i(
      'InstallReferrerService: Resetting processed state [removing ${AppConstants.hasCheckedInstallReferrerKey} from SpUtil]',
    );
    await SpUtil.remove(AppConstants.hasCheckedInstallReferrerKey);
  }

  @override
  Future<void> saveReferrerData(InstallReferrerData data) async {
    appLogger.i(
      'InstallReferrerService: Saving referral data to SpUtil [${AppConstants.savedInstallReferrerKey}]: ${data.toJsonString()}',
    );
    await SpUtil.put(AppConstants.savedInstallReferrerKey, data.toJsonString());
  }

  @override
  Future<InstallReferrerData?> getSavedReferrerData() async {
    final jsonStr = (SpUtil.get(AppConstants.savedInstallReferrerKey) as String?) ?? '';
    if (jsonStr.isEmpty) return null;
    appLogger.d('InstallReferrerService: Retrieved saved referral data: $jsonStr');
    return InstallReferrerData.fromJsonString(jsonStr);
  }

  @override
  Future<InstallReferrerData> simulateReferrer(String mockReferrer) async {
    appLogger.i(
      'InstallReferrerService: [SIMULATION] Simulating install referrer with payload: "$mockReferrer"',
    );
    final data = InstallReferrerData.fromRawReferrer(
      mockReferrer,
      clickTimestampSeconds: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      installTimestampSeconds: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    appLogger.i(
      'InstallReferrerService: [SIMULATION] Parsed simulation data -> refer: "${data.refer}", targetRoute: "${data.targetRoute}", hasReferral: ${data.hasReferral}',
    );
    await saveReferrerData(data);
    return data;
  }
}
