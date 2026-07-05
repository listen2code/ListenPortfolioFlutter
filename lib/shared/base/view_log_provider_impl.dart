import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

import '../../features/settings/presentation/pages/crash_log_list/widgets/crash_log_details_sheet.dart';

/// Effect that requests the UI to display the contents of a crash log [file]
/// in a modal bottom sheet.
class ViewLogEffect extends BaseEffect {
  final File file;

  ViewLogEffect(this.file);

  @override
  String toString() => 'ViewLogEffect(file: ${file.path})';
}

/// Handles [ViewLogEffect] by reading the file and presenting
/// [CrashLogDetailsSheet] via [AppNavConfig.context].
///
/// Registered globally in [AppInitializer] so that any feature can emit
/// [ViewLogEffect] without holding a [BuildContext].
class ViewLogProviderImpl extends BaseProvider<ViewLogEffect> {
  const ViewLogProviderImpl();

  @override
  void handleEffect(ViewLogEffect effect) async {
    final context = AppNavConfig.context;
    if (context == null) return;

    final String content;
    try {
      content = await effect.file.readAsString();
    } catch (e) {
      appLogger.e('ViewLogProviderImpl: Failed to read log file', error: e);
      return;
    }

    if (!context.mounted) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CrashLogDetailsSheet(
        content: content,
        fileName: effect.file.path.split('/').last,
      ),
    );
  }
}
