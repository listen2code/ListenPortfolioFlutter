import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/resume_local_data_source.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ResumeLocalDataSource Tests', () {
    late ResumeLocalDataSource dataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');
      dataSource = ResumeLocalDataSource();
    });

    test('getCached returns null when cache is empty', () async {
      final result = await dataSource.getCached();
      expect(result, isNull);
    });

    test('cache stores markdown string and getCached retrieves it correctly', () async {
      const sampleMarkdown = '# John Doe Resume\n\nSenior Software Engineer';
      await dataSource.cache(sampleMarkdown);

      final result = await dataSource.getCached();
      expect(result, equals(sampleMarkdown));
    });
  });
}
