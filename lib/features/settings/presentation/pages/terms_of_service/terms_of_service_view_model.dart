import 'dart:async';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'terms_of_service_intent.dart';
import 'terms_of_service_state.dart';

part 'terms_of_service_view_model.g.dart';

@riverpod
class TermsOfServiceViewModel extends _$TermsOfServiceViewModel
    with ViewModelMixin<TermsOfServiceState, TermsOfServiceIntent> {
  @override
  TermsOfServiceState build() => const TermsOfServiceState();

  @override
  FutureOr<void> onIntent(TermsOfServiceIntent intent) {
    return intent.when<FutureOr<void>>(init: _onInit);
  }

  Future<void> _onInit() async {
    // Initialization logic for Terms of Service if needed
  }
}
