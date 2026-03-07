import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'delete_account_state.freezed.dart';

@freezed
abstract class DeleteAccountState extends BaseState with _$DeleteAccountState {
  const factory DeleteAccountState({@Default(false) bool isConfirmed}) = _DeleteAccountState;
  const DeleteAccountState._();
}
