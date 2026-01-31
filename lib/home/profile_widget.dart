import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // 头像与基本信息
            _buildHeader(context),
            const SizedBox(height: 30),
            // 个人简介
            _buildAboutSection(),
            const SizedBox(height: 25),
            // 核心技能
            _buildSkillsSection(),
            const SizedBox(height: 25),
            // 教育背景/工作经验 (可选)
            _buildExperienceSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]),
                boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: const CircleAvatar(
                radius: 65,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=Listen'),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ),
            // 修改/上传头像按钮
            Positioned(
              bottom: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  _showImageSourceActionSheet(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Listen', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const Text(
          'Senior Flutter Developer',
          style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        // 修改基本资料按钮
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit_note_rounded, size: 18),
          label: const Text('Edit Information'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blueAccent,
            side: const BorderSide(color: Colors.blueAccent, width: 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            Text('San Francisco, CA', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text('Change Profile Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Colors.blueAccent),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: Colors.blueAccent),
              title: const Text('Take a Photo'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              title: const Text('Remove Current Photo', style: TextStyle(color: Colors.redAccent)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return _buildCard(
      title: 'About Me',
      child: const Text(
        'Passionate Flutter developer with 5+ years of experience in building high-quality, cross-platform mobile applications. I love turning complex problems into simple, beautiful, and intuitive designs.',
        style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
      ),
    );
  }

  Widget _buildSkillsSection() {
    final skills = ['Flutter', 'Dart', 'Clean Architecture', 'Riverpod', 'Firebase', 'REST API', 'Git', 'CI/CD'];
    return _buildCard(
      title: 'Core Skills',
      child: Wrap(spacing: 10, runSpacing: 10, children: skills.map((skill) => _buildSkillChip(skill)).toList()),
    );
  }

  Widget _buildExperienceSection() {
    return _buildCard(
      title: 'Experience',
      child: Column(
        children: [
          _buildExperienceItem('Senior Developer', 'Tech Corp', '2020 - Present'),
          const Divider(height: 30),
          _buildExperienceItem('Mobile Developer', 'App Studio', '2018 - 2020'),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
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
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  Widget _buildExperienceItem(String role, String company, String period) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.work_outline, color: Colors.grey, size: 20),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(company, style: const TextStyle(color: Colors.grey)),
              Text(period, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
