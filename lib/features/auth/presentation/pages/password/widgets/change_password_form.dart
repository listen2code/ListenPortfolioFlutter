import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../change_password_state.dart';

class ChangePasswordForm extends StatelessWidget {
  final TextEditingController oldPwdController;
  final TextEditingController newPwdController;
  final TextEditingController confirmPwdController;
  final ChangePasswordState state;
  final ValueChanged<String> onOldPasswordChanged;
  final ValueChanged<String> onNewPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final VoidCallback onSubmit;

  const ChangePasswordForm({
    super.key,
    required this.oldPwdController,
    required this.newPwdController,
    required this.confirmPwdController,
    required this.state,
    required this.onOldPasswordChanged,
    required this.onNewPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current Password Input
        CommonTextField(
          controller: oldPwdController,
          type: TextFieldType.password,
          labelText: I18nKeys.oldPassword.tr,
          prefixIcon: Icons.lock_outline,
          errorText: state.oldPasswordError,
          onChanged: onOldPasswordChanged,
        ),
        SizedBox(height: 20.f),
        // New Password Input
        CommonTextField(
          controller: newPwdController,
          type: TextFieldType.password,
          labelText: I18nKeys.newPassword.tr,
          prefixIcon: Icons.lock_reset_outlined,
          errorText: state.newPasswordError,
          onChanged: onNewPasswordChanged,
        ),
        SizedBox(height: 20.f),
        // Confirm New Password Input
        CommonTextField(
          controller: confirmPwdController,
          type: TextFieldType.password,
          labelText: I18nKeys.confirmNewPassword.tr,
          prefixIcon: Icons.lock_outline,
          errorText: state.confirmPasswordError,
          onChanged: onConfirmPasswordChanged,
        ),
        SizedBox(height: 40.f),
        // Update Action
        CommonButton(
          text: I18nKeys.updatePassword.tr,
          onPressed: onSubmit,
          borderRadius: 15,
          height: 56.f,
        ),
      ],
    );
  }
}
