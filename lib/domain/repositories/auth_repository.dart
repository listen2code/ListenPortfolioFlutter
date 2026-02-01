import 'package:fpdart/fpdart.dart';

import '../../core/errors/failures.dart';
import '../entities/auth/user.dart';

/// Repository interface for authentication operations
/// This defines the contract that the data layer must implement
abstract class AuthRepository {
  /// Login with username and password
  Future<Either<Failure, User>> login({required String username, required String password});

  /// Register a new user
  Future<Either<Failure, User>> register({required String name, required String email, required String password});

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Send password reset email
  Future<Either<Failure, void>> forgotPassword({required String email});

  /// Change user password
  Future<Either<Failure, void>> changePassword({required String oldPassword, required String newPassword});

  /// Get currently logged in user from cache
  Future<Either<Failure, User?>> getCurrentUser();
}
