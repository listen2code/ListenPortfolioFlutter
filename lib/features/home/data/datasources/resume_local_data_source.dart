import 'package:listen_core/core.dart';
import '../../../../shared/shared.dart';

class ResumeLocalDataSource {
  Future<void> cacheResume(String markdownContent) async {
    try {
      await SpUtil.put(AppConstants.resumeKey, markdownContent);
    } catch (e) {
      appLogger.e('ResumeLocalDataSource: Failed to cache resume: $e');
    }
  }

  Future<String?> getCachedResume() async {
    try {
      return SpUtil.getString(AppConstants.resumeKey);
    } catch (e) {
      appLogger.e('ResumeLocalDataSource: Failed to get cached resume: $e');
    }
    return null;
  }
}
