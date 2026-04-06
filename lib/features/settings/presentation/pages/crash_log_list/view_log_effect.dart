import 'dart:io';

import 'package:listen_core/core.dart';

/// Custom effect for viewing crash log details.
class ViewLogEffect extends BaseEffect {
  final File file;

  ViewLogEffect(this.file);

  @override
  String toString() {
    return 'ViewLogEffect(file: ${file.path})';
  }
}
