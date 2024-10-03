import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF6A00D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to the Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Dashboard Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    context,
                    title: 'Profile',
                    icon: Icons.person,
                    onTap: () {
                      // Navigate to Profile
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () {
                      // Navigate to Settings
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Notifications',
                    icon: Icons.notifications,
                    onTap: () {
                      // Navigate to Notifications
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Messages',
                    icon: Icons.message,
                    onTap: () {
                      // Navigate to Messages
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Analytics',
                    icon: Icons.bar_chart,
                    onTap: () {
                      // Navigate to Analytics
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Log out',
                    icon: Icons.logout,
                    onTap: () {
                      // Log out functionality
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF6A00D7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
