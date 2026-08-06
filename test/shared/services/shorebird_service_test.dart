import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class MockShorebirdUpdater extends Mock implements ShorebirdUpdater {}

void main() {
  late MockShorebirdUpdater mockUpdater;
  late ShorebirdServiceImpl service;

  setUp(() {
    mockUpdater = MockShorebirdUpdater();
    service = ShorebirdServiceImpl(updater: mockUpdater);
  });

  group('ShorebirdServiceImpl Unit Tests', () {
    test('isAvailable returns correct state from updater', () {
      when(() => mockUpdater.isAvailable).thenReturn(true);
      expect(service.isAvailable, isTrue);

      when(() => mockUpdater.isAvailable).thenReturn(false);
      expect(service.isAvailable, isFalse);
    });

    test('checkForUpdate returns true when update is available (outdated)', () async {
      when(() => mockUpdater.isAvailable).thenReturn(true);
      when(() => mockUpdater.checkForUpdate()).thenAnswer((_) async => UpdateStatus.outdated);

      final hasUpdate = await service.checkForUpdate();

      expect(hasUpdate, isTrue);
      expect(service.status, ShorebirdCodePushStatus.updateAvailable);
    });

    test('checkForUpdate returns false when upToDate', () async {
      when(() => mockUpdater.isAvailable).thenReturn(true);
      when(() => mockUpdater.checkForUpdate()).thenAnswer((_) async => UpdateStatus.upToDate);

      final hasUpdate = await service.checkForUpdate();

      expect(hasUpdate, isFalse);
      expect(service.status, ShorebirdCodePushStatus.upToDate);
    });

    test('checkForUpdate handles exception gracefully', () async {
      when(() => mockUpdater.isAvailable).thenReturn(true);
      when(() => mockUpdater.checkForUpdate()).thenThrow(Exception('Network error'));

      final hasUpdate = await service.checkForUpdate();

      expect(hasUpdate, isFalse);
      expect(service.status, ShorebirdCodePushStatus.error);
    });

    test('downloadUpdate downloads patch successfully', () async {
      when(() => mockUpdater.isAvailable).thenReturn(true);
      when(() => mockUpdater.update()).thenAnswer((_) async {});

      final success = await service.downloadUpdate();

      expect(success, isTrue);
      expect(service.status, ShorebirdCodePushStatus.patchDownloaded);
    });

    test('downloadUpdate handles UpdateException', () async {
      when(() => mockUpdater.isAvailable).thenReturn(true);
      when(() => mockUpdater.update()).thenThrow(
        const UpdateException(message: 'Download failed', reason: UpdateFailureReason.unknown),
      );

      final success = await service.downloadUpdate();

      expect(success, isFalse);
      expect(service.status, ShorebirdCodePushStatus.error);
    });

    test('getFormattedVersion appends Patch # when running a patch', () async {
      when(() => mockUpdater.isAvailable).thenReturn(true);
      when(() => mockUpdater.readCurrentPatch()).thenAnswer((_) async => const Patch(number: 3));

      expect(await service.isRunningPatch, isTrue);
      expect(await service.getFormattedVersion('1.1.11+1'), '1.1.11+1 (Patch #3)');
    });

    test('getFormattedVersion returns base version when no patch installed', () async {
      when(() => mockUpdater.isAvailable).thenReturn(true);
      when(() => mockUpdater.readCurrentPatch()).thenAnswer((_) async => null);

      expect(await service.isRunningPatch, isFalse);
      expect(await service.getFormattedVersion('1.1.11+1'), '1.1.11+1');
    });

    test('checkAndInstallPatch checks, downloads and executes callback when update available', () async {
      when(() => mockUpdater.isAvailable).thenReturn(true);
      when(() => mockUpdater.checkForUpdate()).thenAnswer((_) async => UpdateStatus.outdated);
      when(() => mockUpdater.update()).thenAnswer((_) async {});

      bool callbackInvoked = false;
      final result = await service.checkAndInstallPatch(
        onPatchDownloaded: () {
          callbackInvoked = true;
        },
      );

      expect(result, isTrue);
      expect(callbackInvoked, isTrue);
      expect(service.status, ShorebirdCodePushStatus.patchDownloaded);
    });
  });
}
