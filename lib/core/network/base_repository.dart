import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../core.dart';

mixin BaseRepository {
  /// Internal access to network info without injecting it into every repository.
  /// Create a new instance directly since it's lightweight and uses the Connectivity singleton internally.
  NetworkInfo get _networkInfo => NetworkInfoImpl(Connectivity());

  Future<Either<Failure, T>> safeCall<T>({required Future<BaseResponseModel<T>> Function() call}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await call();

      if (response.result == ApiResult.success) {
        return Right(response.body as T);
      } else if (response.result == ApiResult.sessionTimeout) {
        return Left(AuthFailure(response.message ?? 'Session expired'));
      } else if (response.result == ApiResult.serverError) {
        // Pass messageId to failure for better identification in UI/Logic layers
        return Left(ServerApiFailure(response.message ?? 'Server API Error', messageId: response.messageId));
      } else {
        return Left(ServerFailure(response.message ?? 'Unknown Server Error'));
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        final appEx = e.error as AppException;
        if (appEx is AuthException) return Left(AuthFailure(appEx.message));
        return Left(ServerFailure(appEx.message));
      }
      return Left(ServerFailure(e.message ?? 'Network Error'));
    } on TypeError catch (e) {
      appLogger.e('Data type mismatch: $e');
      return Left(ParseFailure('Unexpected data format from server'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
