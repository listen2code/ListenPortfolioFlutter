import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_tape_metadata.freezed.dart';
part 'playback_tape_metadata.g.dart';

@freezed
abstract class PlaybackTapeMetadata with _$PlaybackTapeMetadata {
  const factory PlaybackTapeMetadata({
    required String key,
    required String name,
    required int timestamp,
    required int steps,
  }) = _PlaybackTapeMetadata;

  factory PlaybackTapeMetadata.fromJson(Map<String, dynamic> json) =>
      _$PlaybackTapeMetadataFromJson(json);
}
