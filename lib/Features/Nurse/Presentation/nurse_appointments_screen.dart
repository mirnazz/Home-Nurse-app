import 'package:flutter/material.dart';
import 'package:nurse_app/Core/data/mock_appointments.dart';
import 'package:nurse_app/Core/enums/appointment_status.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/Core/widgets/appointment_list_card.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_appointment_details_screen.dart';

/// Nurse: upcoming vs past appointments (UI + mock data).
/// TODO(backend): Inject [appointments] from API; remove [mockAppointments].
class NurseAppointmentsScreen extends StatefulWidget {
  final List<Appointment>? appointments;

  /// When true, used inside [NurseScheduleScreen] without an extra [Scaffold].
  final bool embedded;

  const NurseAppointmentsScreen({
    super.key,
    this.appointments,
    this.embedded = false,
  });

  @override
  State<NurseAppointmentsScreen> createState() => _NurseAppointmentsScreenState();
}

class _NurseAppointmentsScreenState extends State<NurseAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _appointmentsTabController;

  List<Appointment> get _source => widget.appointments ?? mockAppointments;

  /// Nurse sees only: Waiting for payment + Active/paid (upcoming), Completed + Cancelled (past).
  static const _upcomingStatuses = {
    AppointmentStatus.waitingPayment,
    AppointmentStatus.paid,
  };

  static const _pastStatuses = {
    AppointmentStatus.completed,
    AppointmentStatus.cancelled,
  };

  List<Appointment> _upcoming() =>
      _source.where((a) => _upcomingStatuses.contains(a.status)).toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  List<Appointment> _past() =>
      _source.where((a) => _pastStatuses.contains(a.status)).toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// UI-only: show today's appointments using the same nurse-facing statuses
  /// as "Upcoming" (Waiting for Payment + Active/Paid).
  List<Appointment> _today() {
    final now = DateTime.now();
    final list = _source
        .where(
          (a) => _isSameDate(a.dateTime, now) && _upcomingStatuses.contains(a.status),
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  @override
  void initState() {
    super.initState();
    _appointmentsTabController = TabController(length: 3, vsync: this);
    _appointmentsTabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _appointmentsTabController.dispose();
    super.dispose();
  }

  Future<void> _openDetails(Appointment appointment) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => NurseAppointmentDetailsScreen(appointment: appointment),
      ),
    );
    if (mounted) setState(() {});
  }

  Widget _buildListView(List<Appointment> list, String emptyMessage) {
    final listBottomPad = widget.embedded ? 16.0 : 100.0;

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppointmentUiColors.scheduleListHorizontalPadding,
        AppointmentUiColors.scheduleListVerticalGap,
        AppointmentUiColors.scheduleListHorizontalPadding,
        listBottomPad,
      ),
      itemCount: list.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppointmentUiColors.scheduleListVerticalGap),
      itemBuilder: (context, index) {
        final apt = list[index];
        return AppointmentListCard(
          appointment: apt,
          isNurseView: true,
          onTap: () => _openDetails(apt),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _upcoming();
    final past = _past();
    final today = _today();
    final primary = AppointmentUiColors.tealHeader;
    final todayCount = today.length;
    final upcomingCount = upcoming.length;
    final pastCount = past.length;

    final header = Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Appointments',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Material(
            color: primary,
            child: TabBar(
              controller: _appointmentsTabController,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0x80FFFFFF),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: 'Today ($todayCount)'),
                Tab(text: 'Upcoming ($upcomingCount)'),
                Tab(text: 'Past ($pastCount)'),
              ],
            ),
          ),
        ],
      ),
    );

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Expanded(
          child: TabBarView(
            controller: _appointmentsTabController,
            children: [
              _buildListView(today, 'No appointments for today'),
              _buildListView(upcoming, 'No upcoming appointments.'),
              _buildListView(past, 'No past appointments.'),
            ],
          ),
        ),
      ],
    );

    if (widget.embedded) {
      return ColoredBox(
        color: AppColors.background,
        child: column,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: column,
    );
  }
}
