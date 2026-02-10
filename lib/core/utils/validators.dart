/// Utility class for form validation
class Validators {
  Validators._();

  /// Validates email format
  static String? validateEmail(String? value, {required String requiredMsg, required String invalidMsg}) {
    if (value == null || value.isEmpty) return requiredMsg;

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return invalidMsg;

    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value, {required String requiredMsg, required String minLengthMsg}) {
    if (value == null || value.isEmpty) return requiredMsg;
    if (value.length < 6) return minLengthMsg;
    return null;
  }

  /// Validates username
  static String? validateUsername(String? value, {required String requiredMsg, required String minLengthMsg}) {
    if (value == null || value.isEmpty) return requiredMsg;
    if (value.length < 3) return minLengthMsg;
    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, {required String errorMsg}) {
    if (value == null || value.isEmpty) return errorMsg;
    return null;
  }

  /// Validates password confirmation
  static String? validatePasswordConfirmation(
    String? password,
    String? confirmation, {
    required String requiredMsg,
    required String mismatchMsg,
  }) {
    if (confirmation == null || confirmation.isEmpty) return requiredMsg;
    if (password != confirmation) return mismatchMsg;
    return null;
  }
}
