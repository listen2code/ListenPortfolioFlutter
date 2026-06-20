import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import 'privacy_policy_state.dart';
import 'privacy_policy_view_model.dart';

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<PrivacyPolicyViewModel, PrivacyPolicyState>(
      provider: privacyPolicyViewModelProvider,
      title: I18nKeys.privacyPolicy.tr,
      body: (context, child, viewModel, state) {
        return const CommonWebView(initialUrl: AppConstants.githubPagePrivacyPolicy);
      },
    );
  }
}
