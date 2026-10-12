import 'package:flutter/foundation.dart';

/// Cryptographic identity and token bundle returned upon successful Google Sign-In authorization.
///
/// Complies with OpenID Connect (OIDC) Core 1.0 specifications.
@immutable
class GoogleAuthCredential {
  /// Base64URL-encoded cryptographically signed JSON Web Token (JWT) issued by Google Accounts.
  ///
  /// Contains the user's permanent subject identifier (`sub`), verified email, target audience (`aud`),
  /// and timestamp validity bounds (`exp`, `iat`).
  /// This token MUST be submitted to the backend Relying Party for server-side verification.
  final String idToken;

  /// Ephemeral OAuth 2.0 access token used to query Google APIs (e.g., People API, Drive API).
  final String? accessToken;

  /// User's verified Google primary email address.
  final String email;

  /// Human-readable display name (e.g., "Alex Hunter").
  final String? displayName;

  /// Hosted avatar image URL hosted by Google (Google User Content CDN).
  final String? photoUrl;

  /// One-time server authorization code exchanged for an offline refresh token when requested.
  final String? serverAuthCode;

  const GoogleAuthCredential({
    required this.idToken,
    this.accessToken,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.serverAuthCode,
  });

  factory GoogleAuthCredential.fromJson(Map<String, dynamic> json) {
    return GoogleAuthCredential(
      idToken: json['idToken'] as String? ?? '',
      accessToken: json['accessToken'] as String?,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      serverAuthCode: json['serverAuthCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'idToken': idToken,
        'accessToken': accessToken,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'serverAuthCode': serverAuthCode,
      };

  @override
  String toString() => 'GoogleAuthCredential(email: $email, idToken: ${idToken.isNotEmpty ? "***" : "empty"})';
}

/// Functional result monad wrapping the outcome of a Google Sign-In interaction.
@immutable
class GoogleSignInResult<T> {
  /// Whether the operation succeeded.
  final bool isSuccess;

  /// Whether the operation failed.
  bool get isFailure => !isSuccess;

  /// The resulting credential payload upon success.
  final T? data;

  /// Human-readable error message explaining failure rationale.
  final String? errorMessage;

  /// Standardized error classification code:
  /// - `USER_CANCELLED`: User dismissed the Google account picker without selecting an account.
  /// - `NETWORK_ERROR`: Network timeout or DNS resolution failure reaching Google OAuth endpoints.
  /// - `TOKEN_RETRIEVAL_FAILED`: Google Play Services returned null ID token (e.g. SHA-1 mismatch).
  /// - `SERVICE_UNAVAILABLE`: Google Play Services missing, disabled, or outdated on host device.
  /// - `INTERNAL_ERROR`: Unexpected platform exception.
  final String? errorCode;

  const GoogleSignInResult._({
    required this.isSuccess,
    this.data,
    this.errorMessage,
    this.errorCode,
  });

  /// Factory constructor for a successful outcome.
  factory GoogleSignInResult.success(T data) => GoogleSignInResult._(
        isSuccess: true,
        data: data,
      );

  /// Factory constructor for a failure outcome.
  factory GoogleSignInResult.failure(String message, [String? code]) => GoogleSignInResult._(
        isSuccess: false,
        errorMessage: message,
        errorCode: code,
      );
}

/// Abstract contract governing Federated Google OAuth 2.0 / OpenID Connect authentication.
///
/// ### Architecture & Design Rationale (Interface Segregation Principle):
/// Shields presentation ViewModels and repositories from concrete platform SDKs:
/// - Android: Google Credential Manager / Google Play Services (`com.google.android.gms.auth.api.signin`).
/// - iOS: GoogleSignIn-iOS CocoaPod (`GIDSignIn`).
/// - Web: Google Identity Services (GIS) JavaScript SDK (`google.accounts.id`).
/// - Sandbox / CI: Pure in-memory mock implementation ([MockGoogleSignInServiceImpl]).
abstract class GoogleSignInService {
  /// Probes whether Google Sign-In is available and ready on the current host runtime.
  ///
  /// On Android, checks if Google Play Services are installed and active.
  /// On Web, checks if the GIS script has loaded.
  Future<bool> isAvailable();

  /// Launches the native Google OAuth consent dialog or account selection bottom sheet.
  ///
  /// Upon user confirmation, retrieves the cryptographic [GoogleAuthCredential] containing
  /// the Google-signed `idToken`.
  Future<GoogleSignInResult<GoogleAuthCredential>> signIn();

  /// Clears the local sign-in state, forcing the user to select an account on the next attempt.
  Future<void> signOut();

  /// Revokes granted OAuth scopes and disconnects the application from the user's Google account.
  Future<void> disconnect();
}
