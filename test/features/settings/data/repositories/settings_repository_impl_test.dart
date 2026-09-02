import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SettingsRepositoryImpl repository;
  late MockSettingsRemoteDataSource mockRemote;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (MethodCall call) async => ['wifi'],
        );

    mockRemote = MockSettingsRemoteDataSource();
    repository = SettingsRepositoryImpl(remoteDataSource: mockRemote);
  });

  const mockVersionJson = '''
  {
    "version": "1.2.0",
    "buildNumber": 10200,
    "url": "https://example.com/app.apk",
    "changelog": {
      "zh": "修复问题并提升性能",
      "en": "Bug fixes and performance improvements"
    }
  }
  ''';

  group('SettingsRepositoryImpl Tests', () {
    test('getLatestVersion returns VersionModel on remote success', () async {
      when(() => mockRemote.getLatestVersion())
          .thenAnswer((_) async => mockVersionJson);

      final result = await repository.getLatestVersion();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (versionModel) {
          expect(versionModel.version, equals('1.2.0'));
          expect(versionModel.buildNumber, equals(10200));
          expect(versionModel.url, equals('https://example.com/app.apk'));
          expect(versionModel.changelog['zh'], equals('修复问题并提升性能'));
        },
      );
      verify(() => mockRemote.getLatestVersion()).called(1);
    });

    test('getLatestVersion returns Left Failure on exception', () async {
      when(() => mockRemote.getLatestVersion())
          .thenThrow(Exception('Network timeout'));

      final result = await repository.getLatestVersion();

      expect(result.isLeft(), isTrue);
      verify(() => mockRemote.getLatestVersion()).called(1);
    });
  });
}
