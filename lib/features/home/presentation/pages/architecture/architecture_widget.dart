import 'package:flutter/material.dart';
import 'architecture_intent.dart';
import 'architecture_state.dart';
import 'architecture_view_model.dart';
import '../../../../../shared/shared.dart';
import 'package:listen_uikit/uikit.dart';

class ArchitectureWidget extends StatelessWidget {
  final bool active;

  const ArchitectureWidget({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return BaseRefreshPage<ArchitectureViewModel, ArchitectureState>(
      provider: architectureViewModelProvider,
      useScaffold: false,
      active: active,
      onLoading: _buildSkeleton(context),
      onRefresh: (viewModel, state) async {
        viewModel.handleIntent(const ArchitectureIntent.refresh());
      },
      body: (context, child, viewModel, state) {
        if (state.sections.isEmpty) return null;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.f),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.header != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 30.f),
                  child: CommonText(
                    state.header!,
                    style: context.textTheme.bodyLarge?.copyWith(color: Colors.grey, height: 1.5),
                    useFittedBox: false,
                  ),
                ),
              ...state.sections.map((section) => _buildSection(context, viewModel, section)),
              SizedBox(height: 30.f),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, ArchitectureViewModel viewModel, ArchitectureSection section) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.f),
      child: _buildCard(
        context,
        title: section.title,
        icon: section.icon is IconData ? section.icon as IconData : Icons.help_outline,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.content.isNotEmpty)
              CommonText(
                section.content,
                style: context.textTheme.bodyMedium?.copyWith(height: 1.6),
                useFittedBox: false,
              ),
            if (section.libs != null)
              Padding(
                padding: EdgeInsets.only(top: section.content.isNotEmpty ? 15.f : 0),
                child: Column(
                  children: section.libs!.map((lib) => _buildLibItem(context, lib.name, lib.desc)).toList(),
                ),
              ),
            if (section.linkLabel != null && section.linkUrl != null)
              Padding(
                padding: EdgeInsets.only(top: 15.f),
                child: CommonButton(
                  text: section.linkLabel!,
                  type: ButtonType.text,
                  isFullWidth: false,
                  padding: EdgeInsets.zero,
                  icon: Icons.link,
                  onPressed: () => viewModel.handleIntent(ArchitectureIntent.launchURL(section.linkUrl!)),
                ),
              ),
          ],
        ),
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

  Widget _buildSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.f),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonSkeleton.line(width: double.infinity, height: 16.f),
          SizedBox(height: 8.f),
          CommonSkeleton.line(width: 200.f, height: 16.f),
          SizedBox(height: 30.f),
          ...List.generate(
            4,
            (index) => Container(
              margin: EdgeInsets.only(bottom: 25.f),
              padding: EdgeInsets.all(20.f),
              decoration: BoxDecoration(
                color: context.theme.cardColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20.f),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonSkeleton.circle(size: 24.f),
                      SizedBox(width: 12.f),
                      CommonSkeleton.line(width: 150.f, height: 18.f),
                    ],
                  ),
                  SizedBox(height: 20.f),
                  CommonSkeleton.line(width: double.infinity, height: 14.f),
                  SizedBox(height: 10.f),
                  CommonSkeleton.line(width: double.infinity, height: 14.f),
                  SizedBox(height: 10.f),
                  CommonSkeleton.line(width: 180.f, height: 14.f),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
