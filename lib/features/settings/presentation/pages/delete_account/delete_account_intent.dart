import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'delete_account_intent.freezed.dart';

@freezed
class DeleteAccountIntent extends BaseIntent with _$DeleteAccountIntent {
  const factory DeleteAccountIntent.toggleConfirm() = _ToggleConfirm;
  const factory DeleteAccountIntent.deleteAccount() = _DeleteAccount;
  const DeleteAccountIntent._();
}
