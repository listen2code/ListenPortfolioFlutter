// ignore_for_file: one_member_abstracts
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../shared/shared.dart';

part 'settings_remote_data_source.g.dart';

@RestApi(baseUrl: AppConstants.githubPageRoot)
abstract class SettingsRemoteDataSource {
  factory SettingsRemoteDataSource(Dio dio, {String baseUrl}) = _SettingsRemoteDataSource;

  @GET('version.json')
  @Extra({ApiClient.kNoAuthKey: true})
  Future<String> getLatestVersion();
}
