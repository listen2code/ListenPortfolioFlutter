import '../../../core/utils/logger.dart';
import '../../models/auth/login_request_model.dart';
import '../../models/auth/login_response_model.dart';
import '../../models/auth/signup_request_model.dart';
import '../../models/auth/user_model.dart';

/// Remote data source for authentication
/// Mock implementation that simulates API calls
class AuthRemoteDataSource {
  /// Mock login - simulates API call with delay
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    appLogger.d('AuthRemoteDataSource: login called with username: ${request.username}');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock successful response
    return LoginResponseModel(
      token: 'mock_jwt_token_12345',
      refreshToken: 'mock_refresh_token_67890',
      user: UserModel(id: '1', name: 'John Doe', email: 'john@example.com', avatarUrl: null, createdAt: DateTime.now()),
    );
  }

  /// Mock signup - simulates API call with delay
  Future<UserModel> signup(SignupRequestModel request) async {
    appLogger.d('AuthRemoteDataSource: signup called with email: ${request.email}');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock successful response
    return UserModel(id: '2', name: request.name, email: request.email, avatarUrl: null, createdAt: DateTime.now());
  }

  /// Mock logout - simulates API call
  Future<void> logout() async {
    appLogger.d('AuthRemoteDataSource: logout called');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Mock forgot password - simulates sending reset email
  Future<void> forgotPassword(String email) async {
    appLogger.d('AuthRemoteDataSource: forgotPassword called with email: $email');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Mock change password - simulates API call
  Future<void> changePassword(String oldPassword, String newPassword) async {
    appLogger.d('AuthRemoteDataSource: changePassword called');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Mock get current user - simulates API call
  Future<UserModel> getCurrentUser() async {
    appLogger.d('AuthRemoteDataSource: getCurrentUser called');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock response
    return UserModel(id: '1', name: 'John Doe', email: 'john@example.com', avatarUrl: null, createdAt: DateTime.now());
  }
}
