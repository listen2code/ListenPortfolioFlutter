import 'package:listen_core/core.dart';
import '../../data/models/playback_step.dart';
import '../../data/models/playback_tape_metadata.dart';

/// Clean Architecture domain contract defining persistent tape catalog and step storage operations.
///
/// Design Philosophy:
/// - **Domain Purity**: Contains zero framework or I/O library dependencies (`dart:io`, `shared_preferences`, etc.),
///   enabling seamless mocking in unit and integration tests.
/// - **Functional Error Handling**: Every asynchronous operation returns an [Either<Failure, T>],
///   forcing callers to explicitly handle errors without unhandled exceptions crashing execution.
abstract class PlaybackTapeRepository {
  /// Retrieves the list of all recorded tape metadata headers.
  ///
  /// Returns a [Right] with `List<PlaybackTapeMetadata>` on success, or a [Left] with a [Failure]
  /// if storage read or JSON deserialization fails.
  Future<Either<Failure, List<PlaybackTapeMetadata>>> getTapes();

  /// Persists the entire updated list of tape metadata catalog headers.
  ///
  /// Used primarily after additions or deletions to synchronize the global tape index.
  Future<Either<Failure, void>> saveTapes(List<PlaybackTapeMetadata> tapes);

  /// Retrieves the chronological sequence of steps for a specific tape identified by [tapeKey].
  ///
  /// Returns an empty list if the tape key is not found, or a [Left] if JSON parsing fails.
  Future<Either<Failure, List<PlaybackStep>>> getTapeSteps(String tapeKey);

  /// Atomically saves both the detailed chronological [steps] under [tapeKey]
  /// and updates the global tape catalog index with the provided [metadata].
  Future<Either<Failure, void>> saveTape(String tapeKey, List<PlaybackStep> steps, PlaybackTapeMetadata metadata);

  /// Completely deletes a tape by [tapeKey].
  ///
  /// Purges both the detailed steps payload and removes the corresponding entry from the catalog index.
  Future<Either<Failure, void>> deleteTape(String tapeKey);
}

