import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../login_state.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final LoginState state;
  final ValueChanged<String> onUsernameChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onToggleRememberMe;
  final VoidCallback onTapForgotPassword;

  const LoginFormFields({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.state,
    required this.onUsernameChanged,
    required this.onPasswordChanged,
    required this.onToggleRememberMe,
    required this.onTapForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Username
        CommonTextField(
          controller: usernameController,
          type: TextFieldType.text,
          labelText: I18nKeys.username.tr,
          prefixIcon: Icons.person_outline,
          errorText: state.usernameError,
          onChanged: onUsernameChanged,
        ),
        const SizedBox(height: 20),
        // Password
        CommonTextField(
          controller: passwordController,
          type: TextFieldType.password,
          labelText: I18nKeys.password.tr,
          prefixIcon: Icons.lock_outline,
          errorText: state.passwordError,
          onChanged: onPasswordChanged,
        ),
        // Remember Me & Forgot Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 1),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: state.rememberMe,
                        activeColor: accentColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (_) => onToggleRememberMe(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: CommonButton(
                      text: I18nKeys.rememberMe.tr,
                      type: ButtonType.text,
                      isFullWidth: false,
                      height: 40,
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.grey,
                      fontSize: 14.f,
                      onPressed: onToggleRememberMe,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 2,
              child: CommonButton(
                text: I18nKeys.forgotPassword.tr,
                type: ButtonType.text,
                isFullWidth: false,
                height: 40,
                padding: EdgeInsets.zero,
                fontSize: 14.f,
                onPressed: onTapForgotPassword,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
