import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_step.freezed.dart';
part 'playback_step.g.dart';

@freezed
abstract class PlaybackStep with _$PlaybackStep {
  static const String intent = 'INTENT';
  static const String effect = 'EFFECT';

  const factory PlaybackStep({
    required String type,
    required String viewModelTag,
    required String name,
    String? route,
    required int timestamp,
  }) = _PlaybackStep;

  factory PlaybackStep.fromJson(Map<String, dynamic> json) =>
      _$PlaybackStepFromJson(json);
}
