import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerWidget({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: _selectedColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
        ),
        const SizedBox(height: 20),
        _buildRGBSlider('R', (_selectedColor.r * 255.0).round().clamp(0, 255), (val) {
          setState(() {
            _selectedColor = _selectedColor.withRed(val.toInt());
          });
          widget.onColorChanged(_selectedColor);
        }),
        _buildRGBSlider('G', (_selectedColor.g * 255.0).round().clamp(0, 255), (val) {
          setState(() {
            _selectedColor = _selectedColor.withGreen(val.toInt());
          });
          widget.onColorChanged(_selectedColor);
        }),
        _buildRGBSlider('B', (_selectedColor.b * 255.0).round().clamp(0, 255), (val) {
          setState(() {
            _selectedColor = _selectedColor.withBlue(val.toInt());
          });
          widget.onColorChanged(_selectedColor);
        }),
      ],
    );
  }

  Widget _buildRGBSlider(String label, int value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: CommonText(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 255,
            activeColor: label == 'R' ? Colors.red : (label == 'G' ? Colors.green : Colors.blue),
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 30, child: CommonText(value.toString())),
      ],
    );
  }
}
