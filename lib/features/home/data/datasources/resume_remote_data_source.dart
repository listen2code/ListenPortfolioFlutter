// ignore_for_file: one_member_abstracts
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'resume_remote_data_source.g.dart';

@RestApi(baseUrl: 'https://raw.githubusercontent.com/listen2code/ListenPortfolioFlutter/')
abstract class ResumeRemoteDataSource {
  factory ResumeRemoteDataSource(Dio dio, {String baseUrl}) = _ResumeRemoteDataSource;

  @GET('main/README.md')
  Future<String> getResumeMarkdown();
}
