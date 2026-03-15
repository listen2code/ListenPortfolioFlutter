import 'dart:convert';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

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
        return AboutMeModel.fromJson(json.decode(jsonString));
      }
    } catch (e) {
      appLogger.e('AboutMeLocalDataSource: Failed to get cached about me: $e');
    }
    return null;
  }
}
