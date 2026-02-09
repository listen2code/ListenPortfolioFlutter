import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

class ProjectsWidget extends StatelessWidget {
  const ProjectsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        final accentColor = settingManager.accentColor;
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
            'desc': 'An intelligent conversational agent powered by GPT-4, supporting voice input and multi-language support.',
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
          padding: const EdgeInsets.all(20),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(
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

  Widget _buildProjectCard(String title, String subtitle, String desc, Color baseColor) {
    final bool isTodo = subtitle == 'TODO';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: baseColor.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
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
                size: 48,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isTodo ? Colors.grey.withValues(alpha: 0.1) : baseColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: isTodo ? Colors.grey : baseColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
                ),
                const SizedBox(height: 20),
                if (!isTodo)
                  Row(
                    children: [
                      _buildActionChip(Icons.link, 'Live Demo', baseColor),
                      const SizedBox(width: 12),
                      _buildActionChip(Icons.code, 'Source Code', Colors.grey),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
