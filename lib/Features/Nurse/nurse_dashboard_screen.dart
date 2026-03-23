import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/api/token_storage.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/auth/Presentation/login_screen.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_requests_screen.dart';

import 'nurse_availability_screen.dart';
import 'nurse_profile_screen.dart';

class NurseDashboardScreen extends StatefulWidget {
  const NurseDashboardScreen({super.key});

  @override
  State<NurseDashboardScreen> createState() => _NurseDashboardScreenState();
}

class _NurseDashboardScreenState extends State<NurseDashboardScreen> {
  int currentTab = 0;
  String nurseName = 'Nurse';

  @override
  void initState() {
    super.initState();
    _loadNurseProfile();
  }

  Future<void> _loadNurseProfile() async {
    try {
      final token = await TokenStorage.getToken();

      if (token == null || token.isEmpty) return;

      final response = await ApiService.getNurseProfile();

      if (!mounted) return;

      setState(() {
        nurseName =
            response['fullName'] ??
            response['name'] ??
            response['nurseName'] ??
            'Nurse';
      });
    } catch (e) {
      debugPrint('Error loading nurse profile: $e');
    }
  }

  Future<void> _logout() async {
    await TokenStorage.clearToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onTabChanged(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: currentTab,
        children: [
          _HomeContent(
            nurseName: nurseName,
            onLogout: _logout,
          ),
          NurseProfileScreen(
            currentTabIndex: 1,
            onTabChanged: (i) => setState(() => currentTab = i),
          ),
          const NurseAvailabilityScreen(),
          const NurseRequestsScreen(),
          const _PlaceholderTab(title: "Transactions"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: _onTabChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Availability',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Transactions',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final String nurseName;
  final VoidCallback onLogout;

  const _HomeContent({
    required this.nurseName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Welcome, $nurseName',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nurse Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage your profile, availability, and incoming requests.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  _DashboardCard(
                    icon: Icons.person,
                    title: 'Profile',
                    subtitle: 'View and edit your information',
                  ),
                  _DashboardCard(
                    icon: Icons.calendar_today,
                    title: 'Availability',
                    subtitle: 'Manage your available schedule',
                  ),
                  _DashboardCard(
                    icon: Icons.assignment,
                    title: 'Requests',
                    subtitle: 'Check new service requests',
                  ),
                  _DashboardCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Transactions',
                    subtitle: 'Track your earnings and records',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;

  const _PlaceholderTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Screen',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
