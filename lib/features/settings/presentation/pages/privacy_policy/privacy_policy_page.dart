import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/privacy_policy/privacy_policy_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/privacy_policy/privacy_policy_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<PrivacyPolicyViewModel, PrivacyPolicyState>(
      provider: privacyPolicyViewModelProvider,
      title: I18nKeys.privacyPolicy.tr,
      body: (context, child, viewModel, state) => SingleChildScrollView(
        padding: EdgeInsets.all(20.f),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              'Last Updated: ${state?.lastUpdated ?? ''}',
              style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 20.f),
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
            SizedBox(height: 40.f),
          ],
        ),
      ),
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
