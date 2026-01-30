import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/appearance.dart';
import 'package:listen_portfolio_flutter/settings.dart';
import 'package:listen_portfolio_flutter/profile.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            // 自定义 Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, size: 45, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'johndoe@example.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // 右上角外观快速设置入口
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const AppearancePage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(
                          Icons.wb_sunny_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // 中部菜单项 (精简版)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard_customize_outlined,
                    label: 'Dashboard',
                    isSelected: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_search_outlined,
                    label: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Divider(color: Colors.grey),
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_suggest_outlined,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context); // 关闭侧边栏
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // 底部 Logout
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 80, color: Colors.blueAccent),
              SizedBox(height: 20),
              Text(
                'Welcome to Home Page!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blueAccent : Colors.black54,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onTap: onTap,
      ),
    );
  }
}
