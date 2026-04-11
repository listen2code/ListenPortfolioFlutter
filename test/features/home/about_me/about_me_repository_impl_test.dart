import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/about_me_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/about_me_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/repositories/about_me_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockAboutMeRemoteDataSource extends Mock
    implements AboutMeRemoteDataSource {}

class MockAboutMeLocalDataSource extends Mock
    implements AboutMeLocalDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(AboutMeModel());
  });

  late AboutMeRepositoryImpl repository;
  late MockAboutMeRemoteDataSource mockRemote;
  late MockAboutMeLocalDataSource mockLocal;

  final testAboutMe = AboutMeModel(
    status: 'Software Engineer',
    jobTitle: 'Senior Flutter Developer',
    bio: 'Passionate about mobile development',
  );

  final successResponse = BaseResponseModel<AboutMeModel>(
    result: ApiResult.success,
    body: AboutMeModel(
      status: 'Software Engineer',
      jobTitle: 'Senior Flutter Developer',
      bio: 'Passionate about mobile development',
    ),
  );

  final failureResponse = BaseResponseModel<AboutMeModel>(
    result: ApiResult.serverError,
    message: 'Internal server error',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    // Mock the connectivity_plus platform channel to simulate wifi connection
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (MethodCall call) async => ['wifi'],
        );

    mockRemote = MockAboutMeRemoteDataSource();
    mockLocal = MockAboutMeLocalDataSource();
    repository = AboutMeRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('AboutMeRepositoryImpl - getAboutMe', () {
    test('should return AboutMeModel when remote call succeeds', () async {
      // Arrange
      when(
        () => mockRemote.getAboutMe(),
      ).thenAnswer((_) async => successResponse);
      when(() => mockLocal.cacheAboutMe(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.getAboutMe();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Expected Right but got Left: $failure'), (
        data,
      ) {
        expect(data.status, testAboutMe.status);
        expect(data.jobTitle, testAboutMe.jobTitle);
      });
      verify(() => mockRemote.getAboutMe()).called(1);
      verify(() => mockLocal.cacheAboutMe(any())).called(1);
    });

    test('should cache data after successful remote fetch', () async {
      // Arrange
      when(
        () => mockRemote.getAboutMe(),
      ).thenAnswer((_) async => successResponse);
      when(() => mockLocal.cacheAboutMe(any())).thenAnswer((_) async {});

      // Act
      await repository.getAboutMe();

      // Assert — cache must be written exactly once
      verify(() => mockLocal.cacheAboutMe(any())).called(1);
    });

    test(
      'should return cached data when remote fails and cache exists',
      () async {
        // Arrange — remote returns failure, cache has data
        when(
          () => mockRemote.getAboutMe(),
        ).thenAnswer((_) async => failureResponse);
        when(
          () => mockLocal.getCachedAboutMe(),
        ).thenAnswer((_) async => testAboutMe);

        // Act
        final result = await repository.getAboutMe();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (data) => expect(data.status, testAboutMe.status),
        );
        verify(() => mockLocal.getCachedAboutMe()).called(1);
      },
    );

    test(
      'should return Failure when remote fails and no cache exists',
      () async {
        // Arrange
        when(
          () => mockRemote.getAboutMe(),
        ).thenAnswer((_) async => failureResponse);
        when(() => mockLocal.getCachedAboutMe()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getAboutMe();

        // Assert
        expect(result.isLeft(), isTrue);
      },
    );

    test(
      'should return Left when remote throws generic exception regardless of cache',
      () async {
        // Arrange — generic exceptions bypass cache fallback in safeCall's catch block
        when(
          () => mockRemote.getAboutMe(),
        ).thenThrow(Exception('Connection refused'));
        when(
          () => mockLocal.getCachedAboutMe(),
        ).thenAnswer((_) async => testAboutMe);

        // Act
        final result = await repository.getAboutMe();

        // Assert — generic exceptions go straight to Left without checking cache
        expect(result.isLeft(), isTrue);
      },
    );

    test(
      'should fall back to cache when remote returns session timeout failure',
      () async {
        // Arrange — ApiResult.sessionTimeout maps to AuthFailure, which is NOT ServerFailure
        // so _handleFailureFallback will try the cache (failure is! ServerFailure == true)
        final sessionTimeoutResponse = BaseResponseModel<AboutMeModel>(
          result: ApiResult.sessionTimeout,
          message: 'Session expired',
        );
        when(
          () => mockRemote.getAboutMe(),
        ).thenAnswer((_) async => sessionTimeoutResponse);
        when(
          () => mockLocal.getCachedAboutMe(),
        ).thenAnswer((_) async => testAboutMe);

        // Act
        final result = await repository.getAboutMe();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (data) => expect(data.status, testAboutMe.status),
        );
      },
    );
  });

  group('AboutMe API Contract Tests', () {
    group('GET /aboutMe', () {
      test('✅ AboutMe Response - All top-level fields present', () {
        final mockAboutMeJson = {
          'status': 'available',
          'jobTitle': 'Senior Flutter Engineer',
          'bio': 'Bio text...',
          'graduationYear': '2013',
          'major': 'softwareEngineering',
          'github': 'https://github.com/listen2code',
          'certifications': ['jlptN1', 'bjtJ2'],
          'stats': [],
          'experiences': [],
          'education': [],
          'skills': [],
          'languages': [],
        };

        final aboutMe = AboutMeModel.fromJson(mockAboutMeJson);

        expect(aboutMe.status, equals('available'));
        expect(aboutMe.jobTitle, isNotEmpty);
        expect(aboutMe.bio, isNotEmpty);
        expect(aboutMe.graduationYear, equals('2013'));
        expect(aboutMe.github, contains('github.com'));
        expect(aboutMe.certifications, isA<List<String>>());
      });

      test('🔴 CRITICAL FIX - SkillCategoryModel must have id field', () {
        // Backend SkillDto has: Long id, String category, List<String> items
        // Flutter SkillCategoryModel SHOULD have: String? id, String? category, List<String> items
        // This test verifies the id field is now present and correct

        final mockSkillJson = {
          'id': '101',
          'category': 'Languages',
          'items': ['Dart', 'Flutter'],
        };

        final skill = SkillCategoryModel.fromJson(mockSkillJson);

        // Assert: id field now exists
        expect(
          skill.id,
          isNotNull,
          reason: 'id field MUST NOT be null when Backend provides it',
        );
        expect(
          skill.id,
          equals('101'),
          reason: 'id should be "101" from Backend (converted from Long)',
        );
        expect(
          skill.id,
          isA<String>(),
          reason: 'id must be String (@ToStringConverter from Long)',
        );

        // Assert: other fields still correct
        expect(skill.category, equals('Languages'));
        expect(skill.items, contains('Dart'));
      });

      test(
        '⚠️ SkillCategoryModel with missing id - Should handle degrade gracefully',
        () {
          // In case old mock data doesn't have id, model should still work
          final mockSkillWithoutId = {
            'category': 'Languages',
            'items': ['Dart'],
          };

          final skill = SkillCategoryModel.fromJson(mockSkillWithoutId);

          // Freezed should default to null when id is missing
          expect(skill.id, isNull, reason: 'should be null when not in JSON');
          expect(skill.category, isNotNull, reason: 'category still required');
          expect(skill.items, isNotEmpty, reason: 'items still required');
        },
      );

      test(
        '📊 Skills Array in AboutMe - Verify SkillCategoryModel list deserialization',
        () {
          final mockAboutMeJson = {
            'status': 'available',
            'jobTitle': 'Engineer',
            'bio': 'Bio',
            'graduationYear': '2013',
            'skills': [
              {
                'id': '1',
                'category': 'Frontend',
                'items': ['Flutter', 'React'],
              },
              {
                'id': '2',
                'category': 'Backend',
                'items': ['Spring Boot', 'Node.js'],
              },
            ],
            'certifications': [],
            'stats': [],
            'experiences': [],
            'education': [],
            'languages': [],
          };

          final aboutMe = AboutMeModel.fromJson(mockAboutMeJson);

          expect(aboutMe.skills, isA<List<SkillCategoryModel>>());
          expect(aboutMe.skills, hasLength(2));

          // Verify first skill
          final firstSkill = aboutMe.skills[0];
          expect(
            firstSkill.id,
            equals('1'),
            reason: 'first skill id should be "1"',
          );
          expect(firstSkill.category, equals('Frontend'));
          expect(firstSkill.items, contains('Flutter'));

          // Verify second skill
          final secondSkill = aboutMe.skills[1];
          expect(
            secondSkill.id,
            equals('2'),
            reason: 'second skill id should be "2"',
          );
        },
      );

      test('❌ Error Scenario - Null skills should default to empty list', () {
        final mockAboutMeJson = {
          'status': 'available',
          'jobTitle': 'Engineer',
          'bio': 'Bio',
          'graduationYear': '2013',
          // skills: null or missing
          'certifications': [],
          'stats': [],
          'experiences': [],
          'education': [],
          'languages': [],
        };

        final aboutMe = AboutMeModel.fromJson(mockAboutMeJson);

        expect(
          aboutMe.skills,
          isA<List<SkillCategoryModel>>(),
          reason: '@Default([]) should ensure non-null list',
        );
        expect(
          aboutMe.skills,
          isEmpty,
          reason: 'should be empty when not provided',
        );
      });

      test(
        '🔄 SkillCategoryModel Backward Compatibility - Old mock without id should still work',
        () {
          // Even though we added id field, old tests should still pass
          final oldMockSkillFormat = {
            'category': 'Mobile',
            'items': ['Flutter', 'iOS'],
          };

          expect(
            () => SkillCategoryModel.fromJson(oldMockSkillFormat),
            returnsNormally,
            reason:
                'should deserialize even without id field (backwards compatible)',
          );

          final skill = SkillCategoryModel.fromJson(oldMockSkillFormat);
          expect(skill.category, equals('Mobile'));
          expect(skill.id, isNull, reason: 'missing field should be null');
        },
      );

      test(
        '📝 Nested Structure Validation - Stats, Experience, Education, Languages',
        () {
          final mockAboutMeJson = {
            'status': 'available',
            'jobTitle': 'Engineer',
            'bio': 'Bio',
            'graduationYear': '2013',
            'stats': [
              {
                'id': '1',
                'businessId': 'android',
                'year': '11',
                'label': 'androidExp',
                'tags': ['archDesign'],
              },
            ],
            'experiences': [
              {
                'title': 'Engineer',
                'company': 'Google',
                'period': '2020-2023',
                'description': 'Desc',
              },
            ],
            'education': [
              {
                'degree': 'BS',
                'school': 'MIT',
                'period': '2009-2013',
                'description': 'Desc',
              },
            ],
            'languages': [
              {'name': 'English', 'level': 'Native'},
              {'name': 'Japanese', 'level': 'N1'},
            ],
            'certifications': [],
            'skills': [],
          };

          final aboutMe = AboutMeModel.fromJson(mockAboutMeJson);

          expect(aboutMe.stats, isNotEmpty);
          expect(aboutMe.stats.first.id, equals('1'));
          expect(aboutMe.experiences, isNotEmpty);
          expect(aboutMe.education, isNotEmpty);
          expect(aboutMe.languages, hasLength(2));
        },
      );

      test(
        '🎯 Complete Mock File Contract - Verify full response structure',
        () {
          // This represents what assets/mock/v1/get/aboutMe.json should contain
          final fullMockResponse = {
            'result': '0',
            'messageId': '',
            'message': '',
            'body': {
              'status': 'available',
              'jobTitle': 'Senior Engineer',
              'bio': 'Bio',
              'graduationYear': '2013',
              'major': 'softwareEngineering',
              'github': 'https://github.com/listen2code',
              'certifications': ['jlptN1'],
              'stats': [
                {
                  'id': '1',
                  'businessId': 'flutter',
                  'year': '3',
                  'label': 'flutterExp',
                  'tags': [],
                },
              ],
              'experiences': [
                {
                  'title': 'Engineer',
                  'company': 'Company',
                  'period': '2023-present',
                  'description': 'Desc',
                },
              ],
              'education': [
                {
                  'degree': 'BS',
                  'school': 'University',
                  'period': '2009-2013',
                  'description': 'Desc',
                },
              ],
              'skills': [
                {
                  'id': '10',
                  'category': 'Languages',
                  'items': ['Dart', 'Kotlin'],
                },
                {
                  'id': '11',
                  'category': 'Frontend',
                  'items': ['Flutter', 'React'],
                },
              ],
              'languages': [
                {'name': 'English', 'level': 'Native'},
                {'name': 'Japanese', 'level': 'N1'},
              ],
            },
          };

          final body = fullMockResponse['body'] as Map<String, dynamic>;
          final aboutMe = AboutMeModel.fromJson(body);

          // Verify complete structure
          expect(aboutMe.status, equals('available'));
          expect(aboutMe.skills, hasLength(2));
          expect(
            aboutMe.skills[0].id,
            equals('10'),
            reason: '🔴 CRITICAL: Skill id must be present',
          );
          expect(aboutMe.skills[1].category, equals('Frontend'));
        },
      );
    });

    group('Backend DTO ↔ Flutter Model Contract', () {
      test(
        '🔴 SkillCategoryModel.id Field - Backend SkillDto.id → Flutter SkillCategoryModel.id',
        () {
          // Backend SkillDto: Long id → JSON: "101" → Flutter String? id (via @ToStringConverter)

          final backendResponse = {
            'id':
                '101', // Simulates @JsonSerialize(ToStringSerializer.class) from Long
            'category': 'Frontend',
            'items': ['Flutter'],
          };

          final model = SkillCategoryModel.fromJson(backendResponse);

          // This is the CRITICAL CONTRACT:
          expect(
            model.id,
            isNotNull,
            reason: 'Backend provides id, Flutter must capture it',
          );
          expect(model.id, equals('101'));
          expect(
            model.id,
            isA<String>(),
            reason: 'id is String with @ToStringConverter',
          );
        },
      );

      test('✅ AboutMeDto.skills → AboutMeModel.skills type contract', () {
        // Backend: List<SkillDto>
        // Flutter: List<SkillCategoryModel>
        // Each SkillDto should deserialize to SkillCategoryModel with id field

        final mockSkillsJson = [
          {
            'id': '201',
            'category': 'Mobile',
            'items': ['Flutter', 'Native'],
          },
          {
            'id': '202',
            'category': 'Backend',
            'items': ['Spring Boot'],
          },
        ];

        final models = mockSkillsJson
            .map(
              (json) =>
                  SkillCategoryModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        expect(models, hasLength(2));
        expect(models[0].id, equals('201'));
        expect(models[1].id, equals('202'));
      });
    });
  });
}
