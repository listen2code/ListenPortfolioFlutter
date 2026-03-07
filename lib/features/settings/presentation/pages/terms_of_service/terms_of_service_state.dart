import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'terms_of_service_state.freezed.dart';

@freezed
abstract class TermsOfServiceState extends BaseState with _$TermsOfServiceState {
  const factory TermsOfServiceState() = _TermsOfServiceState;
  const TermsOfServiceState._();
}
