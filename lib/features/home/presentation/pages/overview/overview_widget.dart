import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/overview/overview_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewWidget extends StatelessWidget {
  final bool active;
  final HomeViewModel homeViewModel;

  const OverviewWidget({super.key, required this.active, required this.homeViewModel});

  @override
  Widget build(BuildContext context) {
    // Get user data from AuthManager
    UserModel? userModel = authManager.state.user;

    return BaseRefreshPage<OverviewViewModel, OverviewState>(
      provider: overviewViewModelProvider,
      onRefresh: (viewModel, state) async {
        viewModel?.handleIntent(const OverviewIntent.refresh());
      },
      onLoading: _buildSkeleton(context),
      useScaffold: false,
      active: active,
      body: (context, child, viewModel, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.f),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeHeader(context, userModel),
                  SizedBox(height: 16.f),
                  _buildStatusTag(context, userModel),
                  SizedBox(height: 24.f),
                  _buildExperienceGrid(context, userModel),
                  SizedBox(height: 28.f),
                  _buildSectionHeader(context, I18nKeys.quickActions.tr, showSeeAll: false, onPressed: () {}),
                  SizedBox(height: 12.f),
                  _buildQuickActions(context, userModel),
                  SizedBox(height: 28.f),
                  _buildSectionHeader(
                    context,
                    I18nKeys.featuredProjects.tr,
                    showSeeAll: true,
                    onPressed: () =>
                        homeViewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.projects)),
                  ),
                  SizedBox(height: 12.f),
                ],
              ),
            ),
            _buildFeaturedProjects(context),
            SizedBox(height: 30.f),
          ],
        );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.f, vertical: 20.f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonSkeleton.line(width: 180.f, height: 28.f),
          SizedBox(height: 12.f),
          CommonSkeleton.line(width: 260.f, height: 16.f),
          SizedBox(height: 24.f),
          CommonSkeleton(width: 120.f, height: 24.f, borderRadius: 20.f),
          SizedBox(height: 32.f),
          CommonSkeleton(width: double.infinity, height: 100.f, borderRadius: 20.f),
          SizedBox(height: 12.f),
          Row(
            children: [
              Expanded(
                child: CommonSkeleton(height: 80.f, borderRadius: 20.f),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonSkeleton(height: 80.f, borderRadius: 20.f),
              ),
            ],
          ),
          SizedBox(height: 40.f),
          CommonSkeleton.line(width: 120.f, height: 20.f),
          SizedBox(height: 16.f),
          Row(
            children: [
              Expanded(
                child: CommonSkeleton(height: 90.f, borderRadius: 16.f),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonSkeleton(height: 90.f, borderRadius: 16.f),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonSkeleton(height: 90.f, borderRadius: 16.f),
              ),
            ],
          ),
          SizedBox(height: 40.f),
          CommonSkeleton.line(width: 150.f, height: 20.f),
          SizedBox(height: 16.f),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(
                2,
                (index) => Padding(
                  padding: EdgeInsets.only(right: 16.f),
                  child: CommonSkeleton(width: 260.f, height: 160.f, borderRadius: 24.f),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, UserModel? userModel) {
    final accentColor = context.accentColor;
    final String name = userModel?.name ?? AppConstants.author;
    final String jobTitle = userModel?.jobTitle ?? "Full Stack Mobile Architect";
    final String graduationYear = userModel?.graduationYear ?? "2013";
    final String major = userModel?.major?.tr ?? I18nKeys.softwareEngineering.tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          I18nKeys.hello.trArgs([name]),
          style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
        ),
        SizedBox(height: 4.f),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CommonText(
              '$jobTitle (${I18nKeys.graduated.tr}',
              style: context.textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
            CommonAuthText(
              ' $graduationYear ',
              style: context.textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w600),
              maxLines: 1,
              blurLevel: AuthBlurLevel.low,
            ),
            CommonAuthText(
              '| $major)',
              style: context.textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w600),
              maxLines: 1,
              blurLevel: AuthBlurLevel.low,
            ),
          ],
        ),
        SizedBox(height: 8.f),
        // Certifications section
        if (userModel?.certifications != null || userModel == null)
          Row(
            children: (userModel?.certifications ?? [I18nKeys.jlptN1, I18nKeys.bjtJ2])
                .map(
                  (certKey) => Padding(
                    padding: EdgeInsets.only(right: 8.f),
                    child: _buildCertBadge(accentColor, certKey.tr),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildCertBadge(Color color, String label) {
    return CommonBadge(
      icon: Icons.workspace_premium_outlined,
      iconSize: 12.f,
      color: color.withValues(alpha: 0.1),
      borderColor: color.withValues(alpha: 0.3),
      borderWidth: 0.5.f,
      borderRadius: 6.f,
      padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 3.f),
      spacing: 4.f,
      child: CommonAuthText(
        label,
        style: TextStyle(color: color, fontSize: 10.f, fontWeight: FontWeight.w600),
        blurLevel: AuthBlurLevel.low,
      ),
    );
  }

  Widget _buildStatusTag(BuildContext context, UserModel? userModel) {
    return CommonBadge(
      text: userModel?.status?.tr ?? I18nKeys.availableStatus.tr,
      icon: Icons.circle,
      iconSize: 6.f,
      color: Colors.green.withValues(alpha: 0.1),
      textColor: Colors.green,
      borderColor: Colors.green.withValues(alpha: 0.2),
      borderRadius: 20.f,
      padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 4.f),
      spacing: 6.f,
    );
  }

  Widget _buildExperienceGrid(BuildContext context, UserModel? userModel) {
    // If not logged in, we provide default experience data based on users.json logic
    final List<ExperienceModel> experiences =
        userModel?.experiences ??
        const [
          ExperienceModel(
            id: 'android',
            year: '10',
            label: I18nKeys.androidExp,
            tags: [I18nKeys.archDesign, I18nKeys.perfOptimization],
          ),
          ExperienceModel(id: 'flutter', year: '2', label: I18nKeys.flutterExp),
          ExperienceModel(id: 'java_web', year: '1', label: I18nKeys.javaWeb),
        ];

    if (experiences.isEmpty) return const SizedBox.shrink();

    final mainExp = experiences.first;
    final otherExps = experiences.skip(1).toList();

    return Column(
      children: [
        _buildHighlightStatCard(
          context,
          '${mainExp.year}${I18nKeys.yearsShort.tr}+',
          mainExp.label?.tr ?? "",
          _getExperienceIcon(mainExp.id),
          _getExperienceColor(mainExp.id),
          tags: mainExp.tags,
        ),
        if (otherExps.isNotEmpty) ...[
          SizedBox(height: 12.f),
          Row(
            children: [
              for (int i = 0; i < otherExps.length; i++) ...[
                if (i > 0) SizedBox(width: 12.f),
                _buildStatCard(
                  context,
                  '${otherExps[i].year}${I18nKeys.yearsShort.tr}+',
                  otherExps[i].label?.tr ?? "",
                  _getExperienceIcon(otherExps[i].id),
                  _getExperienceColor(otherExps[i].id),
                  flex: 1,
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  IconData _getExperienceIcon(String? id) {
    switch (id) {
      case 'android':
        return Icons.android_rounded;
      case 'flutter':
        return Icons.flutter_dash_rounded;
      case 'java_web':
        return Icons.code_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getExperienceColor(String? id) {
    switch (id) {
      case 'android':
        return Colors.green;
      case 'flutter':
        return Colors.blue;
      case 'java_web':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildHighlightStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color iconColor, {
    List<String>? tags,
  }) {
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
                CommonAuthText(
                  value,
                  style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  blurLevel: AuthBlurLevel.medium,
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
          if (tags != null && tags.isNotEmpty) ...[
            SizedBox(width: 10.f),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: tags
                  .take(2)
                  .map(
                    (tag) => Padding(
                      padding: EdgeInsets.only(bottom: 4.f),
                      child: _buildTag(tag.tr, iconColor),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return CommonBadge(
      text: label,
      color: color.withValues(alpha: 0.1),
      textColor: color,
      borderRadius: 6.f,
      padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 2.f),
      fontSize: 10.f,
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
                  CommonAuthText(
                    value,
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    blurLevel: AuthBlurLevel.medium,
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

  Widget _buildQuickActions(BuildContext context, UserModel? userModel) {
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
              () {
                AppNav.tryLogin(
                  onSuccess: () => homeViewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.aboutMe)),
                );
              },
              subtitle: 'Detailed CV',
              blurLevel: AuthBlurLevel.low,
            ),
            SizedBox(width: 12.f),
            _buildActionCard(
              context,
              I18nKeys.architecture.tr,
              Icons.account_tree_outlined,
              Colors.orange,
              () => homeViewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.architecture)),
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
              () => _launchURL(userModel?.github ?? AppConstants.github),
            ),
            SizedBox(width: 12.f),
            _buildActionButton(
              context,
              I18nKeys.contactMe.tr,
              Icons.alternate_email_rounded,
              Colors.grey,
              () =>
                  _launchURL('mailto:${userModel?.email ?? AppConstants.mail}?subject=Portfolio%20Feedback'),
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
                    onTap: onTap,
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
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: CommonButton(
        text: title,
        icon: icon,
        backgroundColor: context.theme.cardColor,
        foregroundColor: context.textTheme.bodyLarge?.color,
        isFullWidth: true,
        height: 48.f,
        borderRadius: 16.f,
        onPressed: onTap,
      ),
    );
  }

  Widget _buildFeaturedProjects(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.f),
      child: Row(
        children: [
          _buildProjectCard(
            context,
            'lPortfolio',
            'MVI Architecture',
            Icons.auto_awesome_mosaic_rounded,
            context.accentColor,
          ),
          SizedBox(width: 16.f),
          _buildProjectCard(context, 'AI Chatbot', 'OpenAI SDK', Icons.smart_toy_rounded, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, String title, String tag, IconData icon, Color color) {
    return Container(
      width: 260.f,
      padding: EdgeInsets.all(20.f),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(24.f),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15.f, offset: Offset(0, 8.f)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10.f),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 24.f),
              ),
              CommonBadge(
                text: tag,
                color: Colors.blue.withValues(alpha: 0.05),
                textColor: Colors.blue,
                fontSize: 10.f,
                borderRadius: 8.f,
              ),
            ],
          ),
          SizedBox(height: 20.f),
          CommonText(
            title,
            style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
