import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/services/referrer/install_referrer_data.dart';
import 'package:listen_portfolio_flutter/shared/services/referrer/install_referrer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('InstallReferrerData Parsing Tests', () {
    test('parses standard refer=XXX query string', () {
      const raw = 'refer=ListenCommunity';
      final data = InstallReferrerData.fromRawReferrer(raw);

      expect(data.rawReferrer, raw);
      expect(data.refer, 'ListenCommunity');
      expect(data.hasReferral, isTrue);
      expect(data.displaySource, 'ListenCommunity');
      expect(data.targetRoute, isNull);
    });

    test('parses url-encoded referrer with utm parameters and target route', () {
      const raw = 'utm_source%3Dtwitter%26refer%3DJohnDoe%26target%3Dprojects%26utm_campaign%3Dsummer';
      final data = InstallReferrerData.fromRawReferrer(raw);

      expect(data.refer, 'JohnDoe');
      expect(data.utmSource, 'twitter');
      expect(data.utmCampaign, 'summer');
      expect(data.targetRoute, 'projects');
      expect(data.hasReferral, isTrue);
      expect(data.displaySource, 'JohnDoe');
    });

    test('parses utm_source and utm_campaign without explicit refer', () {
      const raw = 'utm_source=github&utm_campaign=open_source';
      final data = InstallReferrerData.fromRawReferrer(raw);

      expect(data.refer, isNull);
      expect(data.utmSource, 'github');
      expect(data.utmCampaign, 'open_source');
      expect(data.hasReferral, isTrue);
      expect(data.displaySource, 'github (open_source)');
    });

    test('handles empty or blank referrer gracefully', () {
      final data = InstallReferrerData.fromRawReferrer('');
      expect(data.hasReferral, isFalse);
      expect(data.displaySource, '');
    });

    test('serializes and deserializes JSON cleanly', () {
      final original = InstallReferrerData(
        rawReferrer: 'refer=TestUser&target=aboutMe',
        refer: 'TestUser',
        utmSource: 'google',
        targetRoute: 'aboutMe',
        clickTimestampSeconds: 123456789,
        installTimestampSeconds: 123456799,
        googlePlayInstant: false,
      );

      final jsonStr = original.toJsonString();
      final restored = InstallReferrerData.fromJsonString(jsonStr);

      expect(restored, isNotNull);
      expect(restored!.refer, 'TestUser');
      expect(restored.utmSource, 'google');
      expect(restored.targetRoute, 'aboutMe');
      expect(restored.clickTimestampSeconds, 123456789);
    });
  });

  group('InstallReferrerService Tests', () {
    late IInstallReferrerService service;

    setUp(() {
      service = InstallReferrerServiceImpl();
    });

    test('hasProcessedReferrer returns false initially and true after mark', () async {
      expect(await service.hasProcessedReferrer(), isFalse);
      await service.markReferrerProcessed();
      expect(await service.hasProcessedReferrer(), isTrue);
    });

    test('saveReferrerData and getSavedReferrerData roundtrip', () async {
      expect(await service.getSavedReferrerData(), isNull);

      final sample = InstallReferrerData.fromRawReferrer('refer=DevMeetup&target=aboutMe');
      await service.saveReferrerData(sample);

      final saved = await service.getSavedReferrerData();
      expect(saved, isNotNull);
      expect(saved!.refer, 'DevMeetup');
      expect(saved.targetRoute, 'aboutMe');
    });

    test('simulateReferrer persists and returns simulated data', () async {
      final result = await service.simulateReferrer('refer=SimulatedSource&target=projects');
      expect(result.refer, 'SimulatedSource');
      expect(result.targetRoute, 'projects');

      final saved = await service.getSavedReferrerData();
      expect(saved?.refer, 'SimulatedSource');
    });
  });
}
