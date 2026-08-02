import 'package:listen_core/core.dart';
import '../../data/models/playback_step.dart';
import '../../data/models/playback_tape_metadata.dart';

/// Abstract contract for storing, retrieving, and deleting recorded tapes.
abstract class PlaybackTapeRepository {
  /// Retrieves the list of all recorded tapes.
  Future<Either<Failure, List<PlaybackTapeMetadata>>> getTapes();

  /// Saves the list of all recorded tapes.
  Future<Either<Failure, void>> saveTapes(List<PlaybackTapeMetadata> tapes);

  /// Retrieves the list of steps for a specific tape.
  Future<Either<Failure, List<PlaybackStep>>> getTapeSteps(String tapeKey);

  /// Saves both detailed step data and updates the tapes metadata list.
  Future<Either<Failure, void>> saveTape(String tapeKey, List<PlaybackStep> steps, PlaybackTapeMetadata metadata);

  /// Deletes a tape by key, removing both step details and metadata entry.
  Future<Either<Failure, void>> deleteTape(String tapeKey);
}
