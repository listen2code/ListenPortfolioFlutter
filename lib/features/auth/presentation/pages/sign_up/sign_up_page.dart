import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/shared.dart';
import 'sign_up_intent.dart';
import 'sign_up_state.dart';
import 'sign_up_view_model.dart';
import 'widgets/sign_up_action_buttons.dart';
import 'widgets/sign_up_form_fields.dart';
import 'widgets/sign_up_header.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  // Controllers are kept to maintain cursor position and text selection during reactive updates
  late final TextEditingController _nameController;
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(signUpViewModelProvider);
    _nameController = TextEditingController(text: initialState.fullName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseRefreshPage<SignUpViewModel, SignUpState>(
      isEmptyTitle: true,
      provider: signUpViewModelProvider,
      body: (context, child, viewModel, state) => SingleChildScrollView(
        padding: EdgeInsets.all(20.f),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SignUpHeader(),
            SizedBox(height: 40.f),
            SignUpFormFields(
              nameController: _nameController,
              emailController: _emailController,
              pwdController: _pwdController,
              confirmPwdController: _confirmPwdController,
              state: state,
              onNameChanged: (val) => viewModel.handleIntent(SignUpIntent.fullNameChanged(val)),
              onEmailChanged: (val) => viewModel.handleIntent(SignUpIntent.emailChanged(val)),
              onPasswordChanged: (val) => viewModel.handleIntent(SignUpIntent.passwordChanged(val)),
              onConfirmPasswordChanged: (val) => viewModel.handleIntent(SignUpIntent.confirmPasswordChanged(val)),
            ),
            SizedBox(height: 40.f),
            SignUpActionButtons(
              onSubmitSignUp: () => viewModel.handleIntent(const SignUpIntent.submitSignUp()),
              onTapLogin: () => viewModel.handleIntent(const SignUpIntent.navigateToLogin()),
            ),
            SizedBox(height: 40.f),
          ],
        ),
      ),
    );
  }
}

