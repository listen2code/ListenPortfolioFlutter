import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ============================================================================
/// Test Harness: Riverpod Widget Test Setup
/// ============================================================================
///
/// Utility function to mount and render widgets within a sandboxed [ProviderScope]
/// and a default [MaterialApp] shell for headless widget testing.
///
/// Key Capabilities:
/// 1. **Dependency Inversion Injection via [overrides]**:
///    Enables injecting mock or fake providers (e.g., `mockAuthRepository`,
///    `fakeSettingManager`, `fakeNavigationEffectHandler`) without modifying
///    production widget code.
/// 2. **Asynchronous Drain & Stabilization**:
///    Invokes [tester.pumpAndSettle] to drain the event loop, trigger pending
///    microtasks, and wait for initial animations/transitions to resolve to
///    an idle frame state.
///
/// Usage Example:
/// ```dart
/// await pumpWidgetWithProviders(
///   tester,
///   const LoginCard(),
///   overrides: [
///     authViewModelProvider.overrideWith((ref) => mockAuthViewModel),
///   ],
/// );
/// expect(find.byType(CustomTextField), findsNWidgets(2));
/// ```
Future<void> pumpWidgetWithProviders(
  WidgetTester tester,
  Widget widget, {
  List<Override>? overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        home: widget,
      ),
    ),
  );
  // Ensure any async actions settle (microtasks, initial animations, frame callbacks)
  await tester.pumpAndSettle();
}
