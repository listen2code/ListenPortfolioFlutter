import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardWidget extends StatelessWidget {
  final VoidCallback onResumeRequested;

  const DashboardWidget({super.key, required this.onResumeRequested});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 20),
            _buildStatusTag(),
            const SizedBox(height: 30),
            _buildExperienceGrid(),
            const SizedBox(height: 30),
            _buildSectionHeader('Expertise & Languages', showSeeAll: false),
            const SizedBox(height: 15),
            _buildLanguageChips(),
            const SizedBox(height: 35),
            _buildSectionHeader('Quick Actions', showSeeAll: false),
            const SizedBox(height: 15),
            _buildQuickActions(context),
            const SizedBox(height: 35),
            _buildSectionHeader('Featured Projects'),
            const SizedBox(height: 15),
            _buildFeaturedProjects(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hello, I\'m Listen', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text(
                'Full Stack Mobile Architect (Graduated 2013)',
                style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blueAccent,
          backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=Listen'),
        ),
      ],
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: Colors.green, size: 8),
          SizedBox(width: 8),
          Text(
            'Available for high-impact roles',
            style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceGrid() {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard('10y+', 'Android Exp', Icons.android_rounded, Colors.green),
            const SizedBox(width: 15),
            _buildStatCard('2y+', 'Flutter Exp', Icons.flutter_dash_rounded, Colors.blue),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildStatCard('1y', 'Java Web', Icons.web_rounded, Colors.orange),
            const SizedBox(width: 15),
            _buildStatCard('13y', 'Total Journey', Icons.timeline_rounded, Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageChips() {
    final languages = ['Java', 'Kotlin', 'Dart', 'SQL', 'JavaScript'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: languages
          .map(
            (lang) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.code_rounded, size: 16, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Text(
                    lang,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 15),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(context, 'About Me', Icons.description_outlined, onResumeRequested),
        const SizedBox(width: 15),
        _buildActionButton(context, 'GitHub', Icons.code_rounded, () async {
          final Uri url = Uri.parse('https://github.com/listen2code');
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        }),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blueAccent, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            ],
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
        if (showSeeAll) TextButton(onPressed: () {}, child: const Text('View All')),
      ],
    );
  }

  Widget _buildFeaturedProjects() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildProjectCard('E-Commerce App', 'Flutter & Firebase', Colors.indigo),
          _buildProjectCard('AI Chatbot', 'Dart & OpenAI', Colors.purple),
          _buildProjectCard('Portfolio Web', 'Flutter Web', Colors.teal),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String subtitle, Color color) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
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
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
