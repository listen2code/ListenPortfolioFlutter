import 'package:dio/dio.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:retrofit/retrofit.dart';

part 'projects_remote_data_source.g.dart';

@RestApi()
abstract class ProjectsRemoteDataSource {
  factory ProjectsRemoteDataSource(Dio dio, {String baseUrl}) = _ProjectsRemoteDataSource;

  @GET('/v1/projects')
  @Extra({ApiClient.kNoAuthKey: true})
  Future<BaseResponseModel<List<ProjectModel>>> getProjects();
}
