import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_response_model.freezed.dart';
part 'ai_chat_response_model.g.dart';

@freezed
abstract class AiChatResponseModel with _$AiChatResponseModel {
  const factory AiChatResponseModel({
    required String reply,
  }) = _AiChatResponseModel;

  factory AiChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AiChatResponseModelFromJson(json);
}
