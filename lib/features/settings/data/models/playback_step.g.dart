// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaybackStep _$PlaybackStepFromJson(Map json) =>
    $checkedCreate('_PlaybackStep', json, ($checkedConvert) {
      final val = _PlaybackStep(
        type: $checkedConvert('type', (v) => v as String),
        viewModelTag: $checkedConvert('viewModelTag', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        route: $checkedConvert('route', (v) => v as String?),
        timestamp: $checkedConvert('timestamp', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PlaybackStepToJson(_PlaybackStep instance) =>
    <String, dynamic>{
      'type': instance.type,
      'viewModelTag': instance.viewModelTag,
      'name': instance.name,
      'route': instance.route,
      'timestamp': instance.timestamp,
    };
