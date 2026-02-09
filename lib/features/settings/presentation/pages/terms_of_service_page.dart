import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseStatelessPage(
      title: I18nKeys.termsOfService.tr,
      padding: const EdgeInsets.all(20),
      body: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            context,
            '1. Acceptance of Terms',
            'By accessing or using lPortfolio, you agree to be bound by these Terms of Service and all applicable laws and regulations.',
          ),
          _buildSection(
            context,
            '2. Use License',
            'Permission is granted to temporarily download one copy of the materials on lPortfolio for personal, non-commercial transitory viewing only.',
          ),
          _buildSection(
            context,
            '3. Disclaimer',
            'The materials on lPortfolio are provided on an "as is" basis. lPortfolio makes no warranties, expressed or implied.',
          ),
          _buildSection(
            context,
            '4. Limitations',
            'In no event shall lPortfolio or its suppliers be liable for any damages arising out of the use or inability to use the materials.',
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
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
