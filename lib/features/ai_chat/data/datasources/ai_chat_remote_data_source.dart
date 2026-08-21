import 'package:dio/dio.dart';
import 'package:listen_core/core.dart';
import 'package:retrofit/retrofit.dart';

import '../models/ai_preset_qa_response_model.dart';

part 'ai_chat_remote_data_source.g.dart';

@RestApi()
// ignore: one_member_abstracts
abstract class AiChatRemoteDataSource {
  factory AiChatRemoteDataSource(Dio dio, {String baseUrl}) = _AiChatRemoteDataSource;

  @GET('/v1/ai/preset-qa')
  Future<BaseResponseModel<AiPresetQaResponseModel>> getPresetQAs(
    @Query('route') String? route,
  );
}
