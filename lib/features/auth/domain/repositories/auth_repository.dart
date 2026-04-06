import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/change_password_request_model.dart';
import '../../data/models/delete_account_request_model.dart';
import '../../data/models/forgot_password_request_model.dart';
import '../../data/models/get_current_user_request_model.dart';
import '../../data/models/login_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/signup_request_model.dart';
import '../../data/models/user_model.dart';

/// Repository interface for authentication operations.
/// This defines the contract that the data layer must implement.
abstract class AuthRepository {
  /// Login with username and password.
  Future<Either<Failure, LoginModel?>> login({required LoginRequestModel? param});

  /// Sign Up a new user.
  Future<Either<Failure, void>> signUp({required SignupRequestModel? param});

  /// Logout current user.
  Future<Either<Failure, void>> logout();

  /// Send password reset email.
  Future<Either<Failure, void>> forgotPassword({required ForgotPasswordRequestModel? param});

  /// Change user password.
  Future<Either<Failure, void>> changePassword({required ChangePasswordRequestModel? param});

  /// Delete account.
  Future<Either<Failure, void>> deleteAccount({required DeleteAccountRequestModel? param});

  /// Fetches the authenticated user's profile by ID.
  Future<Either<Failure, UserModel?>> getCurrentUser({required GetCurrentUserRequestModel? param});

  /// Refreshes the authentication token using the stored refresh token.
  /// Returns the new access token if successful.
  Future<Either<Failure, String>> refreshToken();
}
