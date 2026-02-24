import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

class ProjectsWidget extends StatelessWidget {
  const ProjectsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        final accentColor = context.accentColor;
        final projects = [
          {
            'title': 'lPortfolio',
            'subtitle': 'Current App',
            'desc':
                'This portfolio app! Built with Clean Architecture, MVI pattern, and Riverpod to demonstrate modern Flutter development practices.',
            'color': accentColor,
          },
          {
            'title': 'AI Chatbot',
            'subtitle': 'Dart & OpenAI',
            'desc':
                'An intelligent conversational agent powered by GPT-4, supporting voice input and multi-language support.',
            'color': Colors.purple,
          },
          {
            'title': 'Portfolio Web',
            'subtitle': 'Flutter Web',
            'desc':
                'A responsive personal website built with Flutter Web, showcasing projects and experience with smooth animations.',
            'color': Colors.teal,
          },
          {
            'title': 'Android Perf Toolkit',
            'subtitle': 'Optimization',
            'desc':
                'An Android project focused on advanced profiling, memory leak detection, and rendering optimization tools for complex Android apps.',
            'color': Colors.redAccent,
          },
          {
            'title': 'Flutter Gallery Pro',
            'subtitle': 'UI/UX Showcases',
            'desc':
                'A dedicated showcase app demonstrating complex animations, custom painters, and modern UI components for rapid prototyping.',
            'color': Colors.indigo,
          },
          {
            'title': 'Listen Core Plugin',
            'subtitle': 'Architecture',
            'desc':
                'Foundation plugin providing base classes, network wrappers, and utilities. Planned for release on pub.dev as an infrastructure base.',
            'color': Colors.orange,
          },
          {
            'title': 'Listen UI Kit',
            'subtitle': 'Common Widgets',
            'desc':
                'A reusable widget library designed to speed up development and ensure design consistency across multiple Flutter projects.',
            'color': Colors.pink,
          },
          {
            'title': 'English Learning App',
            'subtitle': 'TODO',
            'desc':
                'A comprehensive language learning platform featuring spaced repetition, AI speech recognition, and interactive lessons.',
            'color': Colors.amber,
          },
          {
            'title': 'Video Player App',
            'subtitle': 'TODO',
            'desc':
                'A high-performance media player supporting local/network streaming, background playback, and picture-in-picture mode.',
            'color': Colors.cyan,
          },
        ];

        return ListView.builder(
          padding: EdgeInsets.all(20.f),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(
              context,
              project['title'] as String,
              project['subtitle'] as String,
              project['desc'] as String,
              project['color'] as Color,
            );
          },
        );
      },
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    String title,
    String subtitle,
    String desc,
    Color baseColor,
  ) {
    final bool isTodo = subtitle == 'TODO';

    return Container(
      margin: EdgeInsets.only(bottom: 20.f),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24.f),
        border: Border.all(color: baseColor.withValues(alpha: 0.2), width: 1.f),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.f, offset: Offset(0, 5.f)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Gradient with Icon
          Container(
            height: 120.f,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [baseColor, baseColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                isTodo ? Icons.hourglass_empty_rounded : Icons.rocket_launch_rounded,
                size: 48.f,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          // Content Section
          Padding(
            padding: EdgeInsets.all(20.f),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CommonText(
                        title,
                        style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 4.f),
                      decoration: BoxDecoration(
                        color: isTodo ? Colors.grey.withValues(alpha: 0.1) : baseColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.f),
                      ),
                      child: CommonText(
                        subtitle,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: isTodo ? Colors.grey : baseColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.f),
                CommonText(
                  desc,
                  style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
                  useFittedBox: false,
                ),
                SizedBox(height: 20.f),
                if (!isTodo)
                  Row(
                    children: [
                      Expanded(child: _buildActionChip(context, Icons.link, 'Live Demo', baseColor)),
                      SizedBox(width: 12.f),
                      Expanded(child: _buildActionChip(context, Icons.code, 'Source Code', Colors.grey)),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.f, vertical: 8.f),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.f),
        borderRadius: BorderRadius.circular(10.f),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14.f, color: color),
          SizedBox(width: 6.f),
          Flexible(
            child: CommonText(
              label,
              style: context.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
