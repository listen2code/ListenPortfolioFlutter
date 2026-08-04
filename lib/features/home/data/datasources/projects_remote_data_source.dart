// ignore_for_file: one_member_abstracts
import 'package:dio/dio.dart';
import '../models/project_model.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../shared/shared.dart';

part 'projects_remote_data_source.g.dart';

@RestApi()
abstract class ProjectsRemoteDataSource {
  factory ProjectsRemoteDataSource(Dio dio, {String baseUrl}) = _ProjectsRemoteDataSource;

  @GET(ApiEndpoints.projects)
  @Extra({ApiClient.kNoAuthKey: true})
  Future<BaseResponseModel<List<ProjectModel>>> getProjects();
}
