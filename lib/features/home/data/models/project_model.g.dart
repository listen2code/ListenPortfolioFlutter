// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectModel _$ProjectModelFromJson(Map json) => $checkedCreate(
  '_ProjectModel',
  json,
  ($checkedConvert) {
    final val = _ProjectModel(
      id: $checkedConvert('id', (v) => v as String?),
      title: $checkedConvert('title', (v) => v as String?),
      subtitle: $checkedConvert('subtitle', (v) => v as String?),
      desc: $checkedConvert('desc', (v) => v as String?),
      imageUrl: $checkedConvert('imageUrl', (v) => v as String?),
      githubUrl: $checkedConvert('githubUrl', (v) => v as String?),
      techStack: $checkedConvert(
        'techStack',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$ProjectModelToJson(_ProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'desc': instance.desc,
      'imageUrl': instance.imageUrl,
      'githubUrl': instance.githubUrl,
      'techStack': instance.techStack,
    };
