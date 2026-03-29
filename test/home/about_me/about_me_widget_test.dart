import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/repositories/about_me_repository.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/about_me_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

class _FakeAboutMeRepository implements AboutMeRepository {
  @override
  Future<Either<Failure, AboutMeModel>> getAboutMe() async {
    return right(const AboutMeModel());
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AboutMeWidget Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('Should display about me widget when active', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aboutMeRepositoryProvider.overrideWithValue(_FakeAboutMeRepository()),
          ],
          child: const MaterialApp(home: Scaffold(body: AboutMeWidget(active: true))),
        ),
      );

      await tester.pumpAndSettle();
      VisibilityDetectorController.instance.notifyNow();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Verify AboutMeWidget is rendered
      expect(find.byType(AboutMeWidget), findsOneWidget);
    });

    testWidgets('Should handle inactive state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aboutMeRepositoryProvider.overrideWithValue(_FakeAboutMeRepository()),
          ],
          child: const MaterialApp(home: Scaffold(body: AboutMeWidget(active: false))),
        ),
      );

      await tester.pumpAndSettle();
      VisibilityDetectorController.instance.notifyNow();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.byType(AboutMeWidget), findsOneWidget);
    });
  });
}
