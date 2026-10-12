import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/services/google_sign_in_service.dart';
import 'package:listen_portfolio_flutter/features/auth/data/services/mock_google_sign_in_service_impl.dart';

void main() {
  group('GoogleSignInService Domain Models & Mock Implementation Tests', () {
    late MockGoogleSignInServiceImpl service;

    setUp(() {
      service = MockGoogleSignInServiceImpl();
    });

    test('isAvailable returns true by default and false when service unavailable', () async {
      expect(await service.isAvailable(), isTrue);

      service.setSimulateUnavailable(true);
      expect(await service.isAvailable(), isFalse);
    });

    test('signIn returns valid GoogleAuthCredential with parseable JWT ID token', () async {
      service.setMockProfile(
        email: 'recruiter.google@listen.io',
        displayName: 'Google Recruiter Lead',
        photoUrl: 'https://lh3.googleusercontent.com/avatar123',
        sub: '98765432101234567890',
      );

      final result = await service.signIn();
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(service.isSignedIn, isTrue);

      final credential = result.data!;
      expect(credential.email, equals('recruiter.google@listen.io'));
      expect(credential.displayName, equals('Google Recruiter Lead'));
      expect(credential.photoUrl, equals('https://lh3.googleusercontent.com/avatar123'));
      expect(credential.accessToken, isNotEmpty);
      expect(credential.serverAuthCode, isNotEmpty);

      // Verify synthesized JWT structure: header.payload.signature
      final parts = credential.idToken.split('.');
      expect(parts.length, equals(3));

      // Decode and verify JWT payload
      final payloadJson = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      ) as Map<String, dynamic>;

      expect(payloadJson['iss'], equals('https://accounts.google.com'));
      expect(payloadJson['sub'], equals('98765432101234567890'));
      expect(payloadJson['email'], equals('recruiter.google@listen.io'));
      expect(payloadJson['email_verified'], isTrue);
    });

    test('signIn fails with USER_CANCELLED when user dismisses account picker', () async {
      service.setSimulateUserCancellation(true);

      final result = await service.signIn();
      expect(result.isFailure, isTrue);
      expect(result.errorCode, equals('USER_CANCELLED'));
      expect(result.errorMessage, contains('dismissed'));
      expect(service.isSignedIn, isFalse);
    });

    test('signIn fails with NETWORK_ERROR when connection times out', () async {
      service.setSimulateNetworkError(true);

      final result = await service.signIn();
      expect(result.isFailure, isTrue);
      expect(result.errorCode, equals('NETWORK_ERROR'));
      expect(result.errorMessage, contains('Network connection timed out'));
    });

    test('signIn fails with SERVICE_UNAVAILABLE when Google Play Services missing', () async {
      service.setSimulateUnavailable(true);

      final result = await service.signIn();
      expect(result.isFailure, isTrue);
      expect(result.errorCode, equals('SERVICE_UNAVAILABLE'));
    });

    test('signOut and disconnect clear internal sign-in state', () async {
      await service.signIn();
      expect(service.isSignedIn, isTrue);

      await service.signOut();
      expect(service.isSignedIn, isFalse);

      await service.signIn();
      expect(service.isSignedIn, isTrue);

      await service.disconnect();
      expect(service.isSignedIn, isFalse);
    });

    test('GoogleAuthCredential serialization roundtrip matches original', () {
      const original = GoogleAuthCredential(
        idToken: 'sample.jwt.token',
        accessToken: 'access_123',
        email: 'dev@listen.io',
        displayName: 'Developer',
        photoUrl: 'https://example.com/avatar.png',
        serverAuthCode: 'auth_code_xyz',
      );

      final json = original.toJson();
      final restored = GoogleAuthCredential.fromJson(json);

      expect(restored.idToken, equals(original.idToken));
      expect(restored.accessToken, equals(original.accessToken));
      expect(restored.email, equals(original.email));
      expect(restored.displayName, equals(original.displayName));
      expect(restored.photoUrl, equals(original.photoUrl));
      expect(restored.serverAuthCode, equals(original.serverAuthCode));
    });
  });
}
