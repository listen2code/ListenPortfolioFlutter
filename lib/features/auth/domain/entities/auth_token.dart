/// Authentication token entity
class AuthToken {
  final String token;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthToken({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
