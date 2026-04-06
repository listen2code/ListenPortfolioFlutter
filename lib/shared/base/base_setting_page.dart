import 'package:flutter/material.dart';
import '../shared.dart';

/// A base widget that listens to theme changes and provides a consistent
/// background gradient and system UI overlay style.
/// This widget does NOT include a Scaffold, making it ideal for fragments or tabs.
class BaseSettingPage extends StatelessWidget {
  final TransitionBuilder builder;
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
