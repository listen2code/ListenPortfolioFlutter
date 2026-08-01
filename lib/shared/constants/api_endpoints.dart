class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String login = '/v1/auth/login';
  static const String signUp = '/v1/auth/signUp';
  static const String forgotPassword = '/v1/auth/forgot-password';
  static const String refreshToken = '/v1/auth/refresh';

  // User endpoints
  static const String logout = '/v1/user/logout';
  static const String changePassword = '/v1/user/change-password';
  static const String deleteAccount = '/v1/user/delete-account';
  static const String getUser = '/v1/user';
  static const String uploadAvatar = '/v1/user/upload-avatar';

  // Projects endpoints
  static const String projects = '/v1/projects';

  // List of paths that allow anonymous/visitor access
  static const List<String> visitorPaths = [
    signUp,
    login,
    forgotPassword,
    refreshToken,
    projects,
  ];
}
