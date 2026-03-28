import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/change_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/delete_account_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/forgot_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/signup_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) = _AuthRemoteDataSource;

  @POST(ApiClient.login)
  Future<BaseResponseModel<LoginModel>> login(@Body() LoginRequestModel? request);

  @POST(ApiClient.signUp)
  Future<BaseResponseModel<void>> signUp(@Body() SignupRequestModel? request);

  @POST((ApiClient.forgotPassword))
  Future<BaseResponseModel<void>> forgotPassword(@Body() ForgotPasswordRequestModel? request);

  @POST(ApiClient.refreshToken)
  Future<BaseResponseModel<LoginModel>> refreshToken(@Field('refreshToken') String refreshToken);

  @POST('/v1/user/logout')
  Future<BaseResponseModel<void>> logout();

  @POST('/v1/user/change-password')
  Future<BaseResponseModel<void>> changePassword(@Body() ChangePasswordRequestModel? request);

  @DELETE('/v1/user/delete-account')
  Future<BaseResponseModel<void>> deleteAccount(@Body() DeleteAccountRequestModel? request);

  @GET('/v1/user')
  Future<BaseResponseModel<UserModel>> getUserById(@Query('id') String id);
}
