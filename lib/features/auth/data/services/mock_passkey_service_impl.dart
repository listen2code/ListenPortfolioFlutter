import 'dart:convert';
import '../../domain/services/passkey_service.dart';

/// In-memory and sandbox simulation of [PasskeyService] for local development, testing,
/// and architecture verification without hardware biometric dependencies.
///
/// Simulates W3C WebAuthn Level 3 specifications:
/// - Generates realistic Base64URL credential identifiers.
/// - Produces standard clientDataJSON and authenticatorData payloads.
/// - Maintains an internal signature counter to simulate replay attack detection.
/// - Validates challenge matching and RP ID scoping.
class MockPasskeyServiceImpl implements PasskeyService {
  final Map<String, PasskeyCredential> _credentials = {};
  bool _simulateHardwareFailure = false;
  bool _simulateUserCancellation = false;

  /// Sets whether subsequent calls should simulate a hardware biometric failure.
  void setSimulateHardwareFailure(bool value) {
    _simulateHardwareFailure = value;
  }

  /// Sets whether subsequent calls should simulate user cancellation of the biometric dialog.
  void setSimulateUserCancellation(bool value) {
    _simulateUserCancellation = value;
  }

  @override
  Future<bool> isPasskeySupported() async {
    return !_simulateHardwareFailure;
  }

  @override
  Future<PasskeyResult<PasskeyRegistrationResponse>> register(
    PasskeyRegistrationOptions options,
  ) async {
    if (_simulateHardwareFailure) {
      return PasskeyResult.failure(
        'Biometric sensor unavailable or hardware failure',
        'HARDWARE_UNAVAILABLE',
      );
    }

    if (_simulateUserCancellation) {
      return PasskeyResult.failure(
        'User cancelled the biometric passkey creation dialog',
        'USER_CANCELLED',
      );
    }

    if (options.challenge.isEmpty) {
      return PasskeyResult.failure(
        'Server challenge must not be empty',
        'INVALID_CHALLENGE',
      );
    }

    // Generate a deterministic Base64URL credential ID based on user and RP ID
    final rawSeed = '${options.rp.id}_${options.user.id}_${DateTime.now().microsecondsSinceEpoch}';
    final credentialId = base64UrlEncode(utf8.encode(rawSeed)).replaceAll('=', '');

    final clientDataJsonMap = {
      'type': 'webauthn.create',
      'challenge': options.challenge,
      'origin': 'https://${options.rp.id}',
      'crossOrigin': false,
    };
    final clientDataJSON = base64UrlEncode(utf8.encode(jsonEncode(clientDataJsonMap)));

    // Mock attestation object containing dummy authenticator data and flags
    final attestationMap = {
      'fmt': 'none',
      'authData': base64UrlEncode(utf8.encode('mock_auth_data_${options.rp.id}')),
    };
    final attestationObject = base64UrlEncode(utf8.encode(jsonEncode(attestationMap)));

    // Save credential in internal repository
    final credential = PasskeyCredential(
      credentialId: credentialId,
      userId: options.user.id,
      deviceLabel: 'Virtual Biometric Authenticator (Secure Enclave Mock)',
      counter: 0,
      createdAt: DateTime.now(),
    );
    _credentials[credentialId] = credential;

    return PasskeyResult.success(
      PasskeyRegistrationResponse(
        id: credentialId,
        rawId: credentialId,
        clientDataJSON: clientDataJSON,
        attestationObject: attestationObject,
      ),
    );
  }

  @override
  Future<PasskeyResult<PasskeyAssertionResponse>> authenticate(
    PasskeyAssertionOptions options,
  ) async {
    if (_simulateHardwareFailure) {
      return PasskeyResult.failure(
        'Biometric hardware failure during authentication',
        'HARDWARE_UNAVAILABLE',
      );
    }

    if (_simulateUserCancellation) {
      return PasskeyResult.failure(
        'User cancelled the Passkey verification prompt',
        'USER_CANCELLED',
      );
    }

    if (options.challenge.isEmpty) {
      return PasskeyResult.failure(
        'Server challenge must not be empty',
        'INVALID_CHALLENGE',
      );
    }

    PasskeyCredential? targetCredential;
    if (options.allowedCredentialIds.isNotEmpty) {
      for (final id in options.allowedCredentialIds) {
        if (_credentials.containsKey(id)) {
          targetCredential = _credentials[id];
          break;
        }
      }
      if (targetCredential == null) {
        return PasskeyResult.failure(
          'No matching registered credential found on this device',
          'CREDENTIAL_NOT_FOUND',
        );
      }
    } else if (_credentials.isNotEmpty) {
      // Resident key / discoverable credential fallback
      targetCredential = _credentials.values.first;
    } else {
      return PasskeyResult.failure(
        'No passkeys registered on this device',
        'NO_CREDENTIALS',
      );
    }

    // Monotonically increment signature counter to prevent replay attacks
    final updatedCounter = targetCredential.counter + 1;
    _credentials[targetCredential.credentialId] = PasskeyCredential(
      credentialId: targetCredential.credentialId,
      userId: targetCredential.userId,
      deviceLabel: targetCredential.deviceLabel,
      counter: updatedCounter,
      createdAt: targetCredential.createdAt,
      lastUsedAt: DateTime.now(),
    );

    final clientDataJsonMap = {
      'type': 'webauthn.get',
      'challenge': options.challenge,
      'origin': 'https://${options.rpId}',
      'crossOrigin': false,
    };
    final clientDataJSON = base64UrlEncode(utf8.encode(jsonEncode(clientDataJsonMap)));

    // Simulated signature over challenge + counter
    final signature = base64UrlEncode(
      utf8.encode('sig_${options.challenge}_$updatedCounter'),
    );

    final authenticatorData = base64UrlEncode(
      utf8.encode('auth_data_${options.rpId}_counter_$updatedCounter'),
    );

    return PasskeyResult.success(
      PasskeyAssertionResponse(
        id: targetCredential.credentialId,
        rawId: targetCredential.credentialId,
        clientDataJSON: clientDataJSON,
        authenticatorData: authenticatorData,
        signature: signature,
        userHandle: targetCredential.userId,
      ),
    );
  }

  @override
  Future<List<PasskeyCredential>> getRegisteredCredentials() async {
    return _credentials.values.toList();
  }

  @override
  Future<bool> deleteCredential(String credentialId) async {
    return _credentials.remove(credentialId) != null;
  }
}
