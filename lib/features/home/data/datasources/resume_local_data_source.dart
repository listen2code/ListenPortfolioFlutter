import '../../../../shared/shared.dart';

class ResumeLocalDataSource implements CacheDataSource<String> {
  @override
  Future<void> cache(String data) async {
    try {
      await SpUtil.put(AppConstants.resumeKey, data);
    } catch (e) {
      appLogger.e('ResumeLocalDataSource: Failed to cache resume: $e');
    }
  }

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
