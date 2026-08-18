import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/delete_account_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/delete_account_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/delete_account_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/widgets/delete_account_confirm_actions.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/delete_account/widgets/delete_account_warning_list.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeDeleteAccountRequestModel extends Fake implements DeleteAccountRequestModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;

  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    registerFallbackValue(FakeDeleteAccountRequestModel());
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => Future.value(mockAuthRepo)),
        deleteAccountUseCaseProvider.overrideWith((ref) => Future.value(DeleteAccountUseCase(mockAuthRepo))),
      ],
      child: const MaterialApp(
        home: DeleteAccountPage(),
      ),
    );
  }

  group('DeleteAccountPage Widget Tests', () {
    testWidgets('should render warning messages and toggle checkbox', (WidgetTester tester) async {
      when(() => mockAuthRepo.deleteAccount(param: any(named: 'param'))).thenAnswer((_) async => const Right(null));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(I18nKeys.deleteAccount.tr), findsWidgets);
      expect(find.byType(DeleteAccountWarningList), findsOneWidget);
      expect(find.byType(DeleteAccountConfirmActions), findsOneWidget);

      // Check the checkbox to enable the delete button
      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);

      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Tap the delete button
      final deleteBtn = find.text(I18nKeys.deleteAccount.tr);
      expect(deleteBtn, findsWidgets);

      await tester.tap(deleteBtn.last);
      await tester.pumpAndSettle();
    });
  });
}
