import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/widgets/color_picker_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ColorPickerWidget Widget Tests', () {
    testWidgets('should render RGB sliders and invoke onColorChanged callback', (WidgetTester tester) async {
      Color? pickedColor;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              initialColor: const Color(0xFF1E88E5),
              onColorChanged: (c) => pickedColor = c,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(3));

      // Drag Red slider
      await tester.drag(sliders.first, const Offset(50, 0));
      await tester.pumpAndSettle();

      expect(pickedColor, isNotNull);

      // Drag Green slider
      await tester.drag(sliders.at(1), const Offset(-30, 0));
      await tester.pumpAndSettle();

      // Drag Blue slider
      await tester.drag(sliders.last, const Offset(40, 0));
      await tester.pumpAndSettle();
    });
  });
}
