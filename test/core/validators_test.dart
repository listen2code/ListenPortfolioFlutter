import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';

void main() {
  group('Validators', () {
    // ──────────────────────────────────────────
    // validateEmail
    // ──────────────────────────────────────────
    group('validateEmail', () {
      const required = 'Email is required';
      const invalid = 'Invalid email';

      test('returns requiredMsg when value is null', () {
        expect(Validators.validateEmail(null, requiredMsg: required, invalidMsg: invalid), required);
      });

      test('returns requiredMsg when value is empty', () {
        expect(Validators.validateEmail('', requiredMsg: required, invalidMsg: invalid), required);
      });

      test('returns invalidMsg for plain string without @', () {
        expect(Validators.validateEmail('notanemail', requiredMsg: required, invalidMsg: invalid), invalid);
      });

      test('returns invalidMsg for missing domain', () {
        expect(Validators.validateEmail('user@', requiredMsg: required, invalidMsg: invalid), invalid);
      });

      test('returns invalidMsg for missing TLD', () {
        expect(Validators.validateEmail('user@domain', requiredMsg: required, invalidMsg: invalid), invalid);
      });

      test('returns null for valid email', () {
        expect(
          Validators.validateEmail('user@example.com', requiredMsg: required, invalidMsg: invalid),
          isNull,
        );
      });

      test('returns null for email with subdomain', () {
        expect(
          Validators.validateEmail('user@mail.example.co.jp', requiredMsg: required, invalidMsg: invalid),
          isNull,
        );
      });

      test('returns null for email with plus sign', () {
        expect(
          Validators.validateEmail('user+tag@example.com', requiredMsg: required, invalidMsg: invalid),
          isNull,
        );
      });
    });

    // ──────────────────────────────────────────
    // validatePassword
    // ──────────────────────────────────────────
    group('validatePassword', () {
      const required = 'Password is required';
      const tooShort = 'Password too short';

      test('returns requiredMsg when value is null', () {
        expect(Validators.validatePassword(null, requiredMsg: required, minLengthMsg: tooShort), required);
      });

      test('returns requiredMsg when value is empty', () {
        expect(Validators.validatePassword('', requiredMsg: required, minLengthMsg: tooShort), required);
      });

      test('returns minLengthMsg when password shorter than 6 chars', () {
        expect(Validators.validatePassword('abc', requiredMsg: required, minLengthMsg: tooShort), tooShort);
      });

      test('returns minLengthMsg for exactly 5 chars', () {
        expect(Validators.validatePassword('abcde', requiredMsg: required, minLengthMsg: tooShort), tooShort);
      });

      test('returns null for exactly 6 chars (boundary)', () {
        expect(Validators.validatePassword('abcdef', requiredMsg: required, minLengthMsg: tooShort), isNull);
      });

      test('returns null for long valid password', () {
        expect(
          Validators.validatePassword('MySecurePassword123!', requiredMsg: required, minLengthMsg: tooShort),
          isNull,
        );
      });
    });

    // ──────────────────────────────────────────
    // validateUsername
    // ──────────────────────────────────────────
    group('validateUsername', () {
      const required = 'Username is required';
      const tooShort = 'Username too short';

      test('returns requiredMsg when value is null', () {
        expect(Validators.validateUsername(null, requiredMsg: required, minLengthMsg: tooShort), required);
      });

      test('returns requiredMsg when value is empty', () {
        expect(Validators.validateUsername('', requiredMsg: required, minLengthMsg: tooShort), required);
      });

      test('returns minLengthMsg for 1-char username', () {
        expect(Validators.validateUsername('a', requiredMsg: required, minLengthMsg: tooShort), tooShort);
      });

      test('returns minLengthMsg for exactly 2 chars', () {
        expect(Validators.validateUsername('ab', requiredMsg: required, minLengthMsg: tooShort), tooShort);
      });

      test('returns null for exactly 3 chars (boundary)', () {
        expect(Validators.validateUsername('abc', requiredMsg: required, minLengthMsg: tooShort), isNull);
      });

      test('returns null for normal username', () {
        expect(
          Validators.validateUsername('john_doe', requiredMsg: required, minLengthMsg: tooShort),
          isNull,
        );
      });
    });

    // ──────────────────────────────────────────
    // validateRequired
    // ──────────────────────────────────────────
    group('validateRequired', () {
      const error = 'This field is required';

      test('returns errorMsg when value is null', () {
        expect(Validators.validateRequired(null, errorMsg: error), error);
      });

      test('returns errorMsg when value is empty', () {
        expect(Validators.validateRequired('', errorMsg: error), error);
      });

      test('returns null for non-empty value', () {
        expect(Validators.validateRequired('hello', errorMsg: error), isNull);
      });

      test('returns null for whitespace-only (whitespace is non-empty)', () {
        // Validators.validateRequired checks isEmpty, not trimmed
        expect(Validators.validateRequired('   ', errorMsg: error), isNull);
      });
    });

    // ──────────────────────────────────────────
    // validatePasswordConfirmation
    // ──────────────────────────────────────────
    group('validatePasswordConfirmation', () {
      const required = 'Confirmation is required';
      const mismatch = 'Passwords do not match';

      test('returns requiredMsg when confirmation is null', () {
        expect(
          Validators.validatePasswordConfirmation(
            'pass123',
            null,
            requiredMsg: required,
            mismatchMsg: mismatch,
          ),
          required,
        );
      });

      test('returns requiredMsg when confirmation is empty', () {
        expect(
          Validators.validatePasswordConfirmation(
            'pass123',
            '',
            requiredMsg: required,
            mismatchMsg: mismatch,
          ),
          required,
        );
      });

      test('returns mismatchMsg when passwords differ', () {
        expect(
          Validators.validatePasswordConfirmation(
            'pass123',
            'pass456',
            requiredMsg: required,
            mismatchMsg: mismatch,
          ),
          mismatch,
        );
      });

      test('returns null when passwords match', () {
        expect(
          Validators.validatePasswordConfirmation(
            'pass123',
            'pass123',
            requiredMsg: required,
            mismatchMsg: mismatch,
          ),
          isNull,
        );
      });

      test('returns mismatchMsg when original password is null but confirmation has value', () {
        expect(
          Validators.validatePasswordConfirmation(
            null,
            'pass123',
            requiredMsg: required,
            mismatchMsg: mismatch,
          ),
          mismatch,
        );
      });
    });
  });
}
