import 'package:listen_core/core.dart';
import '../repositories/about_me_repository.dart';

/// ============================================================================
/// GetResumeUseCase
/// ============================================================================
/// Clean Architecture domain use case for retrieving the author's Markdown resume.
///
/// Encapsulates the business requirement of fetching resume content, decoupling
/// the presentation layer ([ResumeViewModel]) from the underlying data source
/// and repository implementation ([AboutMeRepository]).
class GetResumeUseCase implements UseCase<String, BaseParam> {
  final AboutMeRepository repository;

  GetResumeUseCase(this.repository);

  /// Executes the retrieval of resume Markdown text with automated offline caching.
  ///
  /// Returns a [Right] containing the raw Markdown string upon success or cache hit,
  /// or a [Left] containing a domain [Failure] if both remote and local sources fail.
  @override
  Future<Either<Failure, String>> call({BaseParam? param}) async {
    return await repository.getResumeMarkdown();
  }
}
