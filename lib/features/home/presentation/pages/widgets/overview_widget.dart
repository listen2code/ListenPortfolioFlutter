import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
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
        final theme = Theme.of(context);
        final accentColor = settingManager.accentColor;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(theme, accentColor),
              const SizedBox(height: 12),
              _buildStatusTag(),
              const SizedBox(height: 20),
              _buildExperienceGrid(theme),
              const SizedBox(height: 28),
              _buildSectionHeader(I18nKeys.quickActions.tr, showSeeAll: false),
              const SizedBox(height: 12),
              _buildQuickActions(context, accentColor),
              const SizedBox(height: 28),
              _buildSectionHeader(I18nKeys.featuredProjects.tr),
              const SizedBox(height: 12),
              _buildFeaturedProjects(accentColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader(ThemeData theme, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${I18nKeys.hello.tr} ${AppConstants.author}',
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Full Stack Mobile Architect (${I18nKeys.graduated.tr} 2013 | ${I18nKeys.softwareEngineering.tr})',
          style: TextStyle(color: accentColor, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
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

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: Colors.green, size: 6),
          const SizedBox(width: 6),
          Text(
            I18nKeys.availableStatus.tr,
            style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceGrid(ThemeData theme) {
    return Column(
      children: [
        _buildAndroidStatCard(theme, '10${I18nKeys.yearsShort.tr}+', I18nKeys.androidExp.tr, Icons.android_rounded, Colors.green),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              theme,
              '2${I18nKeys.yearsShort.tr}+',
              I18nKeys.flutterExp.tr,
              Icons.flutter_dash_rounded,
              Colors.blue,
              flex: 1,
            ),
            const SizedBox(width: 12),
            _buildStatCard(theme, '1${I18nKeys.yearsShort.tr}+', I18nKeys.javaWeb.tr, Icons.code_rounded, Colors.orange, flex: 1),
          ],
        ),
      ],
    );
  }

  Widget _buildAndroidStatCard(ThemeData theme, String value, String label, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTag(I18nKeys.archDesign.tr, iconColor),
              const SizedBox(height: 4),
              _buildTag(I18nKeys.perfOptimization.tr, iconColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String value, String label, IconData icon, Color iconColor, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))],
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
                  Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Color accentColor) {
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
            _buildActionButton(context, I18nKeys.github.tr, Icons.code_rounded, Colors.grey, () async {
              final Uri url = Uri.parse('https://github.com/listen2code');
              if (!await launchUrl(url)) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(I18nKeys.couldNotLaunchGithub.tr)));
                }
              }
            }),
            const SizedBox(width: 12),
            _buildActionButton(context, I18nKeys.contactMe.tr, Icons.alternate_email_rounded, Colors.grey, () async {
              final Uri url = Uri.parse('mailto:${AppConstants.mail}?subject=Portfolio%20Feedback');
              try {
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(I18nKeys.noEmailApp.tr)));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch mail client')));
                }
              }
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: color.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showSeeAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (showSeeAll) TextButton(onPressed: onProjectsRequested, child: Text(I18nKeys.viewAll.tr)),
      ],
    );
  }

  Widget _buildFeaturedProjects(Color accentColor) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildProjectCard('lPortfolio', 'Current App', accentColor),
          _buildProjectCard('AI Chatbot', 'Dart & OpenAI', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String subtitle, Color baseColor) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [baseColor, baseColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
