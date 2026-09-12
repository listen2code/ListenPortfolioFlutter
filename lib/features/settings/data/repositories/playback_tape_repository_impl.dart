import 'dart:convert';
import 'package:listen_core/core.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../domain/repositories/playback_tape_repository.dart';
import '../models/playback_step.dart';
import '../models/playback_tape_metadata.dart';

/// Concrete data-layer implementation of [PlaybackTapeRepository] backed by [SpUtil].
///
/// Storage Architecture:
/// - **Global Catalog Key** ([AppConstants.playbackTapesListKey]): Stores a JSON array of [PlaybackTapeMetadata]
///   descriptors, providing rapid listing and deletion without loading heavy step payloads into memory.
/// - **Individual Tape Step Keys** ([AppConstants.playbackTapeKey] + timestamp): Stores the full JSON array
///   of serialized [PlaybackStep] objects, loaded on-demand only when a user inspects or executes a tape.
class PlaybackTapeRepositoryImpl implements PlaybackTapeRepository {
  const PlaybackTapeRepositoryImpl();

  @override
  Future<Either<Failure, List<PlaybackTapeMetadata>>> getTapes() async {
    try {
      final listJson = SpUtil.getString(AppConstants.playbackTapesListKey) ?? '[]';
      final List<dynamic> rawList = jsonDecode(listJson) as List<dynamic>;
      final tapes = rawList
          .map((e) => PlaybackTapeMetadata.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return Right(tapes);
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to load tapes: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTapes(List<PlaybackTapeMetadata> tapes) async {
    try {
      final jsonStr = jsonEncode(tapes.map((t) => t.toJson()).toList());
      await SpUtil.put(AppConstants.playbackTapesListKey, jsonStr);
      return const Right(null);
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to save tapes: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaybackStep>>> getTapeSteps(String tapeKey) async {
    try {
      final tapeJson = SpUtil.getString(tapeKey);
      if (tapeJson == null) return const Right([]);
      final List<dynamic> rawSteps = jsonDecode(tapeJson) as List<dynamic>;
      final steps = rawSteps.map((s) => PlaybackStep.fromJson(s as Map<String, dynamic>)).toList();
      return Right(steps);
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to load steps for $tapeKey: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTape(String tapeKey, List<PlaybackStep> steps, PlaybackTapeMetadata metadata) async {
    try {
      // Step 1: Persist detailed chronological step sequence under unique tape key
      await SpUtil.put(tapeKey, jsonEncode(steps.map((s) => s.toJson()).toList()));

      // Step 2: Append metadata header to the global catalog index
      final tapesEither = await getTapes();
      return await tapesEither.fold<Future<Either<Failure, void>>>(
        (failure) async => Left(failure),
        (tapes) async {
          final updatedTapes = List<PlaybackTapeMetadata>.from(tapes)..add(metadata);
          return await saveTapes(updatedTapes);
        },
      );
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to save tape $tapeKey: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTape(String tapeKey) async {
    try {
      // Step 1: Remove detailed step data payload from storage
      await SpUtil.remove(tapeKey);

      // Step 2: Filter out corresponding metadata entry from the global catalog index
      final tapesEither = await getTapes();
      return await tapesEither.fold<Future<Either<Failure, void>>>(
        (failure) async => Left(failure),
        (tapes) async {
          final updatedTapes = List<PlaybackTapeMetadata>.from(tapes)
            ..removeWhere((e) => e.key == tapeKey);
          return await saveTapes(updatedTapes);
        },
      );
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to delete tape $tapeKey: $e');
      return Left(CacheFailure(e.toString()));
    }
  }
}

