import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'privacy_policy_intent.dart';
import 'privacy_policy_state.dart';

part 'privacy_policy_view_model.g.dart';

@riverpod
class PrivacyPolicyViewModel extends _$PrivacyPolicyViewModel
    with ViewModelMixin<PrivacyPolicyState, PrivacyPolicyIntent> {
  @override
  PrivacyPolicyState build() => const PrivacyPolicyState();

  @override
  FutureOr<void> onIntent(PrivacyPolicyIntent intent) {
    intent.when(refresh: () => _onRefresh());
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true));
    await Future.delayed(const Duration(milliseconds: 1000));
    emitEffect(LoadingEffect(false));
  }
}
