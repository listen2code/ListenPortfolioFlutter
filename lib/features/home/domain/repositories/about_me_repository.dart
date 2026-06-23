import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/about_me_model.dart';

abstract class AboutMeRepository {
  Future<Either<Failure, AboutMeModel>> getAboutMe();
  Future<Either<Failure, String>> getResumeMarkdown();
}
