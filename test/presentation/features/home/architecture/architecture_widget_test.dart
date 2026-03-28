import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ArchitectureWidget Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('Should display architecture widget when active', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ArchitectureWidget(active: true))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ArchitectureWidget), findsOneWidget);
    });

    testWidgets('Should handle inactive state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ArchitectureWidget(active: false))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ArchitectureWidget), findsOneWidget);
    });
  });
}
