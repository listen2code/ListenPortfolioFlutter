// ignore_for_file: one_member_abstracts
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'resume_remote_data_source.g.dart';

/// ============================================================================
/// ResumeRemoteDataSource
/// ============================================================================
/// Retrofit-based remote HTTP client for fetching the raw Markdown resume.
///
/// ### Architecture & CDN Pattern:
/// - Pulls raw plain-text Markdown directly from GitHub Raw / CDN endpoints.
/// - Integrated with [AboutMeRepositoryImpl] and wrapped into a synthetic
///   `BaseResponseModel<String>` to leverage `BaseRepository.safeCall` for
///   automatic offline caching and resilient error handling.
@RestApi(baseUrl: 'https://raw.githubusercontent.com/listen2code/ListenPortfolioFlutter/')
abstract class ResumeRemoteDataSource {
  factory ResumeRemoteDataSource(Dio dio, {String baseUrl}) = _ResumeRemoteDataSource;

  /// Fetches the latest published Markdown document.
  @GET('main/README.md')
  Future<String> getResumeMarkdown();
}
