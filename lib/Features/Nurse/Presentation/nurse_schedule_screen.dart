import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/Features/Nurse/nurse_availability_screen.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_appointments_screen.dart';

/// Combines availability (calendar) and appointments in one place.
class NurseScheduleScreen extends StatefulWidget {
  final int scheduleSubTabIndex;

  const NurseScheduleScreen({
    super.key,
    this.scheduleSubTabIndex = 0,
  });

  @override
  State<NurseScheduleScreen> createState() => _NurseScheduleScreenState();
}

class _NurseScheduleScreenState extends State<NurseScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.scheduleSubTabIndex.clamp(0, 1),
    );
  }

  @override
  void didUpdateWidget(NurseScheduleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scheduleSubTabIndex != oldWidget.scheduleSubTabIndex) {
      final next = widget.scheduleSubTabIndex.clamp(0, 1);
      if (_tabController.index != next) {
        _tabController.animateTo(next);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return Scaffold(
      backgroundColor: AppointmentUiColors.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
                    child: Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: primary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: primary,
                    unselectedLabelColor: const Color(0xFF9CA3AF),
                    indicatorColor: primary,
                    indicatorWeight: 2.5,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: 'Availability'),
                      Tab(text: 'Appointments'),
                    ],
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                NurseAvailabilityScreen(embedded: true),
                NurseAppointmentsScreen(embedded: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
