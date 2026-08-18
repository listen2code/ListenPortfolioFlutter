import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/change_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/change_password_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeChangePasswordRequestModel extends Fake implements ChangePasswordRequestModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeChangePasswordRequestModel());
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => Future.value(mockAuthRepo)),
        changePasswordUseCaseProvider.overrideWith((ref) => Future.value(ChangePasswordUseCase(mockAuthRepo))),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ChangePasswordViewModel Tests', () {
    test('input intents update passwords in state', () {
      final viewModel = container.read(changePasswordViewModelProvider.notifier);

      viewModel.handleIntent(const ChangePasswordIntent.oldPasswordChanged('Old12345!'));
      viewModel.handleIntent(const ChangePasswordIntent.newPasswordChanged('New12345!'));
      viewModel.handleIntent(const ChangePasswordIntent.confirmPasswordChanged('New12345!'));

      final state = container.read(changePasswordViewModelProvider);
      expect(state.oldPassword, 'Old12345!');
      expect(state.newPassword, 'New12345!');
      expect(state.confirmPassword, 'New12345!');
    });

    test('submitChange with mismatched passwords sets confirmPasswordError', () async {
      final viewModel = container.read(changePasswordViewModelProvider.notifier);

      viewModel.handleIntent(const ChangePasswordIntent.oldPasswordChanged('Old12345!'));
      viewModel.handleIntent(const ChangePasswordIntent.newPasswordChanged('New12345!'));
      viewModel.handleIntent(const ChangePasswordIntent.confirmPasswordChanged('Mismatch123!'));

      await viewModel.handleIntent(const ChangePasswordIntent.submitChange());

      final state = container.read(changePasswordViewModelProvider);
      expect(state.confirmPasswordError, isNotNull);
    });

    test('submitChange success emits message and navigates back', () async {
      when(() => mockAuthRepo.changePassword(param: any(named: 'param'))).thenAnswer((_) async => const Right(null));

      final viewModel = container.read(changePasswordViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      viewModel.handleIntent(const ChangePasswordIntent.oldPasswordChanged('Old12345!'));
      viewModel.handleIntent(const ChangePasswordIntent.newPasswordChanged('New12345!'));
      viewModel.handleIntent(const ChangePasswordIntent.confirmPasswordChanged('New12345!'));

      await viewModel.handleIntent(const ChangePasswordIntent.submitChange());
      await pumpEventQueue();

      expect(effects.isNotEmpty, isTrue);
    });
  });
}
