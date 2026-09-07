import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/change_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/change_password_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/widgets/change_password_form.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/widgets/change_password_header.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeChangePasswordRequestModel extends Fake implements ChangePasswordRequestModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;
  late ProviderContainer container;

  setUpAll(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
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

  group('ChangePasswordPage Widget Tests', () {
    testWidgets('should render form fields and handle password submit', (WidgetTester tester) async {
      when(() => mockAuthRepo.changePassword(param: any(named: 'param'))).thenAnswer((_) async => const Right(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWith((ref) => Future.value(mockAuthRepo)),
            changePasswordUseCaseProvider.overrideWith((ref) => Future.value(ChangePasswordUseCase(mockAuthRepo))),
          ],
          child: const MaterialApp(
            home: ChangePasswordPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ChangePasswordHeader), findsOneWidget);
      expect(find.byType(ChangePasswordForm), findsOneWidget);
      expect(find.byType(CommonTextField), findsNWidgets(3));

      // Enter old password, new password, confirm password
      await tester.enterText(find.byType(CommonTextField).at(0), 'Old12345!');
      await tester.enterText(find.byType(CommonTextField).at(1), 'NewPass123!');
      await tester.enterText(find.byType(CommonTextField).at(2), 'NewPass123!');
      await tester.pumpAndSettle();

      // Tap update password button
      final submitBtn = find.text(I18nKeys.updatePassword.tr);
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();
    });
  });
}
