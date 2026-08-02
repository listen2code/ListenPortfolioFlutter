import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../test_helpers/test_setup.dart';

class TestState extends BaseState {
  const TestState();
}

class TestIntent extends BaseIntent {
  const TestIntent();
}

class TestLifecycleViewModel extends Notifier<TestState> with ViewModelMixin<TestState, TestIntent> {
  int onVisibleCount = 0;
  int onInVisibleCount = 0;

  @override
  TestState build() => const TestState();

  @override
  void onVisible() {
    super.onVisible();
    onVisibleCount++;
  }

  @override
  void onInVisible() {
    super.onInVisible();
    onInVisibleCount++;
  }

  @override
  FutureOr<void> onIntent(TestIntent intent) {}
}

final testLifecycleViewModelProvider =
    NotifierProvider<TestLifecycleViewModel, TestState>(() => TestLifecycleViewModel());

void main() async {
  await setupTestEnvironment();

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('Lifecycle Route Filtering Tests', () {
    testWidgets('should filter out Dialog transitions but execute on PageRoute transitions', (WidgetTester tester) async {
      late TestLifecycleViewModel viewModel;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            navigatorObservers: [AppNav.observer],
            home: Consumer(
              builder: (context, ref, child) {
                viewModel = ref.read(testLifecycleViewModelProvider.notifier);
                return BaseLifeCyclePage(
                  viewModel: viewModel,
                  body: (context, child) => const Scaffold(
                    body: Center(child: Text('First Page')),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // 1. Initial push of the page
      await tester.pump();
      expect(viewModel.onVisibleCount, 1);
      expect(viewModel.onInVisibleCount, 0);

      // 2. Open a dialog (which is a PopupRoute/DialogRoute)
      final BuildContext pageContext = tester.element(find.text('First Page'));
      showDialog(
        context: pageContext,
        builder: (context) => const AlertDialog(
          title: Text('Test Dialog'),
        ),
      );
      await tester.pumpAndSettle();

      // Opening a dialog should NOT trigger onInVisible on the underlying page
      expect(viewModel.onInVisibleCount, 0);

      // 3. Close the dialog
      Navigator.of(tester.element(find.text('Test Dialog'))).pop();
      await tester.pumpAndSettle();

      // Closing the dialog should NOT trigger onVisible again on the underlying page
      expect(viewModel.onVisibleCount, 1);
      expect(viewModel.onInVisibleCount, 0);

      // 4. Push a new full PageRoute on top of the first page
      Navigator.of(pageContext).push(
        MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Second Page')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Pushing a new page route SHOULD trigger onInVisible
      expect(viewModel.onInVisibleCount, 1);

      // 5. Pop the second page to return to the first page
      Navigator.of(tester.element(find.text('Second Page'))).pop();
      await tester.pumpAndSettle();

      // Returning from a page route SHOULD trigger onVisible again
      expect(viewModel.onVisibleCount, 2);
      expect(viewModel.onInVisibleCount, 1);
    });
  });
}
