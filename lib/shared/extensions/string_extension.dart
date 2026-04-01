import 'package:listen_core/core.dart';

extension StringUrlExtension on String {
  /// Converts a mock URL (starting with localhost) to a full API URL using the current environment's base URL.
  String toApiUrl() {
    if (isEmpty) return this;
    if (startsWith('localhost')) {
      return replaceFirst('localhost', AppEnv.apiBaseUrl);
    }
    return this;
  }
}
