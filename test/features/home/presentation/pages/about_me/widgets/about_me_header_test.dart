import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/about_me_header.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../../test_helpers/test_setup.dart';

class MockAboutMeViewModel extends Mock implements AboutMeViewModel {}
class FakeAboutMeIntent extends Fake implements AboutMeIntent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeAboutMeIntent());
  });

  group('AboutMeHeader Widget Tests', () {
    late MockAboutMeViewModel mockViewModel;

    final testUser = UserModel(
      id: 'user_123',
      name: 'John Doe',
      email: 'john.doe@example.com',
      avatarUrl: 'https://example.com/avatar.jpg',
    );

    final testAboutMeData = AboutMeModel(
      status: 'Software Engineer',
      jobTitle: 'Senior Flutter Developer',
      bio: 'Passionate developer',
      graduationYear: '2018',
      major: 'CS',
      github: 'github',
      certifications: [],
      stats: [],
      experiences: [],
      education: [],
      skills: [],
      languages: [],
    );

    setUp(() async {
      mockViewModel = MockAboutMeViewModel();
      when(() => mockViewModel.handleIntent(any())).thenAnswer((_) async => null);
      
      // Log in user to set avatarUrl and name
      authManager.login(testUser);
    });

    testWidgets('should render correctly with initial state (no imageFile)', (WidgetTester tester) async {
      final state = AboutMeState(data: testAboutMeData, isInitialLoaded: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AboutMeHeader(viewModel: mockViewModel, state: state),
          ),
        ),
      );

      // Verify name is rendered
      expect(find.text('John Doe'), findsOneWidget);
      // Verify job title is rendered
      expect(find.text('Senior Flutter Developer'), findsOneWidget);
    });

    testWidgets('should show picker bottom sheet and trigger gallery intent', (WidgetTester tester) async {
      final state = AboutMeState(data: testAboutMeData, isInitialLoaded: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AboutMeHeader(viewModel: mockViewModel, state: state),
          ),
        ),
      );

      // Tap the camera alt button to open bottom sheet picker
      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pumpAndSettle(); // wait for bottom sheet animation

      // Verify bottom sheet items are displayed using I18nKeys
      expect(find.text(I18nKeys.chooseFromGallery.tr), findsOneWidget);
      expect(find.text(I18nKeys.takePhoto.tr), findsOneWidget);

      // Tap gallery item
      await tester.tap(find.text(I18nKeys.chooseFromGallery.tr));
      await tester.pumpAndSettle(); // wait for bottom sheet to close

      // Verify viewModel received intent
      verify(() => mockViewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.gallery))).called(1);
    });

    testWidgets('should show remove photo option in bottom sheet when imageFile is present', (WidgetTester tester) async {
      // Simulate imageFile present in state
      final state = AboutMeState(
        data: testAboutMeData,
        isInitialLoaded: true,
        imageFile: File('dummy_image_path'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AboutMeHeader(viewModel: mockViewModel, state: state),
          ),
        ),
      );

      // Open bottom sheet
      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pumpAndSettle();

      // Verify remove photo item is present using I18nKeys
      expect(find.text(I18nKeys.removePhoto.tr), findsOneWidget);

      // Tap remove photo item
      await tester.tap(find.text(I18nKeys.removePhoto.tr));
      await tester.pumpAndSettle();

      // Verify viewModel received remove intent
      verify(() => mockViewModel.handleIntent(const AboutMeIntent.removeImage())).called(1);
    });
  });
}
