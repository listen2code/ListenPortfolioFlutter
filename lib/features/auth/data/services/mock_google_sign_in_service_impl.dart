import 'dart:convert';
import '../../domain/services/google_sign_in_service.dart';

/// Sandbox in-memory simulation of [GoogleSignInService] for local development, testing,
/// and automated CI/CD pipelines without physical Google Play Services or OAuth client ID configurations.
///
/// Features:
/// - Synthesizes realistic OIDC JWT ID Tokens containing standard claims (`sub`, `email`, `aud`, `iss`).
/// - Simulates user cancellation of account picker dialog.
/// - Simulates network timeouts and Google Play Services unreadiness.
class MockGoogleSignInServiceImpl implements GoogleSignInService {
  bool _simulateUserCancellation = false;
  bool _simulateNetworkError = false;
  bool _simulateUnavailable = false;
  bool _isSignedIn = false;

  String _mockEmail = 'recruiter.google@listen.io';
  String _mockDisplayName = 'Sarah Jenkins (Tech Lead Recruiter)';
  String _mockPhotoUrl = 'https://lh3.googleusercontent.com/a/default-user';
  String _mockSub = '109823471092834710928';

  /// Configures whether subsequent calls to [signIn] simulate user dismissal of the account picker.
  void setSimulateUserCancellation(bool value) {
    _simulateUserCancellation = value;
  }

  /// Configures whether subsequent calls to [signIn] simulate network transmission failures.
  void setSimulateNetworkError(bool value) {
    _simulateNetworkError = value;
  }

  /// Configures whether Google Play Services are simulated as absent or outdated.
  void setSimulateUnavailable(bool value) {
    _simulateUnavailable = value;
  }

  /// Configures mock profile properties returned upon successful authorization.
  void setMockProfile({
    required String email,
    required String displayName,
    String? photoUrl,
    String? sub,
  }) {
    _mockEmail = email;
    _mockDisplayName = displayName;
    if (photoUrl != null) _mockPhotoUrl = photoUrl;
    if (sub != null) _mockSub = sub;
  }

  @override
  Future<bool> isAvailable() async {
    return !_simulateUnavailable;
  }

  @override
  Future<GoogleSignInResult<GoogleAuthCredential>> signIn() async {
    if (_simulateUnavailable) {
      return GoogleSignInResult.failure(
        'Google Play Services unavailable on this device',
        'SERVICE_UNAVAILABLE',
      );
    }

    if (_simulateUserCancellation) {
      return GoogleSignInResult.failure(
        'User dismissed Google Account Picker',
        'USER_CANCELLED',
      );
    }

    if (_simulateNetworkError) {
      return GoogleSignInResult.failure(
        'Network connection timed out reaching Google OAuth 2.0 servers',
        'NETWORK_ERROR',
      );
    }

    // Synthesize realistic base64url-encoded JWT ID Token
    final header = {'alg': 'RS256', 'kid': 'mock_google_key_001', 'typ': 'JWT'};
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final payload = {
      'iss': 'https://accounts.google.com',
      'sub': _mockSub,
      'azp': 'mock-android-client-id.apps.googleusercontent.com',
      'aud': 'mock-web-client-id.apps.googleusercontent.com',
      'email': _mockEmail,
      'email_verified': true,
      'name': _mockDisplayName,
      'picture': _mockPhotoUrl,
      'iat': now,
      'exp': now + 3600,
    };

    final headerB64 = base64UrlEncode(utf8.encode(jsonEncode(header))).replaceAll('=', '');
    final payloadB64 = base64UrlEncode(utf8.encode(jsonEncode(payload))).replaceAll('=', '');
    final signatureB64 = base64UrlEncode(utf8.encode('mock_sig_${headerB64}_$payloadB64')).replaceAll('=', '');

    final synthesizedIdToken = '$headerB64.$payloadB64.$signatureB64';

    _isSignedIn = true;

    final credential = GoogleAuthCredential(
      idToken: synthesizedIdToken,
      accessToken: 'mock_access_token_google_api_$now',
      email: _mockEmail,
      displayName: _mockDisplayName,
      photoUrl: _mockPhotoUrl,
      serverAuthCode: 'mock_server_auth_code_$now',
    );

    return GoogleSignInResult.success(credential);
  }

  @override
  Future<void> signOut() async {
    _isSignedIn = false;
  }

  @override
  Future<void> disconnect() async {
    _isSignedIn = false;
  }

  /// Whether the user is currently signed in to the mock service.
  bool get isSignedIn => _isSignedIn;
}
