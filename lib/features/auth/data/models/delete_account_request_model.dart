import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_request_model.freezed.dart';
part 'delete_account_request_model.g.dart';

@freezed
abstract class DeleteAccountRequestModel with _$DeleteAccountRequestModel {
  const factory DeleteAccountRequestModel({required String userId}) = _DeleteAccountRequestModel;

  factory DeleteAccountRequestModel.fromJson(Map<String, Object?> json) =>
      _$DeleteAccountRequestModelFromJson(json);
}
