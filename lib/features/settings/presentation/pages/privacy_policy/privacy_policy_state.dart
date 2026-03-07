import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'privacy_policy_state.freezed.dart';

@freezed
abstract class PrivacyPolicyState extends BaseState with _$PrivacyPolicyState {
  const factory PrivacyPolicyState({@Default('May 2026') String lastUpdated}) = _PrivacyPolicyState;

  const PrivacyPolicyState._();
}
