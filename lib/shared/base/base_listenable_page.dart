import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

/// A base widget that listens to theme changes and provides a consistent
/// background gradient and system UI overlay style.
/// This widget does NOT include a Scaffold, making it ideal for fragments or tabs.
class BaseListenablePage extends StatelessWidget {
  final TransitionBuilder builder;
  final List<Listenable>? extraListenable;

  const BaseListenablePage({super.key, required this.builder, this.extraListenable});

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
