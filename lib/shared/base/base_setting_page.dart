import 'package:flutter/material.dart';
import '../shared.dart';

/// ============================================================================
/// BaseSettingPage
/// ============================================================================
/// A root-level reactive wrapper widget connecting [SettingManager] to Flutter's
/// widget hierarchy via [ListenableBuilder].
///
/// ### Architecture & Rebuild Minimization:
/// - By wrapping the top-level [BaseMaterialApp] inside `BaseSettingPage`, any change
///   to theme mode, accent color, font size, or font family immediately triggers a
///   targeted rebuild of the root theme without reconstructing unrelated background
///   singletons or tear-downs of navigational state.
/// - Merges [settingManager] with optional [extraListenable] instances for flexible
///   multi-observable synchronization.
class BaseSettingPage extends StatelessWidget {
  /// Builder function constructing the reactive child tree.
  final TransitionBuilder builder;

  /// Optional auxiliary listenables to observe alongside [settingManager].
  final List<Listenable>? extraListenable;

  const BaseSettingPage({super.key, required this.builder, this.extraListenable});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([settingManager, ...?extraListenable]),
      builder: (context, child) {
        return builder(context, child);
      },
    );
  }
}
