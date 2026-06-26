import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/shared.dart';
import 'change_password_state.dart';
import 'change_password_view_model.dart';
import 'widgets/change_password_form.dart';
import 'widgets/change_password_header.dart';

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
            const ChangePasswordHeader(),
            SizedBox(height: 40.f),
            ChangePasswordForm(
              oldPwdController: _oldPwdController,
              newPwdController: _newPwdController,
              confirmPwdController: _confirmPwdController,
              viewModel: viewModel,
              state: state,
            ),
          ],
        ),
      ),
    );
  }
}

