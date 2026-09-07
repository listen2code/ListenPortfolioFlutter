import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/upload_avatar_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_about_me_use_case.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/about_me_header.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/bio_section.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/comprehensive_skills.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/about_me_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MockGetAboutMeUseCase extends Mock implements GetAboutMeUseCase {}
class MockUploadAvatarUseCase extends Mock implements UploadAvatarUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetAboutMeUseCase mockGetAboutMeUseCase;
  late MockUploadAvatarUseCase mockUploadAvatarUseCase;

  const testAboutMe = AboutMeModel(
    name: 'Alice Developer',
    jobTitle: 'Senior Flutter Engineer',
    bio: 'Passionate about mobile apps & clean architecture.',
    avatarUrl: null,
    skills: [
      SkillCategoryModel(
        category: 'Mobile',
        items: ['Flutter', 'Dart', 'Kotlin', 'Swift'],
      ),
    ],
    experiences: [
      ExperienceItemModel(
        company: 'Google',
        title: 'Tech Lead',
        period: '2022 - Present',
        description: 'Built core features',
      ),
    ],
    education: [
      EducationItemModel(
        school: 'Top University',
        degree: 'BS in CS',
        period: '2018',
      ),
    ],
  );

  setUpAll(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
  });

  setUp(() {
    mockGetAboutMeUseCase = MockGetAboutMeUseCase();
    mockUploadAvatarUseCase = MockUploadAvatarUseCase();
  });

  Widget createWidget({required bool active}) {
    return ProviderScope(
      overrides: [
        getAboutMeUseCaseProvider.overrideWith((ref) => Future.value(mockGetAboutMeUseCase)),
        uploadAvatarUseCaseProvider.overrideWith((ref) => Future.value(mockUploadAvatarUseCase)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: AboutMeWidget(active: active),
        ),
      ),
    );
  }

  group('AboutMeWidget Tests', () {
    testWidgets('renders loaded content with header, bio, skills, and experience', (WidgetTester tester) async {
      when(() => mockGetAboutMeUseCase(param: any(named: 'param')))
          .thenAnswer((_) async => const Right(testAboutMe));

      await tester.pumpWidget(createWidget(active: true));
      await tester.pumpAndSettle();

      expect(find.byType(AboutMeHeader), findsOneWidget);
      expect(find.byType(BioSection), findsOneWidget);
      expect(find.byType(ComprehensiveSkills), findsOneWidget);
      expect(find.text('Passionate about mobile apps & clean architecture.'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('renders empty state when request returns failure', (WidgetTester tester) async {
      when(() => mockGetAboutMeUseCase(param: any(named: 'param')))
          .thenAnswer((_) async => const Left(ServerFailure('Error')));

      await tester.pumpWidget(createWidget(active: true));
      await tester.pumpAndSettle();

      expect(find.byType(BioSection), findsNothing);
    });
  });
}
