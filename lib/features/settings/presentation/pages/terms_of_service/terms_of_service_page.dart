import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';
import 'terms_of_service_state.dart';
import 'terms_of_service_view_model.dart';
import '../../../../../shared/shared.dart';

class TermsOfServicePage extends ConsumerWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<TermsOfServiceViewModel, TermsOfServiceState>(
      provider: termsOfServiceViewModelProvider,
      title: I18nKeys.termsOfService.tr,
      body: (context, child, viewModel, state) {
        return const CommonWebView(initialUrl: AppConstants.githubPageTermsOfService);
      },
    );
  }
}
