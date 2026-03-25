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
  late TabController _upcomingPastTabController;

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

  @override
  void initState() {
    super.initState();
    _upcomingPastTabController = TabController(length: 2, vsync: this);
    _upcomingPastTabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _upcomingPastTabController.dispose();
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
    final primary = AppColors.primary;

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: AppointmentUiColors.pageBackground,
          child: TabBar(
            controller: _upcomingPastTabController,
            labelColor: primary,
            unselectedLabelColor: const Color(0xFF9CA3AF),
            indicatorColor: primary,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
            tabs: [
              Tab(text: 'Upcoming (${upcoming.length})'),
              Tab(text: 'Past (${past.length})'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _upcomingPastTabController,
            children: [
              _buildListView(upcoming, 'No upcoming appointments.'),
              _buildListView(past, 'No past appointments.'),
            ],
          ),
        ),
      ],
    );

    if (widget.embedded) {
      return ColoredBox(
        color: AppointmentUiColors.pageBackground,
        child: column,
      );
    }

    return Scaffold(
      backgroundColor: AppointmentUiColors.pageBackground,
      body: column,
    );
  }
}
