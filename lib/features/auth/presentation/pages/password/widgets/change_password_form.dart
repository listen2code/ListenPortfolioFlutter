import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../change_password_intent.dart';
import '../change_password_state.dart';
import '../change_password_view_model.dart';

class ChangePasswordForm extends StatelessWidget {
  final TextEditingController oldPwdController;
  final TextEditingController newPwdController;
  final TextEditingController confirmPwdController;
  final ChangePasswordViewModel viewModel;
  final ChangePasswordState state;

  const ChangePasswordForm({
    super.key,
    required this.oldPwdController,
    required this.newPwdController,
    required this.confirmPwdController,
    required this.viewModel,
    required this.state,
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
          onChanged: (val) => viewModel.handleIntent(ChangePasswordIntent.oldPasswordChanged(val)),
        ),
        SizedBox(height: 20.f),
        // New Password Input
        CommonTextField(
          controller: newPwdController,
          type: TextFieldType.password,
          labelText: I18nKeys.newPassword.tr,
          prefixIcon: Icons.lock_reset_outlined,
          errorText: state.newPasswordError,
          onChanged: (val) => viewModel.handleIntent(ChangePasswordIntent.newPasswordChanged(val)),
        ),
        SizedBox(height: 20.f),
        // Confirm New Password Input
        CommonTextField(
          controller: confirmPwdController,
          type: TextFieldType.password,
          labelText: I18nKeys.confirmNewPassword.tr,
          prefixIcon: Icons.lock_outline,
          errorText: state.confirmPasswordError,
          onChanged: (val) => viewModel.handleIntent(ChangePasswordIntent.confirmPasswordChanged(val)),
        ),
        SizedBox(height: 40.f),
        // Update Action
        CommonButton(
          text: I18nKeys.updatePassword.tr,
          onPressed: () => viewModel.handleIntent(const ChangePasswordIntent.submitChange()),
          borderRadius: 15,
          height: 56.f,
        ),
      ],
    );
  }
}
