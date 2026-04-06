import 'dart:convert';

import 'package:listen_core/core.dart';

import '../../../../shared/shared.dart';
import '../models/about_me_model.dart';

class AboutMeLocalDataSource {
  Future<void> cacheAboutMe(AboutMeModel data) async {
    try {
      await SpUtil.put(AppConstants.aboutMeDataKey, json.encode(data.toJson()));
    } catch (e) {
      appLogger.e('AboutMeLocalDataSource: Failed to cache about me: $e');
    }
  }

  Future<AboutMeModel?> getCachedAboutMe() async {
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
