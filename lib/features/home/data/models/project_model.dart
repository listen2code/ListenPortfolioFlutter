import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

@freezed
abstract class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    @ToStringConverter() String? id,
    String? title,
    String? subtitle,
    String? desc,
    String? imageUrl,
    String? githubUrl,
    @Default([]) List<String> techStack,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, Object?> json) => _$ProjectModelFromJson(json);
}
