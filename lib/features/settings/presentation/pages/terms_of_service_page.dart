import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/shared/base/base_page.dart';
import 'package:listen_portfolio_flutter/shared/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text.dart';

// todo details
class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: I18nKeys.termsOfService.tr,
      body: (context, child) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Updated: May 2024', style: context.textTheme.bodySmall?.copyWith(color: Colors.grey)),
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
      ),
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
