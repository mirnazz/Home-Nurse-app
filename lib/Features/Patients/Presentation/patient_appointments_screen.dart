import 'package:flutter/material.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/widgets/appointment_list_card.dart';
import 'package:nurse_app/Core/widgets/appointment_segment_header.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_appointment_details_screen.dart';

class PatientAppointmentsScreen extends StatefulWidget {
  final List<Appointment>? appointments;

  const PatientAppointmentsScreen({super.key, this.appointments});

  @override
  State<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen> {
  int _segmentIndex = 0;

  bool _isLoading = true;
  String? _errorMessage;

  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _pastAppointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    if (widget.appointments != null) {
      setState(() {
        _upcomingAppointments = widget.appointments!;
        _pastAppointments = const [];
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        ApiService.getPatientAppointments(tab: 'upcoming'),
        ApiService.getPatientAppointments(tab: 'past'),
      ]);

      if (!mounted) return;

      setState(() {
        _upcomingAppointments = results[0];
        _pastAppointments = results[1];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _upcomingAppointments = [];
        _pastAppointments = [];
      });
    }
  }

  Future<void> _openDetails(Appointment appointment) async {
    print("OPEN DETAILS FOR BOOKING ID: ${appointment.id}");
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => PatientAppointmentDetailsScreen(
          appointment: appointment,
        ),
      ),
    );

    if (!mounted) return;
    await _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _upcomingAppointments;
    final past = _pastAppointments;
    final list = _segmentIndex == 0 ? upcoming : past;
    final emptyMessage = _segmentIndex == 0
        ? 'No upcoming appointments.'
        : 'No past appointments.';

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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _errorMessage != null
                    ? _ErrorState(
                        message: _errorMessage!,
                        onRetry: _loadAppointments,
                      )
                    : list.isEmpty
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
                        : RefreshIndicator(
                            onRefresh: _loadAppointments,
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 18, 16, 100),
                              itemCount: list.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
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
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load appointments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
