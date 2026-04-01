import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'terms_of_service_intent.freezed.dart';

@freezed
class TermsOfServiceIntent extends BaseIntent with _$TermsOfServiceIntent {
  const factory TermsOfServiceIntent.init() = _Init;
  const TermsOfServiceIntent._();
}
