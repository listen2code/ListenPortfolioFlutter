import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/signup_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/signup_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeSignupRequestModel extends Fake implements SignupRequestModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeSignupRequestModel());
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => Future.value(mockAuthRepo)),
        signupUseCaseProvider.overrideWith((ref) => Future.value(SignupUseCase(mockAuthRepo))),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SignUpViewModel Tests', () {
    test('input intents should update state correctly', () {
      final viewModel = container.read(signUpViewModelProvider.notifier);

      viewModel.handleIntent(const SignUpIntent.fullNameChanged('John Doe'));
      viewModel.handleIntent(const SignUpIntent.emailChanged('john@example.com'));
      viewModel.handleIntent(const SignUpIntent.passwordChanged('Pass12345!'));
      viewModel.handleIntent(const SignUpIntent.confirmPasswordChanged('Pass12345!'));

      final state = container.read(signUpViewModelProvider);
      expect(state.fullName, 'John Doe');
      expect(state.email, 'john@example.com');
      expect(state.password, 'Pass12345!');
      expect(state.confirmPassword, 'Pass12345!');
    });

    test('submitSignUp with validation errors should set error fields', () async {
      final viewModel = container.read(signUpViewModelProvider.notifier);

      await viewModel.handleIntent(const SignUpIntent.submitSignUp());

      final state = container.read(signUpViewModelProvider);
      expect(state.fullNameError, isNotNull);
      expect(state.emailError, isNotNull);
      expect(state.passwordError, isNotNull);
      expect(state.confirmPasswordError, isNotNull);
    });

    test('submitSignUp success should emit effects and navigate back', () async {
      when(() => mockAuthRepo.signUp(param: any(named: 'param'))).thenAnswer((_) async => const Right(null));

      final viewModel = container.read(signUpViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      viewModel.handleIntent(const SignUpIntent.fullNameChanged('John Doe'));
      viewModel.handleIntent(const SignUpIntent.emailChanged('john@example.com'));
      viewModel.handleIntent(const SignUpIntent.passwordChanged('Pass12345!'));
      viewModel.handleIntent(const SignUpIntent.confirmPasswordChanged('Pass12345!'));

      await viewModel.handleIntent(const SignUpIntent.submitSignUp());
      await pumpEventQueue();

      expect(effects.isNotEmpty, isTrue);
    });

    test('navigateToLogin intent should emit NavigationEffect', () async {
      final viewModel = container.read(signUpViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const SignUpIntent.navigateToLogin());
      await pumpEventQueue();

      expect(effects.whereType<NavigationEffect>().isNotEmpty, isTrue);
    });
  });
}
