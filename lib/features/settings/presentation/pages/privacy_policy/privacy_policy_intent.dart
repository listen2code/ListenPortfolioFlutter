import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'privacy_policy_intent.freezed.dart';

@freezed
class PrivacyPolicyIntent extends BaseIntent with _$PrivacyPolicyIntent {
  const factory PrivacyPolicyIntent.refresh() = _Refresh;

  const PrivacyPolicyIntent._();
}
