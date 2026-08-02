import 'dart:convert';
import 'package:listen_core/core.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../domain/repositories/playback_tape_repository.dart';
import '../models/playback_step.dart';
import '../models/playback_tape_metadata.dart';

/// Concrete implementation of [PlaybackTapeRepository] using [SpUtil] for persistent storage.
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
      // 1. Save detailed steps
      await SpUtil.put(tapeKey, jsonEncode(steps.map((s) => s.toJson()).toList()));

      // 2. Add metadata to tapes list and save
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
      // 1. Remove detailed step data
      await SpUtil.remove(tapeKey);

      // 2. Remove from metadata list
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
