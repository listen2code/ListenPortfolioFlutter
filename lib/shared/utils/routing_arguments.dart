// Strongly-typed routing argument containers for cross-page parameter passing.
// These DTOs are instantiated either directly by callers or deserialized from
// query parameter maps parsed by AppNav during deep link dispatching.

/// Arguments passed to the [SignUpPage].
class SignUpArguments {
  /// Initial username prefilled in the registration form.
  final String? initialUsername;
  
  const SignUpArguments({this.initialUsername});

  /// Deserializes a raw query parameter or navigation [map] into a [SignUpArguments] instance.
  factory SignUpArguments.fromMap(Map<String, dynamic> map) {
    return SignUpArguments(
      initialUsername: (map['username'] ?? map['initial_username'] ?? map['name']) as String?,
    );
  }

  @override
  String toString() => 'SignUpArguments(initialUsername: $initialUsername)';
}

/// Arguments passed to the [SettingsPage].
class SettingsArguments {
  /// Whether to automatically trigger an in-app OTA / version update check upon page render.
  final bool checkUpdate;

  const SettingsArguments({this.checkUpdate = false});

  /// Deserializes a raw query parameter or navigation [map] into a [SettingsArguments] instance.
  /// Handles both boolean values and string representations ('true' / 'false') from deep links.
  factory SettingsArguments.fromMap(Map<String, dynamic> map) {
    final val = map['check_update'] ?? map['checkUpdate'];
    return SettingsArguments(
      checkUpdate: val == 'true' || val == true,
    );
  }

  @override
  String toString() => 'SettingsArguments(checkUpdate: $checkUpdate)';
}

/// Arguments passed to the [CrashLogListPage].
class CrashLogListArguments {
  /// Target file path of a crash dump to highlight or display immediately.
  final String? filePath;

  const CrashLogListArguments({this.filePath});

  /// Deserializes a raw query parameter or navigation [map] into a [CrashLogListArguments] instance.
  factory CrashLogListArguments.fromMap(Map<String, dynamic> map) {
    return CrashLogListArguments(
      filePath: (map['file_path'] ?? map['filePath'] ?? map['file_path']) as String?,
    );
  }

  @override
  String toString() => 'CrashLogListArguments(filePath: $filePath)';
}
