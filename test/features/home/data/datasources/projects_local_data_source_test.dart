import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/projects_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProjectsLocalDataSource Tests', () {
    late ProjectsLocalDataSource dataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');
      dataSource = ProjectsLocalDataSource();
    });

    final mockProjects = <ProjectModel>[
      const ProjectModel(
        id: 'proj_1',
        title: 'Listen Portfolio App',
        desc: 'Flutter cross-platform application',
        techStack: ['Flutter', 'Dart', 'Riverpod'],
      ),
      const ProjectModel(
        id: 'proj_2',
        title: 'Listen Expense Tracker',
        desc: 'Android expense tracking application',
        techStack: ['Kotlin', 'Jetpack Compose', 'Room'],
      ),
    ];

    test('getCached returns null when cache is empty', () async {
      final result = await dataSource.getCached();
      expect(result, isNull);
    });

    test('cache stores ProjectModel list and getCached retrieves it correctly', () async {
      await dataSource.cache(mockProjects);

      final result = await dataSource.getCached();
      expect(result, isNotNull);
      expect(result!.length, equals(2));

      expect(result[0].id, equals('proj_1'));
      expect(result[0].title, equals('Listen Portfolio App'));
      expect(result[0].desc, equals('Flutter cross-platform application'));
      expect(result[0].techStack, contains('Flutter'));

      expect(result[1].id, equals('proj_2'));
      expect(result[1].title, equals('Listen Expense Tracker'));
      expect(result[1].techStack, contains('Kotlin'));
    });

    test('getCached returns null on corrupted JSON string', () async {
      await SpUtil.put(AppConstants.projectsDataKey, '{invalid_projects_json');
      final result = await dataSource.getCached();
      expect(result, isNull);
    });
  });
}
