import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/utils/snack_bar_util.dart';
import 'package:url_launcher/url_launcher.dart';

class ArchitectureWidget extends StatelessWidget {
  const ArchitectureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        final theme = Theme.of(context);
        final accentColor = settingManager.accentColor;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 30),
              _buildCleanMVISection(theme, accentColor),
              const SizedBox(height: 25),
              _buildLibSection(theme, accentColor),
              const SizedBox(height: 25),
              _buildSourceCodeSection(context, theme, accentColor),
              const SizedBox(height: 25),
              _buildBackendSection(theme, accentColor),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Text(
      I18nKeys.architectureHeader.tr,
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey, height: 1.5),
    );
  }

  Widget _buildCleanMVISection(ThemeData theme, Color accentColor) {
    return _buildCard(
      theme: theme,
      accentColor: accentColor,
      title: I18nKeys.cleanMVITitle.tr,
      icon: Icons.layers_outlined,
      child: Text(
        'The app follows Clean Architecture principles to separate concerns into Data, Domain, and Presentation layers. '
        'On the Presentation layer, the MVI (Model-View-Intent) pattern ensures unidirectional data flow.',
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
      ),
    );
  }

  Widget _buildLibSection(ThemeData theme, Color accentColor) {
    final libs = [
      {'name': 'Riverpod', 'desc': 'State management & DI'},
      {'name': 'Freezed', 'desc': 'Code generation for immutable states'},
      {'name': 'Dio & Retrofit', 'desc': 'Type-safe networking'},
      {'name': 'Fpdart', 'desc': 'Functional programming (Either/Option)'},
    ];

    return _buildCard(
      theme: theme,
      accentColor: accentColor,
      title: I18nKeys.coreLibrariesTitle.tr,
      icon: Icons.library_books_outlined,
      child: Column(
        children: libs.map((lib) => _buildLibItem(theme, accentColor, lib['name']!, lib['desc']!)).toList(),
      ),
    );
  }

  Widget _buildSourceCodeSection(BuildContext context, ThemeData theme, Color accentColor) {
    return _buildCard(
      theme: theme,
      accentColor: accentColor,
      title: I18nKeys.openSourceTitle.tr,
      icon: Icons.code_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(I18nKeys.openSourceDesc.tr, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => _launchURL(context, AppConstants.fullMail),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.link, size: 18, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    'github.com/listen2code',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackendSection(ThemeData theme, Color accentColor) {
    return _buildCard(
      theme: theme,
      accentColor: accentColor,
      title: I18nKeys.backendDevOpsTitle.tr,
      icon: Icons.cloud_done_outlined,
      child: Text(
        'The backend services are deployed on AWS using a serverless approach. Key services include Lambda, API Gateway, and DynamoDB.',
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
      ),
    );
  }

  Widget _buildCard({
    required ThemeData theme,
    required Color accentColor,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: CommonText(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildLibItem(ThemeData theme, Color accentColor, String name, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: accentColor.withValues(alpha: 0.8), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$name: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (context.mounted) {
        SnackBarUtil.show('${I18nKeys.noEmailApp.tr}: $urlString');
      }
    }
  }
}
