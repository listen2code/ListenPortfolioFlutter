import 'dart:convert';


import '../../../../shared/shared.dart';
import '../models/about_me_model.dart';

/// ============================================================================
/// AboutMeLocalDataSource
/// ============================================================================
/// Local cache and persistence data source for author profile and biography metadata,
/// conforming to the unified [CacheDataSource] contract defined in `ListenCore`.
///
/// ### Architecture & Resiliency Pattern:
/// - **Offline-First Resilience**: Stores the serialized JSON object of [AboutMeModel]
///   in local key-value storage via [SpUtil] (backed by SharedPreferences).
/// - **Zero-Latency Fallback**: When the application runs in airplane mode, subway/tunnel
///   disconnected environments, or when the remote profile service is temporarily
///   unavailable, [getCached] provides instant offline data to avoid rendering
///   uninformative error states.
/// - **Safe Error Boundary**: Serializing or deserializing errors are caught and logged
///   defensively, returning `null` on corruption to prevent application aborts.
class AboutMeLocalDataSource implements CacheDataSource<AboutMeModel> {

  /// Persists a clean snapshot of [data] into local storage as a JSON string.
  ///
  /// Serializes [data] into a JSON map, encodes it to string format, and saves
  /// it under [AppConstants.aboutMeDataKey]. Any I/O or encoding errors are logged
  /// without disrupting the calling execution path.
  @override
  Future<void> cache(AboutMeModel data) async {
    try {
      await SpUtil.put(AppConstants.aboutMeDataKey, json.encode(data.toJson()));
    } catch (e) {
      appLogger.e('AboutMeLocalDataSource: Failed to cache about me: $e');
    }
  }

  /// Retrieves and deserializes the cached profile snapshot from local storage.
  ///
  /// Returns an [AboutMeModel] if valid cached JSON exists. Returns `null` if the
  /// key does not exist or if schema decoding fails.
  @override
  Future<AboutMeModel?> getCached() async {
    try {
      final jsonString = SpUtil.getString(AppConstants.aboutMeDataKey);
      if (jsonString != null) {
        return AboutMeModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
      }
    } catch (e) {
      appLogger.e('AboutMeLocalDataSource: Failed to get cached about me: $e');
    }
    return null;
  }
}
