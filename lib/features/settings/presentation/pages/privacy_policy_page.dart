import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseStatelessPage(
      title: I18nKeys.privacyPolicy.tr,
      padding: const EdgeInsets.all(20),
      body: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            context,
            'Introduction',
            'This Privacy Policy describes how lPortfolio collects, uses, and shares your personal information.',
          ),
          _buildSection(
            context,
            'Data Collection',
            'We collect information you provide directly to us, such as when you create an account or contact us. This may include your name, email, and preferences.',
          ),
          _buildSection(
            context,
            'Data Usage',
            'Your data is used to provide and improve the app services, customize your experience, and communicate with you about updates.',
          ),
          _buildSection(
            context,
            'Data Storage',
            'We use industry-standard security measures to protect your data stored locally and on our secure servers.',
          ),
          _buildSection(
            context,
            'Your Rights',
            'You have the right to access, correct, or delete your personal information at any time through the app settings.',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}
