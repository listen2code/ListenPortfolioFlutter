import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'privacy_policy_state.freezed.dart';

@freezed
abstract class PrivacyPolicyState extends BaseState with _$PrivacyPolicyState {
  const factory PrivacyPolicyState({
    @Default('') String lastUpdated,
    @Default([]) List<PrivacySection> sections,
  }) = _PrivacyPolicyState;

  const PrivacyPolicyState._();
}

@freezed
abstract class PrivacySection with _$PrivacySection {
  const factory PrivacySection({required String title, required String content}) = _PrivacySection;
}
