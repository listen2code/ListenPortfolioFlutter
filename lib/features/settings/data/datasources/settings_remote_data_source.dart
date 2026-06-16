import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/version_model.dart';

part 'settings_remote_data_source.g.dart';

@RestApi(baseUrl: 'https://raw.githubusercontent.com/listen2code/ListenPortfolioFlutter/main/')
abstract class SettingsRemoteDataSource {
  factory SettingsRemoteDataSource(Dio dio, {String baseUrl}) = _SettingsRemoteDataSource;

  @GET('version.json')
  Future<VersionModel> getLatestVersion();
}
