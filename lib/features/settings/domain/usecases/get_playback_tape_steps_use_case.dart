import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/playback_step.dart';
import '../repositories/playback_tape_repository.dart';

class GetPlaybackTapeStepsUseCase implements UseCase<List<PlaybackStep>, String> {
  final PlaybackTapeRepository repository;

  const GetPlaybackTapeStepsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PlaybackStep>>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return const Left(ValidationFailure('Tape key cannot be empty'));
    }
    try {
      final steps = await repository.getTapeSteps(param);
      return Right(steps);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
