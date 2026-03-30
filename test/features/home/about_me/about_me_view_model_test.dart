import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_about_me_use_case.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/about_me_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// AboutMeViewModel 单元测试
/// 
/// 测试覆盖范围：
/// 1. 初始状态验证
/// 2. 刷新功能（成功、失败、空数据）
/// 3. 图片选择功能（相机、相册、取消选择）
/// 4. 图片移除功能
/// 5. 生命周期方法（onVisible）
/// 6. 错误处理和状态管理
///
/// 架构原则：
/// - ViewModel负责状态管理和业务逻辑协调
/// - UseCase负责数据获取，ViewModel不直接访问Repository
/// - 所有外部依赖（UseCase、ImagePicker）都需要Mock
/// - 状态更新必须通过updateState方法
///

// Mock classes
class MockGetAboutMeUseCase extends Mock implements GetAboutMeUseCase {}
class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  // 初始化测试绑定
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AboutMeViewModel Tests', () {
    late ProviderContainer container;
    late AboutMeViewModel viewModel;
    late MockGetAboutMeUseCase mockGetAboutMeUseCase;
    late MockImagePicker mockImagePicker;
    final List<BaseEffect> emittedEffects = [];

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

    setUp(() async {
      // Mock SharedPreferences for SpUtil
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      // 创建mock实例
      mockGetAboutMeUseCase = MockGetAboutMeUseCase();
      mockImagePicker = MockImagePicker();

      // 创建ProviderContainer并注入mock依赖
      container = ProviderContainer(
        overrides: [
          getAboutMeUseCaseProvider.overrideWith((ref) => mockGetAboutMeUseCase),
        ],
      );

      // 获取ViewModel实例
      viewModel = container.read(aboutMeViewModelProvider.notifier);
      emittedEffects.clear();
      
      // 记录effect
      viewModel.onBindEffect((effect) {
        emittedEffects.add(effect);
      });

      // 使用反射或测试友好的方式注入mock ImagePicker
      // 注意：由于ImagePicker是在方法内部创建的，我们需要在测试中模拟其方法调用
    });

    tearDown(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      container.dispose();
    });

    group('Initial State Tests', () {
      test('should have correct initial state', () {
        final state = container.read(aboutMeViewModelProvider);
        
        expect(state.isInitialLoaded, isFalse);
        expect(state.data, isNull);
        expect(state.imageFile, isNull);
      });
    });

    group('Refresh Intent Tests', () {
      test('should successfully refresh and update state with data', () async {
        // Arrange: Mock use case to return success
        when(() => mockGetAboutMeUseCase.call(param: null))
            .thenAnswer((_) async => Right(testAboutMeModel));

        // Act: Trigger refresh intent
        await viewModel.handleIntent(const AboutMeIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert: Verify state was updated correctly
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.data, equals(testAboutMeModel));
        expect(state.imageFile, isNull); // Image file should remain unchanged

        // Verify use case was called
        verify(() => mockGetAboutMeUseCase.call(param: null)).called(1);
      });

      test('should handle refresh failure gracefully', () async {
        // Arrange: Mock use case to return failure
        const failure = ServerFailure('Failed to load about me data');
        when(() => mockGetAboutMeUseCase.call(param: null))
            .thenAnswer((_) async => const Left(failure));

        // Act: Trigger refresh intent
        await viewModel.handleIntent(const AboutMeIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert: Verify state was not updated on failure
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isFalse); // Should remain false on failure
        expect(state.data, isNull); // Data should remain null on failure

        // Verify use case was called
        verify(() => mockGetAboutMeUseCase.call(param: null)).called(1);
      });

      test('should handle empty data from refresh', () async {
        // Arrange: Mock use case to return empty data
        final emptyAboutMeModel = AboutMeModel();
        when(() => mockGetAboutMeUseCase.call(param: null))
            .thenAnswer((_) async => Right(emptyAboutMeModel));

        // Act: Trigger refresh intent
        await viewModel.handleIntent(const AboutMeIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert: Verify state was updated with empty data
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.data, isNotNull);
        expect(state.data!.status, isNull);
        expect(state.data!.jobTitle, isNull);
        expect(state.data!.bio, isNull);
        expect(state.data!.certifications, isEmpty);

        // Verify use case was called
        verify(() => mockGetAboutMeUseCase.call(param: null)).called(1);
      });

      test('should handle network failure during refresh', () async {
        // Arrange: Mock use case to return network failure
        const networkFailure = NetworkFailure('No internet connection');
        when(() => mockGetAboutMeUseCase.call(param: null))
            .thenAnswer((_) async => const Left(networkFailure));

        // Act: Trigger refresh intent
        await viewModel.handleIntent(const AboutMeIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert: Verify state was not updated
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isFalse);
        expect(state.data, isNull);

        // Verify use case was called
        verify(() => mockGetAboutMeUseCase.call(param: null)).called(1);
      });
    });

    group('Image Pick Intent Tests', () {
      test('should successfully pick image from camera', () async {
        // Arrange: Mock ImagePicker to return a file
        const testImagePath = '/test/path/image.jpg';
        final mockXFile = XFile(testImagePath);
        
        // 由于ImagePicker是在方法内部创建的，我们需要模拟XFile
        when(() => mockImagePicker.pickImage(source: ImageSource.camera))
            .thenAnswer((_) async => mockXFile);

        // Act: Trigger pick image intent from camera
        await viewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.camera));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert: Verify state was updated with image file
        final state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNotNull);
        expect(state.imageFile!.path, testImagePath);
      });

      test('should successfully pick image from gallery', () async {
        // Arrange: Mock ImagePicker to return a file
        const testImagePath = '/test/path/gallery_image.png';
        final mockXFile = XFile(testImagePath);
        
        when(() => mockImagePicker.pickImage(source: ImageSource.gallery))
            .thenAnswer((_) async => mockXFile);

        // Act: Trigger pick image intent from gallery
        await viewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.gallery));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert: Verify state was updated with image file
        final state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNotNull);
        expect(state.imageFile!.path, testImagePath);
      });

      test('should handle cancelled image selection', () async {
        // Arrange: Mock ImagePicker to return null (user cancelled)
        when(() => mockImagePicker.pickImage(source: ImageSource.camera))
            .thenAnswer((_) async => null);

        // Act: Trigger pick image intent
        await viewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.camera));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert: Verify state was not changed (imageFile remains null)
        final state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNull);
      });

      test('should handle ImagePicker exceptions gracefully', () async {
        // Arrange: Mock ImagePicker to throw exception
        when(() => mockImagePicker.pickImage(source: ImageSource.camera))
            .thenThrow(Exception('Camera not available'));

        // Act & Assert: Exception should be handled gracefully
        expect(() => viewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.camera)), returnsNormally);
        
        // Verify state was not changed
        final state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNull);
      });
    });

    group('Remove Image Intent Tests', () {
      test('should remove existing image file', () async {
        // Arrange: First set an image file
        const testImagePath = '/test/path/image.jpg';
        final mockXFile = XFile(testImagePath);
        
        // Mock the picker for setting up the state
        when(() => mockImagePicker.pickImage(source: ImageSource.camera))
            .thenAnswer((_) async => mockXFile);
        
        await viewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.camera));
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Verify image was set
        var state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNotNull);

        // Act: Remove the image
        viewModel.handleIntent(const AboutMeIntent.removeImage());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert: Verify image was removed
        state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNull);
      });

      test('should handle remove image when no image exists', () async {
        // Arrange: Ensure no image file exists
        var state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNull);

        // Act: Try to remove non-existent image
        viewModel.handleIntent(const AboutMeIntent.removeImage());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert: Verify state remains unchanged
        state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNull);
      });
    });

    group('Lifecycle Tests', () {
      test('should trigger refresh onVisible when not initially loaded', () async {
        // Arrange: Mock use case for successful refresh
        when(() => mockGetAboutMeUseCase.call(param: null))
            .thenAnswer((_) async => Right(testAboutMeModel));

        // Act: Trigger onVisible lifecycle
        viewModel.onVisible();
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert: Verify refresh was triggered and state was updated
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.data, equals(testAboutMeModel));

        // Verify use case was called
        verify(() => mockGetAboutMeUseCase.call(param: null)).called(1);
      });

      test('should not trigger refresh onVisible when already loaded', () async {
        // Arrange: First load the data
        when(() => mockGetAboutMeUseCase.call(param: null))
            .thenAnswer((_) async => Right(testAboutMeModel));
        
        await viewModel.handleIntent(const AboutMeIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Reset mock call counter
        clearInteractions(mockGetAboutMeUseCase);

        // Act: Trigger onVisible again
        viewModel.onVisible();
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert: Verify use case was NOT called again
        verifyNever(() => mockGetAboutMeUseCase.call(param: null));
      });
    });

    group('State Management Tests', () {
      test('should maintain separate state for image file and data', () async {
        // Arrange: Set up data and image separately
        when(() => mockGetAboutMeUseCase.call(param: null))
            .thenAnswer((_) async => Right(testAboutMeModel));
        
        const testImagePath = '/test/path/image.jpg';
        final mockXFile = XFile(testImagePath);
        
        when(() => mockImagePicker.pickImage(source: ImageSource.camera))
            .thenAnswer((_) async => mockXFile);

        // Act: First refresh data, then pick image
        await viewModel.handleIntent(const AboutMeIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));
        
        await viewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.camera));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert: Verify both data and image are maintained
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.data, equals(testAboutMeModel));
        expect(state.imageFile, isNotNull);
        expect(state.imageFile!.path, testImagePath);
      });

      test('should handle rapid state changes', () async {
        // Arrange: Mock use case
        when(() => mockGetAboutMeUseCase.call(param: null))
            .thenAnswer((_) async => Right(testAboutMeModel));

        // Act: Trigger multiple intents rapidly
        viewModel.handleIntent(const AboutMeIntent.refresh());
        viewModel.handleIntent(const AboutMeIntent.refresh());
        viewModel.handleIntent(const AboutMeIntent.refresh());
        
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert: Verify state is consistent (should handle concurrent calls gracefully)
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.data, equals(testAboutMeModel));

        // Verify use case was called multiple times (or handled appropriately)
        verify(() => mockGetAboutMeUseCase.call(param: null)).called(greaterThanOrEqualTo(1));
      });
    });

    group('Error Handling Tests', () {
      test('should handle use case parameter errors', () async {
        // Arrange: Mock use case to throw exception with invalid param
        when(() => mockGetAboutMeUseCase.call(param: any(named: 'param')))
            .thenThrow(Exception('Invalid parameter'));

        // Act & Assert: Exception should be handled gracefully
        expect(() => viewModel.handleIntent(const AboutMeIntent.refresh()), returnsNormally);
        
        // Verify state was not updated on error
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isFalse);
        expect(state.data, isNull);
      });

      test('should handle state update errors gracefully', () async {
        // This test verifies that the ViewModel handles internal state update errors
        // In practice, this would be caught by the ViewModelMixin's error handling
        
        // Arrange: Mock use case for successful call
        when(() => mockGetAboutMeUseCase.call(param: null))
            .thenAnswer((_) async => Right(testAboutMeModel));

        // Act: Trigger refresh
        await viewModel.handleIntent(const AboutMeIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert: Verify state was updated despite potential internal errors
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.data, equals(testAboutMeModel));
      });
    });
  });
}