import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/delete_account_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/delete_account_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDeleteAccountUseCase extends Mock implements DeleteAccountUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDeleteAccountUseCase mockUseCase;

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory' ||
            methodCall.method == 'getTemporaryDirectory') {
          return 'temp_docs';
        }
        return null;
      },
    );
    registerFallbackValue(const DeleteAccountRequestModel(userId: ''));
  });

  setUp(() {
    mockUseCase = MockDeleteAccountUseCase();
  });

  group('DeleteAccountViewModel Tests', () {
    late ProviderContainer container;
    late DeleteAccountViewModel viewModel;

    setUp(() async {
      // Mock SharedPreferences for SpUtil initialization
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      // Create ProviderContainer and get ViewModel
      container = ProviderContainer(
        overrides: [
          deleteAccountUseCaseProvider.overrideWith((ref) => mockUseCase),
        ],
      );
      viewModel = container.read(deleteAccountViewModelProvider.notifier);
    });

    tearDown(() async {
      // Wait for any pending async operations before disposing
      await Future.delayed(const Duration(milliseconds: 100));
      container.dispose();
    });

    test('Initial state should have isConfirmed as false', () {
      final state = container.read(deleteAccountViewModelProvider);
      expect(state.isConfirmed, isFalse);
    });

    test('Should toggle isConfirmed state when toggleConfirm intent is handled', () async {
      // When - Trigger toggleConfirm intent
      await viewModel.onIntent(const DeleteAccountIntent.toggleConfirm());

      // Then - State should be toggled to true
      expect(viewModel.state.isConfirmed, isTrue);

      // When - Toggle again
      await viewModel.onIntent(const DeleteAccountIntent.toggleConfirm());

      // Then - State should be toggled back to false
      expect(viewModel.state.isConfirmed, isFalse);
    });

    test('Should not proceed with deletion request if isConfirmed is false', () async {
      // Given - State is confirmed: false (initial)
      expect(viewModel.state.isConfirmed, isFalse);

      // When - Attempt to delete account
      await viewModel.onIntent(const DeleteAccountIntent.deleteAccount());

      // Then - State should remain unchanged
      expect(viewModel.state.isConfirmed, isFalse);
      verifyNever(() => mockUseCase.call(param: any(named: 'param')));
    });

    test('Should maintain state consistency across multiple operations', () async {
      // Given - Initial state
      expect(viewModel.state.isConfirmed, isFalse);

      // When - Multiple toggle operations
      await viewModel.onIntent(const DeleteAccountIntent.toggleConfirm());
      expect(viewModel.state.isConfirmed, isTrue);

      await viewModel.onIntent(const DeleteAccountIntent.toggleConfirm());
      expect(viewModel.state.isConfirmed, isFalse);

      await viewModel.onIntent(const DeleteAccountIntent.toggleConfirm());
      expect(viewModel.state.isConfirmed, isTrue);

      // Then - State should be consistent
      expect(viewModel.state.isConfirmed, isTrue);
    });

    test('Should delete account on confirmation and success', () async {
      // Setup user logged in
      authManager.login(const UserModel(id: 'test-user-id', name: 'Test User'));
      expect(authManager.state.isGuest, isFalse);

      // Define mock usecase success behavior
      when(() => mockUseCase.call(param: any(named: 'param')))
          .thenAnswer((_) async => const Right(null));

      // Bind effect collection to verify effects
      final List<BaseEffect> emittedEffects = [];
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));

      // Set view model state to confirmed: true
      await viewModel.onIntent(const DeleteAccountIntent.toggleConfirm());

      // Trigger delete account
      await viewModel.onIntent(const DeleteAccountIntent.deleteAccount());

      // Verify ConfirmEffect is emitted
      final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
      expect(confirmEffects, isNotEmpty);
      final confirmEffect = confirmEffects.last;
      expect(confirmEffect.okText, I18nKeys.deleteAccount.tr);

      // Simulate confirmation (result: true)
      confirmEffect.onResult(true);
      await Future.delayed(const Duration(milliseconds: 100));

      // Verify UseCase was called with correct parameters
      verify(() => mockUseCase.call(
            param: any(
              named: 'param',
              that: isA<DeleteAccountRequestModel>().having((m) => m.userId, 'userId', 'test-user-id'),
            ),
          )).called(1);

      // Verify authManager logout was called (status is loggedOut)
      expect(authManager.state.isGuest, isTrue);

      // Verify success effects
      final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
      expect(messageEffects, isNotEmpty);
      expect(messageEffects.last.message, I18nKeys.deleteAccountSuccess.tr);

      final navEffects = emittedEffects.whereType<NavigationEffect>().toList();
      expect(navEffects, isNotEmpty);
      expect(navEffects.last.target, equals(Routes.login));
      expect(navEffects.last.isReplace, isTrue);
    });

    test('Should not delete account if dialog is cancelled', () async {
      authManager.login(const UserModel(id: 'test-user-id', name: 'Test User'));
      expect(authManager.state.isGuest, isFalse);

      final List<BaseEffect> emittedEffects = [];
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));

      await viewModel.onIntent(const DeleteAccountIntent.toggleConfirm());

      await viewModel.onIntent(const DeleteAccountIntent.deleteAccount());

      final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
      expect(confirmEffects, isNotEmpty);

      // Simulate cancellation (result: false)
      confirmEffects.last.onResult(false);
      await Future.delayed(const Duration(milliseconds: 100));

      // Verify UseCase was NOT called
      verifyNever(() => mockUseCase.call(param: any(named: 'param')));
      // Still logged in
      expect(authManager.state.isGuest, isFalse);
    });

    test('Should handle failure on delete account', () async {
      authManager.login(const UserModel(id: 'test-user-id', name: 'Test User'));
      expect(authManager.state.isGuest, isFalse);

      // Mock failure
      when(() => mockUseCase.call(param: any(named: 'param')))
          .thenAnswer((_) async => Left(ServerApiFailure('Failed to delete')));

      final List<BaseEffect> emittedEffects = [];
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));

      await viewModel.onIntent(const DeleteAccountIntent.toggleConfirm());

      await viewModel.onIntent(const DeleteAccountIntent.deleteAccount());

      final confirmEffects = emittedEffects.whereType<ConfirmEffect>().toList();
      expect(confirmEffects, isNotEmpty);

      // Simulate confirmation (result: true)
      confirmEffects.last.onResult(true);
      await Future.delayed(const Duration(milliseconds: 100));

      // Verify UseCase was called
      verify(() => mockUseCase.call(param: any(named: 'param'))).called(1);
      // Still logged in
      expect(authManager.state.isGuest, isFalse);

      // Verify error effect
      final messageEffects = emittedEffects.whereType<MessageEffect>().toList();
      expect(messageEffects, isNotEmpty);
      expect(messageEffects.last.message, I18nKeys.deleteAccountFailed.tr);
    });
  });
}
