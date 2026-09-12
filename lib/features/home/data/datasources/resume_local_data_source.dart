import '../../../../shared/shared.dart';

/// ============================================================================
/// ResumeLocalDataSource
/// ============================================================================
/// Local cache and persistence data source for raw Markdown resume content,
/// conforming to the [CacheDataSource<String>] contract defined in `ListenCore`.
///
/// ### Architecture & Resiliency Pattern:
/// - **Text Persistence**: Stores unparsed Markdown text directly in [SpUtil]
///   without JSON serialization overhead, optimizing read/write throughput.
/// - **Instant Offline Document Rendering**: Guarantees that the PDF generation
///   engine and interactive resume view can instantly render the document on
///   cold launch even when the device is completely offline.
/// - **Clearable Cache Boundary**: The stored key [AppConstants.resumeKey] is
///   automatically wiped upon user logout inside [AuthLocalDataSource.clearAuthData],
///   preventing confidential resume data from leaking across sessions.
class ResumeLocalDataSource implements CacheDataSource<String> {

  /// Persists the raw Markdown [data] string into local storage.
  @override
  Future<void> cache(String data) async {
    try {
      await SpUtil.put(AppConstants.resumeKey, data);
    } catch (e) {
      appLogger.e('ResumeLocalDataSource: Failed to cache resume: $e');
    }
  }

  /// Retrieves the cached raw Markdown resume string from local storage.
  ///
  /// Returns `null` if no cached document exists or on read failure.
  @override
  Future<String?> getCached() async {
    try {
      return SpUtil.getString(AppConstants.resumeKey);
    } catch (e) {
      appLogger.e('ResumeLocalDataSource: Failed to get cached resume: $e');
    }
    return null;
  }
}
