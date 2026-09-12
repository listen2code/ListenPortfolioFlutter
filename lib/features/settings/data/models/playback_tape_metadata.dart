import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_tape_metadata.freezed.dart';
part 'playback_tape_metadata.g.dart';

/// Lightweight index catalog entry summarizing a recorded MVI tape.
///
/// Storage Optimization Strategy:
/// - **Two-Tier Storage**: Detailed tape steps (which may contain large environment snapshots and hundreds of actions)
///   are stored under individual unique keys (`AppConstants.playbackTapeKey + timestamp`).
/// - **Fast Index Loading**: The tape list view loads only a lightweight list of [PlaybackTapeMetadata]
///   objects from `AppConstants.playbackTapesListKey`. This prevents reading and decoding megabytes
///   of JSON payload on screen launch, optimizing memory and rendering performance.
@freezed
abstract class PlaybackTapeMetadata with _$PlaybackTapeMetadata {
  const factory PlaybackTapeMetadata({
    /// Unique SharedPreferences key pointing to the detailed steps JSON array.
    required String key,

    /// Human-readable title of the tape (e.g. `LoginViewModel -> submit` or a user-specified custom name).
    required String name,

    /// Unix epoch timestamp in milliseconds when the tape was created.
    required int timestamp,

    /// Total count of steps contained within this tape.
    required int steps,
  }) = _PlaybackTapeMetadata;

  /// Creates a [PlaybackTapeMetadata] from a decoded JSON map.
  factory PlaybackTapeMetadata.fromJson(Map<String, dynamic> json) =>
      _$PlaybackTapeMetadataFromJson(json);
}

