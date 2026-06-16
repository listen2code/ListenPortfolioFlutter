import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
abstract class VersionModel with _$VersionModel {
  const factory VersionModel({
    required String version,
    required int buildNumber,
    required String url,
    required Map<String, String> changelog,
  }) = _VersionModel;

  factory VersionModel.fromJson(Map<String, dynamic> json) => _$VersionModelFromJson(json);
}
