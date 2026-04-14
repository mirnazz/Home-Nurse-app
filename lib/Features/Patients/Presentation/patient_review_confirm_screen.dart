import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_bottom_nav_bar.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_request_submitted_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_service_request_models.dart';

class PatientReviewConfirmScreen extends StatefulWidget {
  final PatientServiceRequestDraft draft;

  const PatientReviewConfirmScreen({
    super.key,
    required this.draft,
  });

  @override
  State<PatientReviewConfirmScreen> createState() =>
      _PatientReviewConfirmScreenState();
}

class _PatientReviewConfirmScreenState
    extends State<PatientReviewConfirmScreen> {
  bool _isSubmitting = false;

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _formatStartTime(String time) {
    // الباك متوقع TimeSpan مثل 08:00:00
    return time.contains(':') && time.split(':').length == 2
        ? '$time:00'
        : time;
  }

  Future<void> _submitRequest() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final result = await ApiService.createBooking(
        nurseId: widget.draft.nurseId,
        serviceId: int.parse(widget.draft.service.id),
        date: _formatDate(widget.draft.date),
        startTime: _formatStartTime(widget.draft.timeSlot),
        serviceAddress: widget.draft.address.trim(),
        additionalNotes: widget.draft.notes.trim().isEmpty
            ? null
            : widget.draft.notes.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PatientRequestSubmittedScreen(
            bookingResponse: result,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const primary = Color(0xFF2F7F8D);

    final draft = widget.draft;
    final formattedDate = _formatDate(draft.date);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          l10n.patientRequestServiceTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: primary,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _StepTab(
                      title: l10n.patientRequestStepServiceDetails,
                      selected: false,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _StepTab(
                      title: l10n.patientRequestStepReviewConfirm,
                      selected: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  _NurseCard(
                    initials: draft.nurseInitials,
                    name: draft.nurseName,
                    subtitle: draft.nurseSubtitle,
                  ),
                  const SizedBox(height: 12),
                  _BlockCard(
                    title: l10n.patientRequestReviewYourRequest,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(
                          label: l10n.patientRequestServiceType,
                          value: draft.service.title,
                        ),
                        _InfoRow(
                          label: l10n.patientRequestDuration,
                          value: draft.service.durationLabel,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoRow(
                                label: l10n.patientAppointmentDate,
                                value: formattedDate,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InfoRow(
                                label: l10n.patientRequestTime,
                                value: draft.timeSlot,
                              ),
                            ),
                          ],
                        ),
                        _InfoRow(
                          label: l10n.patientAppointmentAddress,
                          value: draft.address,
                        ),
                        _InfoRow(
                          label: l10n.patientRequestNotes,
                          value: draft.notes.trim().isEmpty ? '-' : draft.notes,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _BlockCard(
                    title: l10n.patientRequestServiceCost,
                    child: Column(
                      children: [
                        _CostLine(
                          label: l10n.patientRequestService,
                          value: draft.service.title,
                        ),
                        _CostLine(
                          label: l10n.patientRequestDuration,
                          value: draft.service.durationLabel,
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        _CostLine(
                          label: l10n.patientRequestTotalPrice,
                          value: '${draft.service.priceJod.toStringAsFixed(1)} JOD',
                          highlighted: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: primary.withOpacity(0.65),
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.patientRequestSubmitRequest),
              ),
            ),
          ),
          PatientBottomNavBar(
            currentIndex: 1,
            onTap: (index) {
              if (_isSubmitting) return;

              if (index == 0 || index == 1) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _StepTab extends StatelessWidget {
  final String title;
  final bool selected;

  const _StepTab({
    required this.title,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white70;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 2.2,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}

class _NurseCard extends StatelessWidget {
  final String initials;
  final String name;
  final String subtitle;

  const _NurseCard({
    required this.initials,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFEAF4F6),
            child: Text(
              initials,
              style: const TextStyle(
                color: Color(0xFF2F7F8D),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _BlockCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostLine extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _CostLine({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: highlighted
                ? const Color(0xFF2F7F8D)
                : const Color(0xFF1F2937),
            fontWeight: FontWeight.w800,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}
