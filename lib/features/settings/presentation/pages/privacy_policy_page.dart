import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

// todo details
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: I18nKeys.privacyPolicy.tr,
      body: (context, child) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: May 2024',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              '1. Information Collection',
              'We collect limited information to provide a better experience. This includes account data (if provided) and local configuration settings stored on your device via SharedPreferences and Secure Storage.',
            ),
            _buildSection(
              context,
              '2. Third-Party Services',
              'This app may use third-party libraries for networking (Dio) and state management (Riverpod). These libraries do not collect personally identifiable information unless explicitly stated.',
            ),
            _buildSection(
              context,
              '3. Data Security',
              'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure.',
            ),
            _buildSection(
              context,
              '4. Children\'s Privacy',
              'These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children.',
            ),
            _buildSection(
              context,
              '5. Data Deletion',
              'Users can request the deletion of their local data by using the "Reset All Settings" and "Clear Cache" features in the app settings.',
            ),
            _buildSection(
              context,
              'Contact Us',
              'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at listen2code@gmail.com.',
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
