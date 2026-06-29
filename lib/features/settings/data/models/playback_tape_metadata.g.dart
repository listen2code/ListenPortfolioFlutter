// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_tape_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaybackTapeMetadata _$PlaybackTapeMetadataFromJson(Map json) =>
    $checkedCreate('_PlaybackTapeMetadata', json, ($checkedConvert) {
      final val = _PlaybackTapeMetadata(
        key: $checkedConvert('key', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        timestamp: $checkedConvert('timestamp', (v) => (v as num).toInt()),
        steps: $checkedConvert('steps', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PlaybackTapeMetadataToJson(
  _PlaybackTapeMetadata instance,
) => <String, dynamic>{
  'key': instance.key,
  'name': instance.name,
  'timestamp': instance.timestamp,
  'steps': instance.steps,
};
