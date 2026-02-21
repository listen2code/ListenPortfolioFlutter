import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class ArchitectureWidget extends StatelessWidget {
  const ArchitectureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 30.f),
              _buildCleanMVISection(context),
              SizedBox(height: 25.f),
              _buildLibSection(context),
              SizedBox(height: 25.f),
              _buildSourceCodeSection(context),
              SizedBox(height: 25.f),
              _buildBackendSection(context),
              SizedBox(height: 30.f),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      I18nKeys.architectureHeader.tr,
      style: context.textTheme.bodyLarge?.copyWith(color: Colors.grey, height: 1.5),
    );
  }

  Widget _buildCleanMVISection(BuildContext context) {
    return _buildCard(
      context,
      title: I18nKeys.cleanMVITitle.tr,
      icon: Icons.layers_outlined,
      child: Text(
        'The app follows Clean Architecture principles to separate concerns into Data, Domain, and Presentation layers. '
        'On the Presentation layer, the MVI (Model-View-Intent) pattern ensures unidirectional data flow.',
        style: context.textTheme.bodyMedium?.copyWith(height: 1.6),
      ),
    );
  }

  Widget _buildLibSection(BuildContext context) {
    final libs = [
      {'name': 'Riverpod', 'desc': 'State management & DI'},
      {'name': 'Freezed', 'desc': 'Code generation for immutable states'},
      {'name': 'Dio & Retrofit', 'desc': 'Type-safe networking'},
      {'name': 'Fpdart', 'desc': 'Functional programming (Either/Option)'},
    ];

    return _buildCard(
      context,
      title: I18nKeys.coreLibrariesTitle.tr,
      icon: Icons.library_books_outlined,
      child: Column(children: libs.map((lib) => _buildLibItem(context, lib['name']!, lib['desc']!)).toList()),
    );
  }

  Widget _buildSourceCodeSection(BuildContext context) {
    final accentColor = context.accentColor;
    return _buildCard(
      context,
      title: I18nKeys.openSourceTitle.tr,
      icon: Icons.code_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(I18nKeys.openSourceDesc.tr, style: context.textTheme.bodyMedium?.copyWith(height: 1.6)),
          SizedBox(height: 15.f),
          InkWell(
            onTap: () => _launchURL(context, AppConstants.github),
            borderRadius: BorderRadius.circular(8.f),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.f),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.link, size: 18.f, color: accentColor),
                  SizedBox(width: 8.f),
                  Expanded(
                    child: CommonText(
                      'github.com/listen2code',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
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

  Widget _buildBackendSection(BuildContext context) {
    return _buildCard(
      context,
      title: I18nKeys.backendDevOpsTitle.tr,
      icon: Icons.cloud_done_outlined,
      child: Text(
        'The backend services are deployed on AWS using a serverless approach. Key services include Lambda, API Gateway, and DynamoDB.',
        style: context.textTheme.bodyMedium?.copyWith(height: 1.6),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final theme = context.theme;
    final accentColor = context.accentColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.f),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.f),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.f, offset: Offset(0, 5.f)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 24.f),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonText(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.f),
          child,
        ],
      ),
    );
  }

  Widget _buildLibItem(BuildContext context, String name, String desc) {
    final accentColor = context.accentColor;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.f),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: accentColor.withValues(alpha: 0.8), size: 18.f),
          SizedBox(width: 12.f),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: context.textTheme.bodyMedium,
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
        CommonToast.show('${I18nKeys.noEmailApp.tr}: $urlString');
      }
    }
  }
}
