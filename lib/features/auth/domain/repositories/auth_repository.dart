import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_response_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';

/// Repository interface for authentication operations.
/// This defines the contract that the data layer must implement.
abstract class AuthRepository {
  /// Login with username and password.
  Future<Either<Failure, LoginResponseModel?>> login({required String username, required String password});

  /// Sign Up a new user.
  Future<Either<Failure, void>> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Logout current user.
  Future<Either<Failure, void>> logout();

  /// Send password reset email.
  Future<Either<Failure, void>> forgotPassword({required String email});

  /// Change user password.
  Future<Either<Failure, void>> changePassword({required String oldPassword, required String newPassword});

  /// Fetches the authenticated user's profile by ID.
  Future<Either<Failure, UserModel?>> getCurrentUser({required String userId});

  /// Refreshes the authentication token using the stored refresh token.
  /// Returns the new access token if successful.
  Future<Either<Failure, String>> refreshToken();
}
