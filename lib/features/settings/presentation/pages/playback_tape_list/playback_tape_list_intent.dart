import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_registry_init.dart';

part 'playback_tape_list_intent.freezed.dart';

@freezed
class PlaybackTapeListIntent extends BaseIntent with _$PlaybackTapeListIntent {
  const factory PlaybackTapeListIntent.loadTapes() = _LoadTapes;
  const factory PlaybackTapeListIntent.deleteTape(String tapeKey) = _DeleteTape;
  const factory PlaybackTapeListIntent.confirmDeleteTape(String tapeKey) = _ConfirmDeleteTape;
  const factory PlaybackTapeListIntent.startPlayback(String tapeKey) = _StartPlayback;
  const factory PlaybackTapeListIntent.showTapeDetails(String tapeKey, String tapeName) = _ShowTapeDetails;
  const PlaybackTapeListIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register(
      'PlaybackTapeListIntent',
      'loadTapes',
      (args) => const PlaybackTapeListIntent.loadTapes(),
    );
    MviPlaybackRegistry.register(
      'PlaybackTapeListIntent',
      'deleteTape',
      (args) => PlaybackTapeListIntent.deleteTape(args['tapeKey'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'PlaybackTapeListIntent',
      'confirmDeleteTape',
      (args) => PlaybackTapeListIntent.confirmDeleteTape(args['tapeKey'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'PlaybackTapeListIntent',
      'startPlayback',
      (args) => PlaybackTapeListIntent.startPlayback(args['tapeKey'] ?? ''),
    );
    MviPlaybackRegistry.register(
      'PlaybackTapeListIntent',
      'showTapeDetails',
      (args) => PlaybackTapeListIntent.showTapeDetails(
        args['tapeKey'] ?? '',
        args['tapeName'] ?? '',
      ),
    );
  }
}
