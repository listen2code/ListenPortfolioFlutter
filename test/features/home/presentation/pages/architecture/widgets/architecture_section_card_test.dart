import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/widgets/architecture_section_card.dart';
import 'package:mocktail/mocktail.dart';

class MockArchitectureViewModel extends Mock implements ArchitectureViewModel {}
class FakeArchitectureIntent extends Fake implements ArchitectureIntent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeArchitectureIntent());
  });

  group('ArchitectureSectionCard Widget Tests', () {
    late MockArchitectureViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockArchitectureViewModel();
      when(() => mockViewModel.handleIntent(any())).thenAnswer((_) async => null);
    });

    testWidgets('should render section title and content correctly', (WidgetTester tester) async {
      const section = ArchitectureSection(
        title: 'Core Layers',
        content: 'This represents core layered architecture.',
        icon: Icons.layers_outlined,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArchitectureSectionCard(
              section: section,
              viewModel: mockViewModel,
            ),
          ),
        ),
      );

      // Verify title, content and icon are displayed
      expect(find.text('Core Layers'), findsOneWidget);
      expect(find.text('This represents core layered architecture.'), findsOneWidget);
      expect(find.byIcon(Icons.layers_outlined), findsOneWidget);
    });

    testWidgets('should render list of library items when provided', (WidgetTester tester) async {
      const section = ArchitectureSection(
        title: 'Libraries',
        content: 'List of dependencies:',
        icon: Icons.collections_bookmark_outlined,
        libs: [
          ArchitectureLibItem(name: 'Riverpod', desc: 'State management'),
          ArchitectureLibItem(name: 'Mocktail', desc: 'Mocking framework'),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArchitectureSectionCard(
              section: section,
              viewModel: mockViewModel,
            ),
          ),
        ),
      );

      // RichText elements are evaluated using widget predicate to match RichText content
expect(find.byWidgetPredicate((widget) => widget is RichText && widget.text.toPlainText().contains('Riverpod')), findsOneWidget);
expect(find.byWidgetPredicate((widget) => widget is RichText && widget.text.toPlainText().contains('State management')), findsOneWidget);
expect(find.byWidgetPredicate((widget) => widget is RichText && widget.text.toPlainText().contains('Mocktail')), findsOneWidget);
expect(find.byWidgetPredicate((widget) => widget is RichText && widget.text.toPlainText().contains('Mocking framework')), findsOneWidget);
      // expect(find.textContaining('Riverpod'), findsOneWidget); // removed duplicate
      // expect(find.textContaining('State management'), findsOneWidget); // removed duplicate
       // expect(find.textContaining('Mocktail'), findsOneWidget); // removed duplicate
       // expect(find.textContaining('Mocking framework'), findsOneWidget); // removed duplicate
    });

    testWidgets('should render link button and trigger launchURL callback on tap', (WidgetTester tester) async {
      const section = ArchitectureSection(
        title: 'More Info',
        content: 'Click link below to read more.',
        icon: Icons.info_outline,
        linkLabel: 'Documentation',
        linkUrl: 'https://docs.example.com',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArchitectureSectionCard(
              section: section,
              viewModel: mockViewModel,
            ),
          ),
        ),
      );

      // Verify button label is present
      expect(find.text('Documentation'), findsOneWidget);

      // Tap link button
      await tester.tap(find.text('Documentation'));
      await tester.pump();

      // Verify viewModel received launchURL intent
      verify(() => mockViewModel.handleIntent(const ArchitectureIntent.launchURL('https://docs.example.com'))).called(1);
    });
  });
}
