import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/delete_account_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/delete_account_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeDeleteAccountRequestModel extends Fake implements DeleteAccountRequestModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;
  late ProviderContainer container;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
    registerFallbackValue(FakeDeleteAccountRequestModel());
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => Future.value(mockAuthRepo)),
        deleteAccountUseCaseProvider.overrideWith((ref) => Future.value(DeleteAccountUseCase(mockAuthRepo))),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('DeleteAccountViewModel Tests', () {
    test('initial state should have isConfirmed as false', () {
      final state = container.read(deleteAccountViewModelProvider);
      expect(state.isConfirmed, isFalse);
    });

    test('toggleConfirm intent should toggle isConfirmed', () {
      final viewModel = container.read(deleteAccountViewModelProvider.notifier);
      viewModel.handleIntent(const DeleteAccountIntent.toggleConfirm());

      expect(container.read(deleteAccountViewModelProvider).isConfirmed, isTrue);

      viewModel.handleIntent(const DeleteAccountIntent.toggleConfirm());
      expect(container.read(deleteAccountViewModelProvider).isConfirmed, isFalse);
    });

    test('deleteAccount intent when not confirmed should do nothing', () async {
      final viewModel = container.read(deleteAccountViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const DeleteAccountIntent.deleteAccount());
      await pumpEventQueue();

      expect(effects.whereType<ConfirmEffect>().isEmpty, isTrue);
    });

    test('deleteAccount intent when confirmed should emit ConfirmEffect', () async {
      final viewModel = container.read(deleteAccountViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      viewModel.handleIntent(const DeleteAccountIntent.toggleConfirm());
      await viewModel.handleIntent(const DeleteAccountIntent.deleteAccount());
      await pumpEventQueue();

      expect(effects.whereType<ConfirmEffect>().isNotEmpty, isTrue);
      final confirmEffect = effects.whereType<ConfirmEffect>().first;
      expect(confirmEffect.title, I18nKeys.deleteAccountConfirmTitle.tr);
    });

    test('confirmDelete intent on success should clear session and navigate to login', () async {
      when(() => mockAuthRepo.deleteAccount(param: any(named: 'param'))).thenAnswer((_) async => const Right(null));

      final viewModel = container.read(deleteAccountViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const DeleteAccountIntent.confirmDelete());
      await pumpEventQueue();

      expect(effects.whereType<NavigationEffect>().isNotEmpty, isTrue);
      final navEffect = effects.whereType<NavigationEffect>().first;
      expect(navEffect.target, Routes.login);
      expect(navEffect.isReplace, isTrue);
    });

    test('confirmDelete intent on failure should emit MessageEffect.error', () async {
      when(() => mockAuthRepo.deleteAccount(param: any(named: 'param'))).thenAnswer((_) async => const Left(ServerFailure('Deletion failed')));

      final viewModel = container.read(deleteAccountViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const DeleteAccountIntent.confirmDelete());
      await pumpEventQueue();

      expect(effects.whereType<MessageEffect>().isNotEmpty, isTrue);
    });
  });
}
