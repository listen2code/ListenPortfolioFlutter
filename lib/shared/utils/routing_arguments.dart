/// Strong typed routing argument containers for cross-page parameter passing.
class SignUpArguments {
  final String? initialUsername;
  
  const SignUpArguments({this.initialUsername});

  factory SignUpArguments.fromMap(Map<String, dynamic> map) {
    return SignUpArguments(
      initialUsername: (map['username'] ?? map['initial_username'] ?? map['name']) as String?,
    );
  }

  @override
  String toString() => 'SignUpArguments(initialUsername: $initialUsername)';
}

class SettingsArguments {
  final bool checkUpdate;

  const SettingsArguments({this.checkUpdate = false});

  factory SettingsArguments.fromMap(Map<String, dynamic> map) {
    final val = map['check_update'] ?? map['checkUpdate'];
    return SettingsArguments(
      checkUpdate: val == 'true' || val == true,
    );
  }

  @override
  String toString() => 'SettingsArguments(checkUpdate: $checkUpdate)';
}

class CrashLogListArguments {
  final String? filePath;

  const CrashLogListArguments({this.filePath});

  factory CrashLogListArguments.fromMap(Map<String, dynamic> map) {
    return CrashLogListArguments(
      filePath: (map['file_path'] ?? map['filePath'] ?? map['file_path']) as String?,
    );
  }

  @override
  String toString() => 'CrashLogListArguments(filePath: $filePath)';
}
