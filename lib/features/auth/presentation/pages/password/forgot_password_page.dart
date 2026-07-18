import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/shared.dart';
import 'forgot_password_intent.dart';
import 'forgot_password_state.dart';
import 'forgot_password_view_model.dart';
import 'widgets/forgot_password_form.dart';
import 'widgets/forgot_password_header.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseRefreshPage<ForgotPasswordViewModel, ForgotPasswordState>(
      isEmptyTitle: true,
      provider: forgotPasswordViewModelProvider,
      body: (context, child, viewModel, state) => SingleChildScrollView(
        padding: EdgeInsets.all(20.f),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ForgotPasswordHeader(),
            SizedBox(height: 48.f),
            ForgotPasswordForm(
              emailController: _emailController,
              state: state,
              onEmailChanged: (val) => viewModel.handleIntent(ForgotPasswordIntent.emailChanged(val)),
              onSubmitReset: () => viewModel.handleIntent(const ForgotPasswordIntent.submitReset()),
              onTapLogin: () => viewModel.handleIntent(const ForgotPasswordIntent.navigateToLogin()),
            ),
          ],
        ),
      ),
    );
  }
}

