import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/change_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/forgot_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_response_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/signup_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) = _AuthRemoteDataSource;

  @POST('/v1/auth/login')
  Future<BaseResponseModel<LoginResponseModel>> login(@Body() LoginRequestModel? request);

  @POST('/v1/auth/signUp')
  Future<BaseResponseModel<void>> signUp(@Body() SignupRequestModel? request);

  @POST('/v1/auth/logout')
  Future<BaseResponseModel<void>> logout();

  @POST('/v1/auth/forgot-password')
  Future<BaseResponseModel<void>> forgotPassword(@Body() ForgotPasswordRequestModel? request);

  @POST('/v1/auth/change-password')
  Future<BaseResponseModel<void>> changePassword(@Body() ChangePasswordRequestModel? request);

  @GET('/v1/user')
  Future<BaseResponseModel<UserResponseModel>> getUserById(@Path('id') String id);

  @POST('/v1/auth/refresh')
  Future<BaseResponseModel<LoginResponseModel>> refreshToken(@Field('refreshToken') String refreshToken);
}
