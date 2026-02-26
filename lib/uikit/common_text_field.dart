import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Predefined styles for common input scenarios
enum TextFieldType { text, password, email, number }

/// A reusable text input component based on TextFormField.
/// Supports password toggling, input limiting, and centralized styling.
class CommonTextField extends StatefulWidget {
  /// Controls the text being edited
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts
  final String? hintText;

  /// Text that describes the input field (floats when focused)
  final String? labelText;

  /// Text that appears below the field when validation fails
  final String? errorText;

  /// The logical type of the field (affects keyboard and obscure logic)
  final TextFieldType type;

  /// Icon to display at the beginning of the text field
  final IconData? prefixIcon;

  /// Callback when the text value changes
  final ValueChanged<String>? onChanged;

  /// Function to validate the input text
  final FormFieldValidator<String>? validator;

  /// The type of action button to show on the keyboard
  final TextInputAction? textInputAction;

  /// Maximum number of characters allowed
  final int? maxLength;

  /// If true, restricts input to numeric characters only
  final bool isDigitsOnly;

  /// Manually override the keyboard layout (e.g., phone, url)
  final TextInputType? keyboardType;

  /// The color to use for icons and focus. If null, uses the theme's primary color or icon color.
  final Color? accentColor;

  const CommonTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.type = TextFieldType.text,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.maxLength,
    this.isDigitsOnly = false,
    this.keyboardType,
    this.accentColor,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve the most appropriate color:
    // 1. Manually passed accentColor
    // 2. Icon theme color (which usually holds our original accentColor)
    // 3. Primary color from ColorScheme
    final effectiveAccentColor = widget.accentColor ?? theme.iconTheme.color ?? theme.colorScheme.primary;

    final isPassword = widget.type == TextFieldType.password;

    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      obscureText: isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType ?? _getKeyboardType(),
      maxLength: widget.maxLength,
      inputFormatters: [if (widget.isDigitsOnly) FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        errorText: widget.errorText,
        // The color is now automatically picked up from inputDecorationTheme
        // if not explicitly styled here. Using effectiveAccentColor for manual Icons.
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: effectiveAccentColor) : null,
        suffixIcon: isPassword ? _buildPasswordToggle(effectiveAccentColor) : null,
      ),
    );
  }

  // Toggle visibility for password fields
  Widget _buildPasswordToggle(Color color) {
    return IconButton(
      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: color),
      onPressed: () => setState(() => _obscureText = !_obscureText),
    );
  }

  // Resolve default keyboard layout based on field type
  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.password:
        return TextInputType.visiblePassword;
      case TextFieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
