import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_toast.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_auth_text.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewWidget extends StatelessWidget {
  final VoidCallback onResumeRequested;
  final VoidCallback onProjectsRequested;
  final VoidCallback onArchitectureRequested;

  const OverviewWidget({
    super.key,
    required this.onResumeRequested,
    required this.onProjectsRequested,
    required this.onArchitectureRequested,
  });

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeHeader(context),
                    SizedBox(height: 16.f),
                    _buildStatusTag(context),
                    SizedBox(height: 24.f),
                    _buildExperienceGrid(context),
                    SizedBox(height: 28.f),
                    _buildSectionHeader(
                      context,
                      I18nKeys.quickActions.tr,
                      showSeeAll: false,
                      onPressed: () {},
                    ),
                    SizedBox(height: 12.f),
                    _buildQuickActions(context),
                    SizedBox(height: 28.f),
                    _buildSectionHeader(
                      context,
                      I18nKeys.featuredProjects.tr,
                      showSeeAll: true,
                      onPressed: onProjectsRequested,
                    ),
                    SizedBox(height: 12.f),
                  ],
                ),
              ),
              _buildFeaturedProjects(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final accentColor = context.accentColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          I18nKeys.hello.trArgs([AppConstants.author]),
          style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
        ),
        SizedBox(height: 4.f),
        Wrap(
          children: [
            CommonText(
              'Full Stack Mobile Architect (${I18nKeys.graduated.tr}',
              style: context.textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
            CommonAuthText(
              ' 2013 ',
              style: context.textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w600),
              maxLines: 1,
              blurLevel: AuthBlurLevel.low,
            ),
            CommonText(
              '| ${I18nKeys.softwareEngineering.tr})',
              style: context.textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
          ],
        ),
        SizedBox(height: 8.f),
        Row(
          children: [
            _buildCertBadge(accentColor, I18nKeys.jlptN1.tr),
            SizedBox(width: 8.f),
            _buildCertBadge(accentColor, I18nKeys.bjtJ2.tr),
          ],
        ),
      ],
    );
  }

  Widget _buildCertBadge(Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 3.f),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.f),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_outlined, size: 12.f, color: color),
          SizedBox(width: 4.f),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10.f, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 4.f),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.f),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: Colors.green, size: 6.f),
            SizedBox(width: 6.f),
            CommonText(
              I18nKeys.availableStatus.tr,
              style: context.textTheme.labelSmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceGrid(BuildContext context) {
    return Column(
      children: [
        _buildAndroidStatCard(
          context,
          '10${I18nKeys.yearsShort.tr}+',
          I18nKeys.androidExp.tr,
          Icons.android_rounded,
          Colors.green,
        ),
        SizedBox(height: 12.f),
        Row(
          children: [
            _buildStatCard(
              context,
              '2${I18nKeys.yearsShort.tr}+',
              I18nKeys.flutterExp.tr,
              Icons.flutter_dash_rounded,
              Colors.blue,
              flex: 1,
            ),
            SizedBox(width: 12.f),
            _buildStatCard(
              context,
              '1${I18nKeys.yearsShort.tr}+',
              I18nKeys.javaWeb.tr,
              Icons.code_rounded,
              Colors.orange,
              flex: 1,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAndroidStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.f),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20.f),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.f, offset: Offset(0, 5.f)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 32.f),
          SizedBox(width: 16.f),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  value,
                  style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.f),
                CommonText(label, style: context.textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          ),
          SizedBox(width: 10.f),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTag(I18nKeys.archDesign.tr, iconColor),
                SizedBox(height: 4.f),
                _buildTag(I18nKeys.perfOptimization.tr, iconColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 2.f),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.f),
      ),
      child: CommonText(
        label,
        style: TextStyle(color: color, fontSize: 10.f, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color iconColor, {
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.f, vertical: 10.f),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(20.f),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.f, offset: Offset(0, 5.f)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24.f),
            SizedBox(width: 10.f),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonText(
                    value,
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  CommonText(
                    label,
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11.f),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    bool showSeeAll = false,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CommonText(
            title,
            style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (showSeeAll)
          TextButton(
            onPressed: onPressed,
            child: CommonText(I18nKeys.viewAll.tr, style: context.textTheme.bodySmall),
          ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final accentColor = context.accentColor;
    return Column(
      children: [
        Row(
          children: [
            _buildActionCard(
              context,
              I18nKeys.aboutMe.tr,
              Icons.person_outline_rounded,
              accentColor,
              onResumeRequested,
              subtitle: 'Detailed CV',
              blurLevel: AuthBlurLevel.low,
            ),
            SizedBox(width: 12.f),
            _buildActionCard(
              context,
              I18nKeys.architecture.tr,
              Icons.account_tree_outlined,
              Colors.orange,
              onArchitectureRequested,
              subtitle: 'App Design',
            ),
          ],
        ),
        SizedBox(height: 12.f),
        Row(
          children: [
            _buildActionButton(
              context,
              I18nKeys.github.tr,
              Icons.code_rounded,
              Colors.grey,
              () => _launchURL(AppConstants.fullMail),
            ),
            SizedBox(width: 12.f),
            _buildActionButton(
              context,
              I18nKeys.contactMe.tr,
              Icons.alternate_email_rounded,
              Colors.grey,
              () => _launchURL('mailto:${AppConstants.mail}?subject=Portfolio%20Feedback'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    String? subtitle,
    AuthBlurLevel blurLevel = AuthBlurLevel.none,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.f),
        child: Container(
          padding: EdgeInsets.all(16.f),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(20.f),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10.f,
                offset: Offset(0, 5.f),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28.f),
              SizedBox(height: 8.f),
              CommonAuthText(
                title,
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                blurLevel: blurLevel,
                onTap: onTap,
              ),
              if (subtitle != null)
                CommonAuthText(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  blurLevel: blurLevel,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.f),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.f, vertical: 10.f),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(16.f),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10.f,
                offset: Offset(0, 5.f),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18.f),
                SizedBox(width: 8.f),
                CommonText(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedProjects(BuildContext context) {
    final projects = [
      {
        'title': 'lPortfolio',
        'tag': 'MVI Architecture',
        'image': 'assets/images/project_portfolio.png',
        'color': context.accentColor,
      },
      {
        'title': 'AI Chatbot',
        'tag': 'OpenAI SDK',
        'image': 'assets/images/project_chatbot.png',
        'color': Colors.purple,
      },
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return _buildProjectCard(
            context,
            title: project['title'] as String,
            tag: project['tag'] as String,
            image: project['image'] as String,
            color: project['color'] as Color,
          );
        },
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context, {
    required String title,
    required String tag,
    required String image,
    required Color color,
  }) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 16.f),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.f),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12.f, offset: Offset(0, 6.f))],
      ),
      child: Container(
        padding: EdgeInsets.all(20.f),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.f),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 4.f),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8.f)),
              child: CommonText(
                tag,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.f),
            CommonText(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    if (!await launchUrl(Uri.parse(urlString))) {
      CommonToast.show('${I18nKeys.couldNotLaunchGithub.tr}: $urlString');
    }
  }
}
