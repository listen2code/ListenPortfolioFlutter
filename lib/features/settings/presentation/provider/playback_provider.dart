import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/playback_tape_repository_impl.dart';
import '../../domain/repositories/playback_tape_repository.dart';
import '../../domain/usecases/delete_playback_tape_use_case.dart';
import '../../domain/usecases/get_playback_tape_steps_use_case.dart';
import '../../domain/usecases/get_playback_tapes_use_case.dart';

part 'playback_provider.g.dart';

@riverpod
PlaybackTapeRepository playbackTapeRepository(Ref ref) {
  return const PlaybackTapeRepositoryImpl();
}

@riverpod
GetPlaybackTapesUseCase getPlaybackTapesUseCase(Ref ref) {
  final repository = ref.watch(playbackTapeRepositoryProvider);
  return GetPlaybackTapesUseCase(repository);
}

@riverpod
GetPlaybackTapeStepsUseCase getPlaybackTapeStepsUseCase(Ref ref) {
  final repository = ref.watch(playbackTapeRepositoryProvider);
  return GetPlaybackTapeStepsUseCase(repository);
}

@riverpod
DeletePlaybackTapeUseCase deletePlaybackTapeUseCase(Ref ref) {
  final repository = ref.watch(playbackTapeRepositoryProvider);
  return DeletePlaybackTapeUseCase(repository);
}
