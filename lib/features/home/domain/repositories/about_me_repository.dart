import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';

abstract class AboutMeRepository {
  Future<Either<Failure, AboutMeModel>> getAboutMe();
}
