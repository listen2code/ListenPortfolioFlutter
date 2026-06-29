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
  Future<List<PlaybackTapeMetadata>> getTapes() async {
    try {
      final listJson = SpUtil.getString(AppConstants.playbackTapesListKey) ?? '[]';
      final List<dynamic> rawList = jsonDecode(listJson) as List<dynamic>;
      return rawList
          .map((e) => PlaybackTapeMetadata.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to load tapes: $e');
      return [];
    }
  }

  @override
  Future<void> saveTapes(List<PlaybackTapeMetadata> tapes) async {
    try {
      final jsonStr = jsonEncode(tapes.map((t) => t.toJson()).toList());
      await SpUtil.put(AppConstants.playbackTapesListKey, jsonStr);
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to save tapes: $e');
    }
  }

  @override
  Future<List<PlaybackStep>> getTapeSteps(String tapeKey) async {
    try {
      final tapeJson = SpUtil.getString(tapeKey);
      if (tapeJson == null) return [];
      final List<dynamic> rawSteps = jsonDecode(tapeJson) as List<dynamic>;
      return rawSteps.map((s) => PlaybackStep.fromJson(s as Map<String, dynamic>)).toList();
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to load steps for $tapeKey: $e');
      return [];
    }
  }

  @override
  Future<void> saveTape(String tapeKey, List<PlaybackStep> steps, PlaybackTapeMetadata metadata) async {
    try {
      // 1. Save detailed steps
      await SpUtil.put(tapeKey, jsonEncode(steps.map((s) => s.toJson()).toList()));

      // 2. Add metadata to tapes list and save
      final tapes = await getTapes();
      tapes.add(metadata);
      await saveTapes(tapes);
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to save tape $tapeKey: $e');
    }
  }

  @override
  Future<void> deleteTape(String tapeKey) async {
    try {
      // 1. Remove detailed step data
      await SpUtil.remove(tapeKey);

      // 2. Remove from metadata list
      final tapes = await getTapes();
      tapes.removeWhere((e) => e.key == tapeKey);
      await saveTapes(tapes);
    } catch (e) {
      appLogger.e('PlaybackTapeRepositoryImpl: Failed to delete tape $tapeKey: $e');
    }
  }
}
