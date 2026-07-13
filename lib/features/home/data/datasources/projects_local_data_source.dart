import 'dart:convert';

import 'package:listen_core/core.dart';
import '../models/project_model.dart';
import '../../../../shared/shared.dart';

class ProjectsLocalDataSource implements CacheDataSource<List<ProjectModel>> {

  @override
  Future<void> cache(List<ProjectModel> projects) async {
    try {
      final jsonString = json.encode(projects.map((e) => e.toJson()).toList());
      await SpUtil.put(AppConstants.projectsDataKey, jsonString);
    } catch (e) {
      appLogger.e('ProjectsLocalDataSource: Failed to cache projects: $e');
    }
  }

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
