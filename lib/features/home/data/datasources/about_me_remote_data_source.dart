import 'package:dio/dio.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:retrofit/retrofit.dart';

part 'about_me_remote_data_source.g.dart';

@RestApi()
abstract class AboutMeRemoteDataSource {
  factory AboutMeRemoteDataSource(Dio dio, {String baseUrl}) = _AboutMeRemoteDataSource;

  @GET('/v1/aboutMe')
  Future<BaseResponseModel<AboutMeModel>> getAboutMe();
}
