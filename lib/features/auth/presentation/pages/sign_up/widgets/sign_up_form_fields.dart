import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../sign_up_state.dart';

class SignUpFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController pwdController;
  final TextEditingController confirmPwdController;
  final SignUpState state;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;

  const SignUpFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.pwdController,
    required this.confirmPwdController,
    required this.state,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Name Input
        CommonTextField(
          controller: nameController,
          labelText: I18nKeys.fullName.tr,
          prefixIcon: Icons.person_outline,
          errorText: state.fullNameError,
          onChanged: onNameChanged,
        ),
        SizedBox(height: 20.f),
        // Email Input
        CommonTextField(
          controller: emailController,
          type: TextFieldType.email,
          labelText: I18nKeys.email.tr,
          prefixIcon: Icons.email_outlined,
          errorText: state.emailError,
          onChanged: onEmailChanged,
        ),
        SizedBox(height: 20.f),
        // Password Input
        CommonTextField(
          controller: pwdController,
          type: TextFieldType.password,
          labelText: I18nKeys.password.tr,
          prefixIcon: Icons.lock_outline,
          errorText: state.passwordError,
          onChanged: onPasswordChanged,
        ),
        SizedBox(height: 20.f),
        // Confirm Password Input
        CommonTextField(
          controller: confirmPwdController,
          type: TextFieldType.password,
          labelText: I18nKeys.confirmPassword.tr,
          prefixIcon: Icons.lock_outline,
          errorText: state.confirmPasswordError,
          onChanged: onConfirmPasswordChanged,
        ),
      ],
    );
  }
}
