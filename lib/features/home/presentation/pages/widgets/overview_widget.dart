import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeHeader(context),
                    const SizedBox(height: 16),
                    _buildStatusTag(context),
                    const SizedBox(height: 24),
                    _buildExperienceGrid(context),
                    const SizedBox(height: 28),
                    _buildSectionHeader(
                      context,
                      I18nKeys.quickActions.tr,
                      showSeeAll: false,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActions(context),
                    const SizedBox(height: 28),
                    _buildSectionHeader(
                      context,
                      I18nKeys.featuredProjects.tr,
                      showSeeAll: true,
                      onPressed: onProjectsRequested,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              _buildFeaturedProjects(context),
              const SizedBox(height: 30),
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
        const SizedBox(height: 4),
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
        const SizedBox(height: 8),
        Row(
          children: [
            _buildCertBadge(accentColor, I18nKeys.jlptN1.tr),
            const SizedBox(width: 8),
            _buildCertBadge(accentColor, I18nKeys.bjtJ2.tr),
          ],
        ),
      ],
    );
  }

  Widget _buildCertBadge(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_outlined, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 6),
            const SizedBox(width: 6),
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
        const SizedBox(height: 12),
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
            const SizedBox(width: 12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  value,
                  style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                CommonText(label, style: context.textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTag(I18nKeys.archDesign.tr, iconColor),
                const SizedBox(height: 4),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: CommonText(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 10),
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
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
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
            const SizedBox(width: 12),
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
        const SizedBox(height: 12),
        Row(
          children: [
            _buildActionButton(
              context,
              I18nKeys.github.tr,
              Icons.code_rounded,
              Colors.grey,
              () => _launchURL(AppConstants.fullMail),
            ),
            const SizedBox(width: 12),
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
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
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
        'icon': Icons.auto_awesome_mosaic_rounded,
        'color': context.accentColor,
      },
      {'title': 'AI Chatbot', 'tag': 'OpenAI SDK', 'icon': Icons.smart_toy_rounded, 'color': Colors.purple},
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CommonText(
              tag,
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
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
