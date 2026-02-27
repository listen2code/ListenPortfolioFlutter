import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

/// Global specialized instance for this application
final authManager = BaseAuthManager<UserModel>();

/// A base widget that listens to theme changes and provides a consistent
/// background gradient and system UI overlay style.
/// This widget does NOT include a Scaffold, making it ideal for fragments or tabs.
class BaseAuthPage extends StatelessWidget {
  final TransitionBuilder builder;

  const BaseAuthPage({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authManager,
      builder: (context, child) {
        return builder(context, child);
      },
    );
  }
}
