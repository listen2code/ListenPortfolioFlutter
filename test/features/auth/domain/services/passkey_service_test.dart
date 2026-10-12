import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/services/passkey_service.dart';
import 'package:listen_portfolio_flutter/features/auth/data/services/mock_passkey_service_impl.dart';

void main() {
  group('PasskeyService Domain Models & Mock Implementation Tests', () {
    late MockPasskeyServiceImpl service;

    setUp(() {
      service = MockPasskeyServiceImpl();
    });

    test('isPasskeySupported returns true by default and false when hardware fails', () async {
      expect(await service.isPasskeySupported(), isTrue);

      service.setSimulateHardwareFailure(true);
      expect(await service.isPasskeySupported(), isFalse);
    });

    test('register successfully registers credential and parses clientDataJSON', () async {
      final options = PasskeyRegistrationOptions(
        challenge: 'test_reg_challenge_xyz',
        rp: const PasskeyRpEntity(id: 'portfolio.listen.io', name: 'Listen Portfolio'),
        user: const PasskeyUserEntity(
          id: 'user_1001',
          name: 'alex.investor@listen.io',
          displayName: 'Alex Investor',
        ),
        pubKeyCredParams: [PasskeyPubKeyCredParam.es256, PasskeyPubKeyCredParam.rs256],
        authenticatorAttachment: 'platform',
        userVerification: 'required',
      );

      final result = await service.register(options);
      expect(result.isSuccess, isTrue);

      final response = result.data!;
      expect(response.id, isNotEmpty);
      expect(response.rawId, equals(response.id));
      expect(response.attestationObject, isNotEmpty);

      // Verify clientDataJSON decoding
      final decodedClientData = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(response.clientDataJSON))),
      ) as Map<String, dynamic>;

      expect(decodedClientData['type'], equals('webauthn.create'));
      expect(decodedClientData['challenge'], equals('test_reg_challenge_xyz'));
      expect(decodedClientData['origin'], equals('https://portfolio.listen.io'));

      // Check registered credentials in service
      final storedCredentials = await service.getRegisteredCredentials();
      expect(storedCredentials.length, equals(1));
      expect(storedCredentials.first.userId, equals('user_1001'));
      expect(storedCredentials.first.counter, equals(0));
    });

    test('register fails when user cancels or hardware fails', () async {
      final options = PasskeyRegistrationOptions(
        challenge: 'challenge_1',
        rp: const PasskeyRpEntity(id: 'portfolio.listen.io', name: 'Listen'),
        user: const PasskeyUserEntity(id: 'u1', name: 'u1', displayName: 'U 1'),
      );

      service.setSimulateUserCancellation(true);
      final cancelResult = await service.register(options);
      expect(cancelResult.isFailure, isTrue);
      expect(cancelResult.errorCode, equals('USER_CANCELLED'));

      service.setSimulateUserCancellation(false);
      service.setSimulateHardwareFailure(true);
      final hardwareResult = await service.register(options);
      expect(hardwareResult.isFailure, isTrue);
      expect(hardwareResult.errorCode, equals('HARDWARE_UNAVAILABLE'));
    });

    test('authenticate verifies challenge and increments monotonic counter to prevent replay', () async {
      // 1. Register a credential first
      final regOptions = PasskeyRegistrationOptions(
        challenge: 'initial_registration_challenge',
        rp: const PasskeyRpEntity(id: 'portfolio.listen.io', name: 'Listen'),
        user: const PasskeyUserEntity(id: 'u2', name: 'u2@example.com', displayName: 'User Two'),
      );
      final regResult = await service.register(regOptions);
      final credentialId = regResult.data!.id;

      // 2. First assertion: counter should increment from 0 to 1
      final assertOptions1 = PasskeyAssertionOptions(
        challenge: 'login_challenge_session_1',
        rpId: 'portfolio.listen.io',
        allowedCredentialIds: [credentialId],
      );
      final assertResult1 = await service.authenticate(assertOptions1);
      expect(assertResult1.isSuccess, isTrue);
      expect(assertResult1.data!.id, equals(credentialId));

      var stored = await service.getRegisteredCredentials();
      expect(stored.first.counter, equals(1));

      // 3. Second assertion: counter should increment from 1 to 2
      final assertOptions2 = PasskeyAssertionOptions(
        challenge: 'login_challenge_session_2',
        rpId: 'portfolio.listen.io',
        allowedCredentialIds: [credentialId],
      );
      final assertResult2 = await service.authenticate(assertOptions2);
      expect(assertResult2.isSuccess, isTrue);

      stored = await service.getRegisteredCredentials();
      expect(stored.first.counter, equals(2));
      expect(stored.first.lastUsedAt, isNotNull);
    });

    test('authenticate returns error when credential does not exist', () async {
      final assertOptions = PasskeyAssertionOptions(
        challenge: 'unknown_challenge',
        rpId: 'portfolio.listen.io',
        allowedCredentialIds: ['non_existent_credential_id'],
      );

      final result = await service.authenticate(assertOptions);
      expect(result.isFailure, isTrue);
      expect(result.errorCode, equals('CREDENTIAL_NOT_FOUND'));
    });

    test('deleteCredential removes key successfully', () async {
      final regOptions = PasskeyRegistrationOptions(
        challenge: 'del_challenge',
        rp: const PasskeyRpEntity(id: 'portfolio.listen.io', name: 'Listen'),
        user: const PasskeyUserEntity(id: 'u3', name: 'u3@listen.io', displayName: 'U3'),
      );
      final regResult = await service.register(regOptions);
      final credId = regResult.data!.id;

      expect((await service.getRegisteredCredentials()).length, equals(1));

      final deleted = await service.deleteCredential(credId);
      expect(deleted, isTrue);
      expect((await service.getRegisteredCredentials()).isEmpty, isTrue);
    });
  });
}
