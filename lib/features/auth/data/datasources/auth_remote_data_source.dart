import 'package:dio/dio.dart';
import 'package:listen_core/core.dart';
import '../models/change_password_request_model.dart';
import '../models/delete_account_request_model.dart';
import '../models/forgot_password_request_model.dart';
import '../models/login_model.dart';
import '../models/login_request_model.dart';
import '../models/signup_request_model.dart';
import '../models/user_model.dart';
import '../models/upload_avatar_request_model.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../shared/shared.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) = _AuthRemoteDataSource;

  @POST(ApiEndpoints.login)
  Future<BaseResponseModel<LoginModel>> login(@Body() LoginRequestModel? request);

  @POST(ApiEndpoints.signUp)
  Future<BaseResponseModel<void>> signUp(@Body() SignupRequestModel? request);

  @POST(ApiEndpoints.forgotPassword)
  Future<BaseResponseModel<void>> forgotPassword(@Body() ForgotPasswordRequestModel? request);

  @POST(ApiEndpoints.refreshToken)
  Future<BaseResponseModel<LoginModel>> refreshToken(@Query('refreshToken') String refreshToken);

  @POST(ApiEndpoints.logout)
  Future<BaseResponseModel<void>> logout();

  @POST(ApiEndpoints.changePassword)
  Future<BaseResponseModel<void>> changePassword(@Body() ChangePasswordRequestModel? request);

  @DELETE(ApiEndpoints.deleteAccount)
  Future<BaseResponseModel<void>> deleteAccount(@Body() DeleteAccountRequestModel? request);

  @GET(ApiEndpoints.getUser)
  Future<BaseResponseModel<UserModel>> getUserById(@Query('id') String id);

  @POST(ApiEndpoints.uploadAvatar)
  Future<BaseResponseModel<UserModel>> uploadAvatar(@Body() UploadAvatarRequestModel? request);
}
