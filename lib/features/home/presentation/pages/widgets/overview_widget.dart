import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 20.f),
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
              SizedBox(height: 30.f),
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
          crossAxisAlignment: WrapCrossAlignment.center,
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
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5.f),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_outlined, size: 12.f, color: color),
          SizedBox(width: 4.f),
          CommonText(
            label,
            style: TextStyle(color: color, fontSize: 10.f, fontWeight: FontWeight.bold, letterSpacing: 0.5.f),
            maxLines: 1,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: Colors.green, size: 6.f),
          SizedBox(width: 6.f),
          CommonText(
            I18nKeys.availableStatus.tr,
            style: context.textTheme.labelSmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
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
                  maxLines: 1,
                ),
                SizedBox(height: 4.f),
                CommonText(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.f),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTag(I18nKeys.archDesign.tr, iconColor),
              SizedBox(height: 4.f),
              _buildTag(I18nKeys.perfOptimization.tr, iconColor),
            ],
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
        maxLines: 1,
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
                    maxLines: 1,
                  ),
                  CommonText(
                    label,
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11.f),
                    maxLines: 1,
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
            maxLines: 1,
          ),
        ),
        if (showSeeAll)
          CommonButton(
            text: I18nKeys.viewAll.tr,
            type: ButtonType.text,
            isFullWidth: false,
            height: 32.f,
            fontSize: 12.f,
            padding: EdgeInsets.symmetric(horizontal: 8.f),
            onPressed: onPressed,
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
              () => _launchURL(AppConstants.github),
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
      child: Material(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20.f),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.f),
          child: Container(
            padding: EdgeInsets.all(16.f),
            decoration: BoxDecoration(
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
                  maxLines: 1,
                ),
                if (subtitle != null)
                  CommonAuthText(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    blurLevel: blurLevel,
                    maxLines: 1,
                  ),
              ],
            ),
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
      child: Material(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16.f),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.f),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.f, vertical: 10.f),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.f),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10.f,
                  offset: Offset(0, 5.f),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18.f),
                SizedBox(width: 8.f),
                // Wrap text in Flexible to prevent Row overflow
                Flexible(
                  child: CommonText(
                    label,
                    style: context.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
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
        'icon': Icons.auto_awesome_mosaic_rounded,
        'color': context.accentColor,
      },
      {'title': 'AI Chatbot', 'tag': 'OpenAI SDK', 'icon': Icons.smart_toy_rounded, 'color': Colors.purple},
    ];

    return SizedBox(
      height: 160.f,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.f),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return _buildProjectCard(
            context,
            title: project['title'] as String,
            tag: project['tag'] as String,
            icon: project['icon'] as IconData,
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
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 260.f,
      margin: EdgeInsets.only(right: 16.f),
      padding: EdgeInsets.all(24.f),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.f),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.f),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.f),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16.f)),
            child: Icon(icon, color: Colors.white, size: 28.f),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 4.f),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.f),
            ),
            child: CommonText(
              tag,
              style: TextStyle(color: color, fontSize: 10.f, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          ),
          SizedBox(height: 8.f),
          Expanded(
            child: CommonText(
              title,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    if (!await launchUrl(Uri.parse(urlString))) {
      CommonToast.show('${I18nKeys.couldNotLaunchGithub.tr}: $urlString');
    }
  }
}
