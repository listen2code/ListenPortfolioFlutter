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

  /// Persists the detected referral data to local storage.
  Future<void> saveReferrerData(InstallReferrerData data);

  /// Retrieves previously saved referral data, if any.
  Future<InstallReferrerData?> getSavedReferrerData();

  /// Simulates an install referrer for development and testing.
  Future<InstallReferrerData> simulateReferrer(String mockReferrer);
}

/// Global provider for [IInstallReferrerService].
final installReferrerServiceProvider = Provider<IInstallReferrerService>((ref) {
  return InstallReferrerServiceImpl();
});

/// Default implementation of [IInstallReferrerService].
class InstallReferrerServiceImpl implements IInstallReferrerService {
  static const MethodChannel _channel = MethodChannel(AppConstants.methodChannelInstallReferrer);

  /// For unit testing overrides.
  static IInstallReferrerService? mockInstance;

  static IInstallReferrerService get instance => mockInstance ?? InstallReferrerServiceImpl();

  @override
  Future<InstallReferrerData> fetchInstallReferrer() async {
    // Install Referrer API is Android specific
    if (kIsWeb || !Platform.isAndroid) {
      return InstallReferrerData.empty;
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('getInstallReferrer');
      if (result == null) {
        return InstallReferrerData.empty;
      }

      final String raw = (result['installReferrer'] as String?) ?? '';
      final int? clickTimestamp = result['referrerClickTimestampSeconds'] as int?;
      final int? installTimestamp = result['installBeginTimestampSeconds'] as int?;
      final bool instant = (result['googlePlayInstant'] as bool?) ?? false;

      return InstallReferrerData.fromRawReferrer(
        raw,
        clickTimestampSeconds: clickTimestamp,
        installTimestampSeconds: installTimestamp,
        googlePlayInstant: instant,
      );
    } on PlatformException catch (e) {
      appLogger.w('InstallReferrerServiceImpl: Platform exception fetching install referrer: ${e.message}');
      return InstallReferrerData.empty;
    } catch (e, stack) {
      appLogger.e('InstallReferrerServiceImpl: Unexpected error fetching install referrer: $e',
          error: e, stackTrace: stack);
      return InstallReferrerData.empty;
    }
  }

  @override
  Future<bool> hasProcessedReferrer() async {
    return (SpUtil.get(AppConstants.hasCheckedInstallReferrerKey) as bool?) ?? false;
  }

  @override
  Future<void> markReferrerProcessed() async {
    await SpUtil.put(AppConstants.hasCheckedInstallReferrerKey, true);
  }

  @override
  Future<void> saveReferrerData(InstallReferrerData data) async {
    await SpUtil.put(AppConstants.savedInstallReferrerKey, data.toJsonString());
  }

  @override
  Future<InstallReferrerData?> getSavedReferrerData() async {
    final jsonStr = (SpUtil.get(AppConstants.savedInstallReferrerKey) as String?) ?? '';
    return InstallReferrerData.fromJsonString(jsonStr);
  }

  @override
  Future<InstallReferrerData> simulateReferrer(String mockReferrer) async {
    final data = InstallReferrerData.fromRawReferrer(
      mockReferrer,
      clickTimestampSeconds: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      installTimestampSeconds: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    await saveReferrerData(data);
    return data;
  }
}
