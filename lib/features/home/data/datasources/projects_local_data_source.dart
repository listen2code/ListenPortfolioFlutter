import 'dart:convert';

import '../models/project_model.dart';
import '../../../../shared/shared.dart';

/// ============================================================================
/// ProjectsLocalDataSource
/// ============================================================================
/// Local cache and persistence data source for project catalog items,
/// conforming to the unified [CacheDataSource] contract defined in `ListenCore`.
///
/// ### Architecture & Resiliency Pattern:
/// - **Offline-First Resilience**: Persists the serialized JSON list of [ProjectModel]
///   into persistent storage via [SpUtil] (backed by SharedPreferences).
/// - **Zero-Latency Fallback**: When network connectivity is severed or the remote
///   endpoint encounters a transient failure, [getCached] provides instant offline
///   data to prevent blocking user interactions or displaying empty screens.
/// - **Transparent Write-Behind**: Invoked automatically by [BaseRepository.safeCall]
///   upon successful remote HTTP responses, decoupling domain repositories from
///   manual cache synchronization glue code.
class ProjectsLocalDataSource implements CacheDataSource<List<ProjectModel>> {

  /// Persists a clean snapshot of [projects] into local storage as a JSON string.
  ///
  /// Serializes each [ProjectModel] into its JSON map representation, encodes
  /// the array, and writes it to [AppConstants.projectsDataKey]. If disk I/O
  /// or encoding throws an exception, the error is swallowed and logged to
  /// prevent interrupting the primary user flow.
  @override
  Future<void> cache(List<ProjectModel> projects) async {
    try {
      final jsonString = json.encode(projects.map((e) => e.toJson()).toList());
      await SpUtil.put(AppConstants.projectsDataKey, jsonString);
    } catch (e) {
      appLogger.e('ProjectsLocalDataSource: Failed to cache projects: $e');
    }
  }

  /// Retrieves and deserializes the cached project list from local storage.
  ///
  /// Returns a [List] of [ProjectModel] instances if valid cached JSON exists.
  /// If no cache entry is found, or if JSON deserialization encounters corrupted
  /// schema data, the error is captured, logged, and `null` is returned so that
  /// the calling repository can handle the cache-miss gracefully.
  @override
  Future<List<ProjectModel>?> getCached() async {
    try {
      final jsonString = SpUtil.getString(AppConstants.projectsDataKey);
      if (jsonString != null) {
        final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
        return decoded.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      appLogger.e('ProjectsLocalDataSource: Failed to get cached projects: $e');
    }
    return null;
  }
}
