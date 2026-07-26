import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class DeleteAccountConfirmActions extends StatelessWidget {
  final bool isConfirmed;
  final VoidCallback onToggleConfirm;
  final VoidCallback onDeleteAccount;

  const DeleteAccountConfirmActions({
    super.key,
    required this.isConfirmed,
    required this.onToggleConfirm,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, 1.f),
              child: SizedBox(
                width: 24.f,
                height: 24.f,
                child: Checkbox(
                  value: isConfirmed,
                  onChanged: (val) => onToggleConfirm(),
                  activeColor: Colors.red,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            SizedBox(width: 12.f),
            CommonButton(
              text: I18nKeys.deleteAccountIUnderstand.tr,
              type: ButtonType.text,
              isFullWidth: false,
              padding: EdgeInsets.zero,
              foregroundColor: context.isDark ? Colors.white70 : Colors.black87,
              fontSize: 13.f,
              onPressed: onToggleConfirm,
            ),
          ],
        ),
        SizedBox(height: 24.f),
        CommonButton(
          text: I18nKeys.deleteAccount.tr,
          onPressed: isConfirmed ? onDeleteAccount : null,
          backgroundColor: Colors.red,
          borderRadius: 12.f,
          height: 56.f,
        ),
      ],
    );
  }
}
