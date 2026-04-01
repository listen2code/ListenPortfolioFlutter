import 'dart:convert';

import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

class ProjectsLocalDataSource {
  Future<void> cacheProjects(List<ProjectModel> projects) async {
    try {
      final jsonString = json.encode(projects.map((e) => e.toJson()).toList());
      await SpUtil.put(AppConstants.projectsDataKey, jsonString);
    } catch (e) {
      appLogger.e('ProjectsLocalDataSource: Failed to cache projects: $e');
    }
  }

  Future<List<ProjectModel>?> getCachedProjects() async {
    try {
      final jsonString = SpUtil.getString(AppConstants.projectsDataKey);
      if (jsonString != null) {
        final List<dynamic> decoded = json.decode(jsonString);
        return decoded.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      appLogger.e('ProjectsLocalDataSource: Failed to get cached projects: $e');
    }
    return null;
  }
}
