import 'package:dio/dio.dart';
import 'package:listen_core/core.dart';
import 'package:retrofit/retrofit.dart';

import '../models/ai_chat_request_model.dart';
import '../models/ai_chat_response_model.dart';
import '../models/ai_preset_qa_response_model.dart';

part 'ai_chat_remote_data_source.g.dart';

@RestApi()
abstract class AiChatRemoteDataSource {
  factory AiChatRemoteDataSource(Dio dio, {String baseUrl}) = _AiChatRemoteDataSource;

  @POST('/v1/ai/chat')
  Future<BaseResponseModel<AiChatResponseModel>> sendChatMessage(
    @Body() AiChatRequestModel? request,
  );

  @GET('/v1/ai/preset-qa')
  Future<BaseResponseModel<AiPresetQaResponseModel>> getPresetQAs(
    @Query('route') String? route,
  );
}
