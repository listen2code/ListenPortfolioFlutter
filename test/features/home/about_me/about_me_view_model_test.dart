import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/upload_avatar_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_about_me_use_case.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/about_me_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../test_helpers/test_setup.dart';

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
class MockUploadAvatarUseCase extends Mock implements UploadAvatarUseCase {}

class MockImagePicker extends Mock implements ImagePicker {}

// Platform channel for image_picker (used to mock the internal ImagePicker instance)
const _imagePickerChannel = MethodChannel('plugins.flutter.io/image_picker');
late String _testImagePath;

void main() async {
  // 初始化测试绑定
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Initialize test environment for network access
  await setupTestEnvironment();

  group('AboutMeViewModel Tests', () {
    late ProviderContainer container;
    late AboutMeViewModel viewModel;
    late MockGetAboutMeUseCase mockGetAboutMeUseCase;
    late MockUploadAvatarUseCase mockUploadAvatarUseCase;
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

    // Controls what the image_picker platform channel mock returns per test
    String? mockImagePickerPath; // null = cancelled
    bool mockImagePickerThrows = false;

    setUp(() async {
      // Mock SharedPreferences for SpUtil
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');

      _testImagePath = '${Directory.systemTemp.path}/test_image.jpg';
      final testFile = File(_testImagePath);
      if (!await testFile.exists()) {
        await testFile.create(recursive: true);
        await testFile.writeAsBytes([0, 1, 2]);
      }
      mockImagePickerPath = _testImagePath;

      mockGetAboutMeUseCase = MockGetAboutMeUseCase();
      mockUploadAvatarUseCase = MockUploadAvatarUseCase();
      mockImagePicker = MockImagePicker();

      // Stub upload to return success
      when(() => mockUploadAvatarUseCase.call(param: any(named: 'param')))
          .thenAnswer((_) async => const Right(null));

      // Mock image_picker platform channel — ViewModel creates ImagePicker() internally
      mockImagePickerPath = _testImagePath;
      mockImagePickerThrows = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        _imagePickerChannel,
        (call) async {
          if (mockImagePickerThrows) {
            throw PlatformException(code: 'CAMERA_ERROR', message: 'Camera error');
          }
          return mockImagePickerPath;
        },
      );

      container = ProviderContainer(
        overrides: [
          getAboutMeUseCaseProvider.overrideWith((ref) => mockGetAboutMeUseCase),
          uploadAvatarUseCaseProvider.overrideWith((ref) => mockUploadAvatarUseCase),
        ],
      );

      // Keep provider alive during async operations to prevent auto-dispose
      container.listen(aboutMeViewModelProvider, (_, __) {}, fireImmediately: false);

      authManager.login(const UserModel(id: '1', name: 'Test User'));
      viewModel = container.read(aboutMeViewModelProvider.notifier);
      emittedEffects.clear();
      viewModel.onBindEffect((effect) => emittedEffects.add(effect));
    });

    tearDown(() async {
      // Wait for any pending async operations before disposing
      await Future.delayed(Duration(milliseconds: 100));
      container.dispose();
      
      final testFile = File(_testImagePath);
      if (await testFile.exists()) {
        await testFile.delete();
      }
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
        when(() => mockGetAboutMeUseCase.call(param: null)).thenAnswer((_) async => Right(testAboutMeModel));

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
        when(() => mockGetAboutMeUseCase.call(param: null)).thenAnswer((_) async => const Left(failure));

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
        when(() => mockGetAboutMeUseCase.call(param: null)).thenAnswer((_) async => Right(emptyAboutMeModel));

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
        when(
          () => mockGetAboutMeUseCase.call(param: null),
        ).thenAnswer((_) async => const Left(networkFailure));

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
      test('should emit PickImageEffect on pickImage intent', () async {
        await viewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.camera));
        
        final effect = emittedEffects.firstWhere((e) => e is PickImageEffect) as PickImageEffect;
        expect(effect.source, equals(ImageSource.camera));
      });

      test('should emit CropAvatarEffect on imagePicked', () async {
        final testFile = File(_testImagePath);
        await viewModel.handleIntent(AboutMeIntent.imagePicked(testFile));
        await Future.delayed(const Duration(milliseconds: 100));

        final effect = emittedEffects.firstWhere((e) => e is CropAvatarEffect) as CropAvatarEffect;
        expect(effect.imageFile.path, equals(_testImagePath));
        expect(effect.onResult, isNotNull);
      });

      test('should successfully update state and upload on imageCropped', () async {
        final testFile = File(_testImagePath);
        await viewModel.handleIntent(AboutMeIntent.imageCropped(testFile));
        await Future.delayed(const Duration(milliseconds: 100));

        // State imageFile remains testFile because mockUploadAvatarUseCase returns null, which doesn't trigger successful userModel state update resets
        final state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNotNull);
        expect(state.imageFile!.path, _testImagePath);
        verify(() => mockUploadAvatarUseCase.call(param: any(named: 'param'))).called(1);
      });

      test('should handle null image selection', () async {
        await viewModel.handleIntent(const AboutMeIntent.imagePicked(null));
        await Future.delayed(const Duration(milliseconds: 100));

        final state = container.read(aboutMeViewModelProvider);
        expect(state.imageFile, isNull);
        expect(emittedEffects.any((e) => e is NavigationEffect && (e as NavigationEffect).isBack), isFalse);
      });
    });

    group('Remove Image Intent Tests', () {
      test('should remove existing image file', () async {
        // Set up initial image state
        final testFile = File(_testImagePath);
        await viewModel.handleIntent(AboutMeIntent.imageCropped(testFile));
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
        when(() => mockGetAboutMeUseCase.call(param: null)).thenAnswer((_) async => Right(testAboutMeModel));

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
        when(() => mockGetAboutMeUseCase.call(param: null)).thenAnswer((_) async => Right(testAboutMeModel));

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
        when(() => mockGetAboutMeUseCase.call(param: null)).thenAnswer((_) async => Right(testAboutMeModel));

        // Act: First refresh data, then pick image via imagePicked intent
        await viewModel.handleIntent(const AboutMeIntent.refresh());
        await Future.delayed(const Duration(milliseconds: 300));

        final testFile = File(_testImagePath);
        await viewModel.handleIntent(AboutMeIntent.imageCropped(testFile));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert: Verify both data and image are maintained
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isTrue);
        expect(state.data, equals(testAboutMeModel));
        expect(state.imageFile, isNotNull);
        expect(state.imageFile!.path, _testImagePath);
      });

      test('should handle rapid state changes', () async {
        // Arrange: Mock use case
        when(() => mockGetAboutMeUseCase.call(param: null)).thenAnswer((_) async => Right(testAboutMeModel));

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

    group('Share Intent Tests', () {
      test('should emit ShareEffect with app github link', () async {
        // Act
        await viewModel.handleIntent(const AboutMeIntent.shareApp());

        // Assert
        final shareEffects = emittedEffects.whereType<ShareEffect>().toList();
        expect(shareEffects, isNotEmpty);
        final effect = shareEffects.last;
        expect(effect.files, isNull);
        expect(effect.text, contains(AppConstants.github));
      });
    });

    group('Error Handling Tests', () {
      test('should handle use case parameter errors', () async {
        // Arrange: Mock use case to throw exception
        when(() => mockGetAboutMeUseCase.call(param: null)).thenThrow(Exception('Invalid parameter'));

        // The exception propagates through dispatch/ZoneManager and rejects the Future
        await expectLater(viewModel.handleIntent(const AboutMeIntent.refresh()), throwsA(isA<Exception>()));

        // State must remain unchanged since the exception prevented update
        final state = container.read(aboutMeViewModelProvider);
        expect(state.isInitialLoaded, isFalse);
        expect(state.data, isNull);
      });

      test('should handle state update errors gracefully', () async {
        // Arrange: Mock use case for successful call
        when(() => mockGetAboutMeUseCase.call(param: null)).thenAnswer((_) async => Right(testAboutMeModel));

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
