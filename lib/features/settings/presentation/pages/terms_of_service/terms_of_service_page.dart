import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

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
        if (state == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Updated: May 2026',
                style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 20),
              _buildSection(
                context,
                '1. Agreement to Terms',
                'By accessing lPortfolio, you agree to be bound by these Terms of Service. If you do not agree with any part of these terms, you are prohibited from using this application.',
              ),
              _buildSection(
                context,
                '2. Intellectual Property',
                'The application and its original content (excluding user-provided data), features, and functionality are and will remain the exclusive property of the developer and its licensors.',
              ),
              _buildSection(
                context,
                '3. User Accounts',
                'When you create an account, you must provide information that is accurate and current. You are responsible for safeguarding the password that you use to access the Service.',
              ),
              _buildSection(
                context,
                '4. Prohibited Activities',
                'You agree not to engage in any activity that interferes with or disrupts the Service, including but not limited to reverse engineering, data mining, or unauthorized access to our systems.',
              ),
              _buildSection(
                context,
                '5. Limitation of Liability',
                'In no event shall the developer be liable for any indirect, incidental, special, or consequential damages resulting from your use or inability to use the service.',
              ),
              _buildSection(
                context,
                '6. Governing Law',
                'These Terms shall be governed and construed in accordance with the laws of your local jurisdiction, without regard to its conflict of law provisions.',
              ),
              _buildSection(
                context,
                '7. Changes to Terms',
                'We reserve the right to modify or replace these Terms at any time. It is your responsibility to check these Terms periodically for changes.',
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          Text(content, style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}
