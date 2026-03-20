import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'terms_of_service_state.freezed.dart';

@freezed
abstract class TermsOfServiceState extends BaseState with _$TermsOfServiceState {
  const factory TermsOfServiceState({
    @Default('') String lastUpdated,
    @Default([]) List<TermsSection> sections,
  }) = _TermsOfServiceState;

  const TermsOfServiceState._();
}

@freezed
abstract class TermsSection with _$TermsSection {
  const factory TermsSection({required String title, required String content}) = _TermsSection;
}
