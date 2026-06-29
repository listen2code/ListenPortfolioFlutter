import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'playback_tape_list_intent.freezed.dart';

@freezed
class PlaybackTapeListIntent extends BaseIntent with _$PlaybackTapeListIntent {
  const factory PlaybackTapeListIntent.loadTapes() = _LoadTapes;
  const factory PlaybackTapeListIntent.deleteTape(String tapeKey) = _DeleteTape;
  const factory PlaybackTapeListIntent.startPlayback(String tapeKey) = _StartPlayback;
  const factory PlaybackTapeListIntent.showTapeDetails(String tapeKey, String tapeName) = _ShowTapeDetails;
  const PlaybackTapeListIntent._();
}
