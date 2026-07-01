import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../repositories/playback_tape_repository.dart';

class DeletePlaybackTapeUseCase implements UseCase<void, String> {
  final PlaybackTapeRepository repository;

  const DeletePlaybackTapeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return const Left(ValidationFailure('Tape key cannot be empty'));
    }
    return repository.deleteTape(param);
  }
}
