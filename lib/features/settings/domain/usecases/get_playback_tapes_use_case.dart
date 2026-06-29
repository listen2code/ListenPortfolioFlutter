import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/playback_tape_metadata.dart';
import '../repositories/playback_tape_repository.dart';

class GetPlaybackTapesUseCase implements UseCase<List<PlaybackTapeMetadata>, BaseParam> {
  final PlaybackTapeRepository repository;

  const GetPlaybackTapesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PlaybackTapeMetadata>>> call({BaseParam? param}) async {
    try {
      final tapes = await repository.getTapes();
      return Right(tapes);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
