// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VersionModel _$VersionModelFromJson(Map json) =>
    $checkedCreate('_VersionModel', json, ($checkedConvert) {
      final val = _VersionModel(
        version: $checkedConvert('version', (v) => v as String),
        buildNumber: $checkedConvert('buildNumber', (v) => (v as num).toInt()),
        url: $checkedConvert('url', (v) => v as String),
        changelog: $checkedConvert(
          'changelog',
          (v) => Map<String, String>.from(v as Map),
        ),
      );
      return val;
    });

Map<String, dynamic> _$VersionModelToJson(_VersionModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'buildNumber': instance.buildNumber,
      'url': instance.url,
      'changelog': instance.changelog,
    };
