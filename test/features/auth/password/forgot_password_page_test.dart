import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/forgot_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeForgotPasswordRequestModel extends Fake implements ForgotPasswordRequestModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeForgotPasswordRequestModel());
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => Future.value(mockAuthRepo)),
        forgotPasswordUseCaseProvider.overrideWith((ref) => Future.value(ForgotPasswordUseCase(mockAuthRepo))),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ForgotPasswordViewModel Tests', () {
    test('emailChanged intent updates email state', () {
      final viewModel = container.read(forgotPasswordViewModelProvider.notifier);
      viewModel.handleIntent(const ForgotPasswordIntent.emailChanged('user@test.com'));

      final state = container.read(forgotPasswordViewModelProvider);
      expect(state.email, 'user@test.com');
    });

    test('submitReset with empty email sets emailError', () async {
      final viewModel = container.read(forgotPasswordViewModelProvider.notifier);
      await viewModel.handleIntent(const ForgotPasswordIntent.submitReset());

      final state = container.read(forgotPasswordViewModelProvider);
      expect(state.emailError, isNotNull);
    });

    test('submitReset success emits message and navigates back', () async {
      when(() => mockAuthRepo.forgotPassword(param: any(named: 'param'))).thenAnswer((_) async => const Right(null));

      final viewModel = container.read(forgotPasswordViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      viewModel.handleIntent(const ForgotPasswordIntent.emailChanged('user@test.com'));
      await viewModel.handleIntent(const ForgotPasswordIntent.submitReset());
      await pumpEventQueue();

      expect(effects.isNotEmpty, isTrue);
    });

    test('navigateToLogin intent emits NavigationEffect back', () async {
      final viewModel = container.read(forgotPasswordViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const ForgotPasswordIntent.navigateToLogin());
      await pumpEventQueue();

      expect(effects.whereType<NavigationEffect>().isNotEmpty, isTrue);
    });
  });
}
