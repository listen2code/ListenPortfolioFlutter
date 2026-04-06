import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import '../../../../../shared/shared.dart';
import 'package:listen_uikit/uikit.dart';

import 'terms_of_service_state.dart';
import 'terms_of_service_view_model.dart';

class TermsOfServicePage extends ConsumerWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<TermsOfServiceViewModel, TermsOfServiceState>(
      title: I18nKeys.termsOfService.tr,
      provider: termsOfServiceViewModelProvider,
      body: (context, child, viewModel, state) {
        if (state == null || state.sections.isEmpty) return null;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.f),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.lastUpdated.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 20.f),
                  child: Text(
                    'Last Updated: ${state.lastUpdated}',
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ),
              ...state.sections.map((section) => _buildSection(context, section.title, section.content)),
              SizedBox(height: 40.f),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          SizedBox(height: 8.f),
          Text(content, style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}
