import 'package:flutter/material.dart';
import 'package:nurse_app/core/data/mock_appointments.dart';
import 'package:nurse_app/core/enums/appointment_status.dart';
import 'package:nurse_app/core/models/appointment.dart';
import 'package:nurse_app/core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/core/widgets/appointment_list_card.dart';
import 'package:nurse_app/core/widgets/appointment_segment_header.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_appointment_details_screen.dart';

/// Patient: upcoming vs past appointments (UI + mock data).
/// TODO(backend): Inject [appointments] from API; remove [mockAppointments].
class PatientAppointmentsScreen extends StatefulWidget {
  final List<Appointment>? appointments;

  const PatientAppointmentsScreen({super.key, this.appointments});

  @override
  State<PatientAppointmentsScreen> createState() => _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen> {
  int _segmentIndex = 0;

  List<Appointment> get _source => widget.appointments ?? mockAppointments;

  /// Patient dashboard: nurse response + payment flow (rejected stays here, not under Past).
  static const _upcomingStatuses = {
    AppointmentStatus.pending,
    AppointmentStatus.confirmed,
    AppointmentStatus.waitingPayment,
    AppointmentStatus.paid,
    AppointmentStatus.rejected,
  };

  /// Patient dashboard: only finished / stopped appointments.
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

  Future<void> _openDetails(Appointment appointment) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => PatientAppointmentDetailsScreen(appointment: appointment),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _upcoming();
    final past = _past();
    final list = _segmentIndex == 0 ? upcoming : past;
    final emptyMessage =
        _segmentIndex == 0 ? 'No upcoming appointments.' : 'No past appointments.';

    return Scaffold(
      backgroundColor: AppointmentUiColors.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppointmentSegmentHeader(
            upcomingCount: upcoming.length,
            pastCount: past.length,
            selectedIndex: _segmentIndex,
            onSelected: (i) => setState(() => _segmentIndex = i),
          ),
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        emptyMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final apt = list[index];
                      return AppointmentListCard(
                        appointment: apt,
                        isNurseView: false,
                        onTap: () => _openDetails(apt),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
