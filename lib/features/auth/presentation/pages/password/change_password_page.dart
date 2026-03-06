import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _oldPwdController = TextEditingController();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  @override
  void dispose() {
    _oldPwdController.dispose();
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseRefreshPage<ChangePasswordViewModel, ChangePasswordState>(
      isEmptyTitle: true,
      provider: changePasswordViewModelProvider,
      body: (context, child, viewModel, state) => SingleChildScrollView(
        padding: EdgeInsets.all(20.f),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.f),
            CommonText(
              I18nKeys.changePassword.tr,
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 12.f),
            CommonText(
              I18nKeys.changePasswordSubtitle.tr,
              style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
              maxLines: 2,
            ),
            SizedBox(height: 40.f),
            // Current Password Input
            CommonTextField(
              controller: _oldPwdController,
              type: TextFieldType.password,
              labelText: I18nKeys.oldPassword.tr,
              prefixIcon: Icons.lock_outline,
              errorText: state?.oldPasswordError,
              onChanged: (val) => viewModel?.handleIntent(ChangePasswordIntent.oldPasswordChanged(val)),
            ),
            SizedBox(height: 20.f),
            // New Password Input
            CommonTextField(
              controller: _newPwdController,
              type: TextFieldType.password,
              labelText: I18nKeys.newPassword.tr,
              prefixIcon: Icons.lock_reset_outlined,
              errorText: state?.newPasswordError,
              onChanged: (val) => viewModel?.handleIntent(ChangePasswordIntent.newPasswordChanged(val)),
            ),
            SizedBox(height: 20.f),
            // Confirm New Password Input
            CommonTextField(
              controller: _confirmPwdController,
              type: TextFieldType.password,
              labelText: I18nKeys.confirmNewPassword.tr,
              prefixIcon: Icons.lock_outline,
              errorText: state?.confirmPasswordError,
              onChanged: (val) => viewModel?.handleIntent(ChangePasswordIntent.confirmPasswordChanged(val)),
            ),
            SizedBox(height: 40.f),
            // Update Action
            CommonButton(
              text: I18nKeys.updatePassword.tr,
              onPressed: () => viewModel?.handleIntent(const ChangePasswordIntent.submitChange()),
              borderRadius: 15,
              height: 56.f,
            ),
          ],
        ),
      ),
    );
  }
}
