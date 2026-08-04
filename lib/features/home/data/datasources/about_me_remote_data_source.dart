// ignore_for_file: one_member_abstracts
import 'package:dio/dio.dart';
import 'package:listen_core/core.dart';
import '../models/about_me_model.dart';
import 'package:retrofit/retrofit.dart';

part 'about_me_remote_data_source.g.dart';

@RestApi()
abstract class AboutMeRemoteDataSource {
  factory AboutMeRemoteDataSource(Dio dio, {String baseUrl}) = _AboutMeRemoteDataSource;

  @GET('/v1/aboutMe')
  Future<BaseResponseModel<AboutMeModel>> getAboutMe();
}
