import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../data/models/playback_tape_metadata.dart';

part 'playback_tape_list_state.freezed.dart';

@freezed
abstract class PlaybackTapeListState extends BaseState with _$PlaybackTapeListState {
  const factory PlaybackTapeListState({
    @Default(true) bool isLoading,
    @Default([]) List<PlaybackTapeMetadata> tapes,
  }) = _PlaybackTapeListState;

  const PlaybackTapeListState._();
}
