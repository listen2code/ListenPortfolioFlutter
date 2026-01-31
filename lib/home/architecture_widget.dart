import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArchitectureWidget extends StatelessWidget {
  const ArchitectureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildCleanMVISection(),
            const SizedBox(height: 25),
            _buildLibSection(),
            const SizedBox(height: 25),
            _buildSourceCodeSection(context),
            const SizedBox(height: 25),
            _buildBackendSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'A robust and scalable foundation for modern mobile apps.',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    );
  }

  Widget _buildCleanMVISection() {
    return _buildCard(
      title: 'Clean Architecture + MVI',
      icon: Icons.layers_outlined,
      child: const Text(
        'The app follows Clean Architecture principles to separate concerns into Data, Domain, and Presentation layers. '
        'On the Presentation layer, the MVI (Model-View-Intent) pattern ensures unidirectional data flow, '
        'making the state predictable and easy to debug.',
        style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
      ),
    );
  }

  Widget _buildLibSection() {
    final libs = [
      {'name': 'Riverpod', 'desc': 'State management & DI'},
      {'name': 'Freezed', 'desc': 'Code generation for immutable states'},
      {'name': 'Dio & Retrofit', 'desc': 'Type-safe networking'},
      {'name': 'Dartz', 'desc': 'Functional programming (Either/Option)'},
    ];

    return _buildCard(
      title: 'Core Libraries',
      icon: Icons.library_books_outlined,
      child: Column(children: libs.map((lib) => _buildLibItem(lib['name']!, lib['desc']!)).toList()),
    );
  }

  Widget _buildSourceCodeSection(BuildContext context) {
    return _buildCard(
      title: 'Open Source',
      icon: Icons.code_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The entire source code of this portfolio app is available on GitHub. Feel free to explore the repository.',
            style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => _launchURL(context, 'https://github.com/listen2code'),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.link, size: 18, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  'github.com/listen2code',
                  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackendSection() {
    return _buildCard(
      title: 'Backend & DevOps',
      icon: Icons.cloud_done_outlined,
      child: const Text(
        'The backend services are deployed on AWS using a serverless approach. '
        'Key services include AWS Lambda for logic, API Gateway for REST endpoints, '
        'and DynamoDB for scalable storage. CI/CD pipelines ensure rapid delivery.',
        style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildLibItem(String name, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black87),
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

  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }
}
