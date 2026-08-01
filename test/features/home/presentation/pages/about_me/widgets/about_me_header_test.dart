import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/widgets/about_me_header.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import '../../../../../../test_helpers/test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AboutMeHeader Widget Tests', () {
    final testUser = UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      avatarUrl: 'https://example.com/avatar.jpg',
    );

    final testAboutMeData = AboutMeModel(
      name: 'John Doe',
      avatarUrl: 'https://example.com/avatar.jpg',
      status: 'Software Engineer',
      jobTitle: 'Senior Flutter Developer',
      bio: 'Passionate developer',
      graduationYear: '2018',
      major: 'CS',
      github: 'github',
      certifications: const [],
      stats: const [],
      experiences: const [],
      education: const [],
      skills: const [],
      languages: const [],
    );

    setUp(() async {
      // Log in user to set avatarUrl and name
      authManager.login(testUser);
    });

    testWidgets('should render correctly with initial state (no imageFile)', (WidgetTester tester) async {
      final state = AboutMeState(data: testAboutMeData, isInitialLoaded: true);
      bool tapCameraCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AboutMeHeader(
              state: state,
              onTapCamera: () {
                tapCameraCalled = true;
              },
            ),
          ),
        ),
      );

      // Verify name is rendered
      expect(find.text('John Doe'), findsOneWidget);
      // Verify job title is rendered
      expect(find.text('Senior Flutter Developer'), findsOneWidget);

      // Tap camera icon and check callback
      expect(tapCameraCalled, isFalse);
      await tester.tap(find.byIcon(Icons.camera_alt));
      expect(tapCameraCalled, isTrue);
    });

    testWidgets('should render correctly with imageFile present', (WidgetTester tester) async {
      final state = AboutMeState(
        data: testAboutMeData,
        isInitialLoaded: true,
        imageFile: File('dummy_image_path'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AboutMeHeader(
              state: state,
              onTapCamera: () {},
            ),
          ),
        ),
      );

      // Verify name is rendered
      expect(find.text('John Doe'), findsOneWidget);
    });
  });
}
