import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/about_me_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AboutMeLocalDataSource Tests', () {
    late AboutMeLocalDataSource dataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');
      dataSource = AboutMeLocalDataSource();
    });

    const mockModel = AboutMeModel(
      name: 'Listen',
      jobTitle: 'Senior Flutter Developer',
      bio: 'Building awesome cross-platform apps.',
    );

    test('getCached returns null when cache is empty', () async {
      final result = await dataSource.getCached();
      expect(result, isNull);
    });

    test('cache stores AboutMeModel and getCached retrieves it correctly', () async {
      await dataSource.cache(mockModel);

      final result = await dataSource.getCached();
      expect(result, isNotNull);
      expect(result!.name, equals('Listen'));
      expect(result.jobTitle, equals('Senior Flutter Developer'));
      expect(result.bio, equals('Building awesome cross-platform apps.'));
    });

    test('getCached returns null on corrupted JSON', () async {
      await SpUtil.put(AppConstants.aboutMeDataKey, '{{corrupted_json');
      final result = await dataSource.getCached();
      expect(result, isNull);
    });
  });
}
