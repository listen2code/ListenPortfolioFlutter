import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardWidget extends StatelessWidget {
  final VoidCallback onResumeRequested;

  const DashboardWidget({super.key, required this.onResumeRequested});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingManager,
      builder: (context, child) {
        final theme = Theme.of(context);
        final accentColor = settingManager.accentColor;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(theme, accentColor),
                const SizedBox(height: 20),
                _buildStatusTag(),
                const SizedBox(height: 30),
                _buildExperienceGrid(theme),
                const SizedBox(height: 30),
                _buildSectionHeader(I18nKeys.expertiseAndLanguages.tr, showSeeAll: false),
                const SizedBox(height: 15),
                _buildLanguageChips(theme, accentColor),
                const SizedBox(height: 35),
                _buildSectionHeader(I18nKeys.quickActions.tr, showSeeAll: false),
                const SizedBox(height: 15),
                _buildQuickActions(context, accentColor),
                const SizedBox(height: 35),
                _buildSectionHeader(I18nKeys.featuredProjects.tr),
                const SizedBox(height: 15),
                _buildFeaturedProjects(accentColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader(ThemeData theme, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${I18nKeys.hello.tr} ${AppConstants.author}',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Full Stack Mobile Architect (Graduated 2013)',
                style: TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: accentColor.withValues(alpha: 0.2),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: accentColor,
            backgroundImage: const NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=Listen'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: Colors.green, size: 8),
          const SizedBox(width: 8),
          Text(
            I18nKeys.availableStatus.tr,
            style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceGrid(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard(theme, '10y+', I18nKeys.androidExp.tr, Icons.android_rounded, Colors.green),
            const SizedBox(width: 15),
            _buildStatCard(theme, '2y+', I18nKeys.flutterExp.tr, Icons.flutter_dash_rounded, Colors.blue),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildStatCard(theme, '1y', I18nKeys.javaWeb.tr, Icons.web_rounded, Colors.orange),
            const SizedBox(width: 15),
            _buildStatCard(theme, '13y', I18nKeys.totalJourney.tr, Icons.timeline_rounded, Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageChips(ThemeData theme, Color accentColor) {
    final languages = ['Java', 'Kotlin', 'Dart', 'SQL', 'JavaScript'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: languages
          .map(
            (lang) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.code_rounded, size: 16, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    lang,
                    style: TextStyle(fontWeight: FontWeight.w600, color: theme.textTheme.bodyLarge?.color),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatCard(ThemeData theme, String value, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 15),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Color accentColor) {
    return Row(
      children: [
        _buildActionButton(context, I18nKeys.aboutMe.tr, Icons.description_outlined, accentColor, onResumeRequested),
        const SizedBox(width: 15),
        _buildActionButton(context, I18nKeys.github.tr, Icons.code_rounded, accentColor, () async {
          final Uri url = Uri.parse('https://github.com/listen2code');
          if (!await launchUrl(url)) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch GitHub')));
            }
          }
        }),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color accentColor, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: accentColor, size: 20),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
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
        if (showSeeAll) TextButton(onPressed: () {}, child: Text(I18nKeys.viewAll.tr)),
      ],
    );
  }

  Widget _buildFeaturedProjects(Color accentColor) {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildProjectCard('E-Commerce App', 'Flutter & Firebase', accentColor),
          _buildProjectCard('AI Chatbot', 'Dart & OpenAI', Colors.purple),
          _buildProjectCard('Portfolio Web', 'Flutter Web', Colors.teal),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String subtitle, Color baseColor) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [baseColor, baseColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: baseColor.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))],
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
