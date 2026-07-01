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
    return repository.getTapeSteps(param);
  }
}
