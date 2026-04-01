import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/repositories/about_me_repository.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_about_me_use_case.dart';
import 'package:mocktail/mocktail.dart';

///
/// GetAboutMeUseCase 单元测试
///
/// 测试覆盖范围：
/// 1. 正常获取个人信息数据（成功场景）
/// 2. 各种失败场景（网络错误、服务器错误、数据解析错误等）
/// 3. 边界情况（空数据、null值处理）
/// 4. 错误处理（Repository层错误传递）
///
/// 架构原则：
/// - UseCase层负责协调Repository调用，不包含业务逻辑验证
/// - 所有数据验证逻辑应在ViewModel层或Repository层处理
/// - UseCase直接返回Repository的结果（成功或失败）
///

// Mock repository
class MockAboutMeRepository extends Mock implements AboutMeRepository {}

void main() {
  late GetAboutMeUseCase useCase;
  late MockAboutMeRepository mockRepository;

  setUp(() {
    mockRepository = MockAboutMeRepository();
    useCase = GetAboutMeUseCase(mockRepository);
  });

  group('GetAboutMeUseCase', () {
    // 测试数据
    final testAboutMeModel = AboutMeModel(
      status: 'Software Engineer',
      jobTitle: 'Senior Flutter Developer',
      bio: 'Passionate about mobile development',
      graduationYear: '2018',
      major: 'Computer Science',
      github: 'https://github.com/testuser',
      certifications: ['Flutter Certified', 'AWS Certified'],
      stats: [
        AboutMeStatModel(id: '1', year: '2023', label: 'Projects Completed', tags: ['Mobile', 'Web']),
      ],
      experiences: [
        ExperienceItemModel(
          title: 'Senior Developer',
          company: 'Tech Corp',
          period: '2020-2023',
          description: 'Led mobile development team',
        ),
      ],
      education: [
        EducationItemModel(
          degree: 'Bachelor of Science',
          school: 'University of Technology',
          period: '2014-2018',
          description: 'Computer Science major',
        ),
      ],
      skills: [
        SkillCategoryModel(category: 'Programming', items: ['Flutter', 'Dart', 'Python']),
      ],
      languages: [LanguageItemModel(name: 'English', level: 'Native')],
    );

    test('should return AboutMeModel when repository call is successful', () async {
      // Arrange: Mock repository to return success with test data
      when(() => mockRepository.getAboutMe()).thenAnswer((_) async => Right(testAboutMeModel));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, Right<Failure, AboutMeModel>(testAboutMeModel));
      verify(() => mockRepository.getAboutMe()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository returns ServerFailure', () async {
      // Arrange
      const serverFailure = ServerFailure('Server error occurred');
      when(() => mockRepository.getAboutMe()).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, AboutMeModel>(serverFailure));
      verify(() => mockRepository.getAboutMe()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const networkFailure = NetworkFailure('Network connection failed');
      when(() => mockRepository.getAboutMe()).thenAnswer((_) async => const Left(networkFailure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, AboutMeModel>(networkFailure));
      verify(() => mockRepository.getAboutMe()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when local cache error occurs', () async {
      // Arrange
      const cacheFailure = CacheFailure('Cache read error');
      when(() => mockRepository.getAboutMe()).thenAnswer((_) async => const Left(cacheFailure));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, const Left<Failure, AboutMeModel>(cacheFailure));
      verify(() => mockRepository.getAboutMe()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty AboutMeModel data correctly', () async {
      // Arrange
      final emptyAboutMeModel = AboutMeModel();
      when(() => mockRepository.getAboutMe()).thenAnswer((_) async => Right(emptyAboutMeModel));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, Right<Failure, AboutMeModel>(emptyAboutMeModel));
      result.fold((failure) => fail('Expected Right but got Left: $failure'), (aboutMe) {
        expect(aboutMe.status, isNull);
        expect(aboutMe.jobTitle, isNull);
        expect(aboutMe.bio, isNull);
        expect(aboutMe.certifications, isEmpty);
        expect(aboutMe.stats, isEmpty);
      });
      verify(() => mockRepository.getAboutMe()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle AboutMeModel with partial data correctly', () async {
      // Arrange
      final partialAboutMeModel = AboutMeModel(
        status: 'Software Engineer',
        jobTitle: 'Flutter Developer',
        bio: null,
        graduationYear: null,
        major: null,
        github: null,
        certifications: [],
        stats: [],
        experiences: [],
        education: [],
        skills: [],
        languages: [],
      );
      when(() => mockRepository.getAboutMe()).thenAnswer((_) async => Right(partialAboutMeModel));

      // Act
      final result = await useCase(param: null);

      // Assert
      expect(result, Right<Failure, AboutMeModel>(partialAboutMeModel));
      result.fold((failure) => fail('Expected Right but got Left: $failure'), (aboutMe) {
        expect(aboutMe.status, 'Software Engineer');
        expect(aboutMe.jobTitle, 'Flutter Developer');
        expect(aboutMe.bio, isNull);
        expect(aboutMe.certifications, isEmpty);
      });
      verify(() => mockRepository.getAboutMe()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass through BaseParam correctly', () async {
      // Arrange
      final testParam = BaseParam();
      when(() => mockRepository.getAboutMe()).thenAnswer((_) async => Right(testAboutMeModel));

      // Act
      final result = await useCase(param: testParam);

      // Assert
      expect(result, Right<Failure, AboutMeModel>(testAboutMeModel));
      verify(() => mockRepository.getAboutMe()).called(1);
      verifyNoMoreInteractions(mockRepository);
      // Note: BaseParam is not used in this use case, but we verify it doesn't break the call
    });

    test('should handle repository exceptions gracefully', () async {
      // Arrange
      when(() => mockRepository.getAboutMe()).thenThrow(Exception('Unexpected repository error'));

      // Act & Assert
      expect(() => useCase(param: null), throwsA(isA<Exception>()));
    });
  });
}
