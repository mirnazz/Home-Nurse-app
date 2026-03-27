import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_appointments_screen.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_requests_screen.dart';
import 'package:nurse_app/Features/Shared/Presentation/notifications_screen.dart';
import 'nurse_availability_screen.dart';
import 'nurse_profile_screen.dart';

/// Bottom tabs: 0 Home, 1 Availability, 2 Appointments, 3 Requests, 4 Profile.
typedef NurseDashboardNavigate = void Function(int tabIndex);

class NurseDashboardScreen extends StatefulWidget {
  const NurseDashboardScreen({super.key});

  @override
  State<NurseDashboardScreen> createState() => _NurseDashboardScreenState();
}

class _NurseDashboardScreenState extends State<NurseDashboardScreen> {
  int currentTab = 0;
  String nurseName = "";
  bool isLoading = true;

  void _navigate(int tabIndex) => setState(() => currentTab = tabIndex);
  void _openNotifications() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const NotificationsScreen(
          audience: NotificationAudience.nurse,
          notifications: [],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadNurse();
  }

  Future<void> loadNurse() async {
    try {
      final data = await ApiService.getAccount();

      if (!mounted) return;

      setState(() {
        nurseName = data["fullName"] ?? "Nurse";
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        nurseName = "Nurse";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : IndexedStack(
                index: currentTab,
                children: [
                  NurseHomeScreen(
                    nurseName: nurseName,
                    onNavigate: _navigate,
                    onOpenNotifications: _openNotifications,
                  ),
                  const NurseAvailabilityScreen(),
                  const NurseAppointmentsScreen(),
                  const NurseRequestsScreen(),
                  const NurseProfileScreen(),
                ],
              ),
      ),
      bottomNavigationBar: _NurseBottomNav(
        currentIndex: currentTab,
        onChanged: (i) => setState(() => currentTab = i),
      ),
    );
  }
}

class NurseHomeScreen extends StatelessWidget {
  final String nurseName;
  final NurseDashboardNavigate onNavigate;
  final VoidCallback onOpenNotifications;

  const NurseHomeScreen({
    super.key,
    required this.nurseName,
    required this.onNavigate,
    required this.onOpenNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NurseHeader(
            name: nurseName,
            onNotificationsTap: onOpenNotifications,
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SummaryCardsRow(),
                const SizedBox(height: 18),
                const _ThisWeekSummaryCard(),
                const SizedBox(height: 24),
                const _QuickActionsTitle(),
                const SizedBox(height: 12),
                _QuickActionsList(onNavigate: onNavigate),
                const SizedBox(height: 24),
                _TodayScheduleSection(
                  onViewAll: () => onNavigate(2),
                ),
                const SizedBox(height: 24),
                _AvailabilityCard(
                  onOpenAvailability: () => onNavigate(1),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NurseHeader extends StatelessWidget {
  final String name;
  final VoidCallback onNotificationsTap;

  const _NurseHeader({required this.name, required this.onNotificationsTap});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr =
        '${_weekday(now.weekday)}, ${_month(now.month)} ${now.day}, ${now.year}';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back,",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onNotificationsTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Center(
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF4D4D),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _weekday(int w) {
    const days = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[w];
  }

  String _month(int m) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[m];
  }
}

class _SummaryCardsRow extends StatelessWidget {
  const _SummaryCardsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.calendar_today_outlined,
            value: "4",
            label: "Today's Appointments",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.access_time_outlined,
            value: "7",
            label: "Pending Requests",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.attach_money,
            value: "125",
            label: "JOD Today",
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D2433),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThisWeekSummaryCard extends StatelessWidget {
  const _ThisWeekSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "This Week Summary",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _WeekStat(value: "18", label: "Completed"),
              _WeekStat(value: "2", label: "Cancelled"),
              _WeekStat(value: "580", label: "JOD Earned"),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekStat extends StatelessWidget {
  final String value;
  final String label;

  const _WeekStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _QuickActionsTitle extends StatelessWidget {
  const _QuickActionsTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Quick Actions",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1D2433),
      ),
    );
  }
}

class _QuickActionsList extends StatelessWidget {
  final NurseDashboardNavigate onNavigate;

  const _QuickActionsList({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuickActionTile(
          onTap: () => onNavigate(1),
          icon: Icons.calendar_month_outlined,
          title: "Manage Availability",
          subtitle: "Set your working hours",
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        _QuickActionTile(
          onTap: () => onNavigate(3),
          icon: Icons.description_outlined,
          title: "View Requests",
          subtitle: "Pending and rejected requests",
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A00),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              "7",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _QuickActionTile(
          onTap: () => onNavigate(2),
          icon: Icons.calendar_today_outlined,
          title: "My Schedule",
          subtitle: "View your appointments",
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _QuickActionTile({
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
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
          child: Row(
            children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Color(0xFF1D2433),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayScheduleSection extends StatelessWidget {
  final VoidCallback onViewAll;

  const _TodayScheduleSection({required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Schedule",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1D2433),
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text(
                "View All",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _ScheduleAppointmentCard(
          patientName: "Ahmad M.",
          service: "IV Therapy",
          status: "Confirmed",
          statusColor: Color(0xFF22C55E),
          statusBg: Color(0xFFEAFBF0),
          time: "10:00 AM",
          earnings: "50",
        ),
        const SizedBox(height: 12),
        const _ScheduleAppointmentCard(
          patientName: "Rania K.",
          service: "Wound Care",
          status: "Upcoming",
          statusColor: Color(0xFF0EA5E9),
          statusBg: Color(0xFFE0F2FE),
          time: "2:00 PM",
          earnings: "30",
        ),
      ],
    );
  }
}

class _ScheduleAppointmentCard extends StatelessWidget {
  final String patientName;
  final String service;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String time;
  final String earnings;

  const _ScheduleAppointmentCard({
    required this.patientName,
    required this.service,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.time,
    required this.earnings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  patientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Color(0xFF1D2433),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            service,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                "$earnings JOD",
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  final VoidCallback onOpenAvailability;

  const _AvailabilityCard({required this.onOpenAvailability});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onOpenAvailability,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFA5D6A7)),
          ),
          child: Row(
            children: [
          Container(
            height: 12,
            width: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You're Available",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You can receive new service requests",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NurseBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _NurseBottomNav({
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onChanged,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: const Color(0xFF9CA3AF),
          selectedFontSize: 11,
          unselectedFontSize: 10,
          iconSize: 24,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Availability',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.event_available_outlined),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications),
                  Positioned(
                    right: -4,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4D4D),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '7',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Requests',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
      ),
    );
  }
}