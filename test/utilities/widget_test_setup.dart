// Utility to pump widgets with Riverpod providers for tests
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  // Ensure any async actions settle
  await tester.pumpAndSettle();
}
