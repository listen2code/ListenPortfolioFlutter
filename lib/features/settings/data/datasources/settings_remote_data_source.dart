import 'package:dio/dio.dart';
import 'package:listen_core/core.dart';
import 'package:retrofit/retrofit.dart';

part 'settings_remote_data_source.g.dart';

@RestApi(baseUrl: 'https://raw.githubusercontent.com/listen2code/ListenPortfolioFlutter/')
abstract class SettingsRemoteDataSource {
  factory SettingsRemoteDataSource(Dio dio, {String baseUrl}) = _SettingsRemoteDataSource;

  @GET('main/version.json')
  @Extra({ApiClient.kNoAuthKey: true})
  Future<String> getLatestVersion();
}
