import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_response_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/signup_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) = _AuthRemoteDataSource;

  @POST('/v1/auth/login')
  Future<BaseResponseModel<LoginResponseModel>> login(@Body() LoginRequestModel request);

  @POST('/v1/auth/signUp')
  Future<BaseResponseModel<void>> signUp(@Body() SignupRequestModel request);

  @POST('/v1/auth/logout')
  Future<BaseResponseModel<void>> logout();

  @POST('/v1/auth/forgot-password')
  Future<BaseResponseModel<void>> forgotPassword(@Field('email') String email);

  @POST('/v1/auth/change-password')
  Future<BaseResponseModel<void>> changePassword(
    @Field('oldPassword') String oldPassword,
    @Field('newPassword') String newPassword,
  );

  @GET('/v1/users/{id}')
  Future<BaseResponseModel<UserModel>> getUserById(@Path('id') String id);

  @POST('/v1/auth/refresh')
  Future<BaseResponseModel<LoginResponseModel>> refreshToken(@Field('refreshToken') String refreshToken);
}
