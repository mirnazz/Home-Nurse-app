import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_bottom_nav_bar.dart';

class PatientRequestSubmittedScreen extends StatelessWidget {
  final Map<String, dynamic> bookingResponse;

  const PatientRequestSubmittedScreen({
    super.key,
    required this.bookingResponse,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const primary = Color(0xFF2F7F8D);

    final summary =
        (bookingResponse['summary'] as Map<String, dynamic>?) ?? {};

    final nurseName = (summary['nurseName'] ?? '').toString();
    final serviceName = (summary['serviceName'] ?? '').toString();
    final durationInMinutes = (summary['durationInMinutes'] ?? 0).toString();
    final date = (summary['date'] ?? '').toString();
    final time = (summary['time'] ?? '').toString();
    final totalPrice = (summary['totalPrice'] ?? 0).toString();
    final status = (bookingResponse['status'] ?? '').toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF35B96D),
                  size: 42,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.patientRequestSubmittedTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.patientRequestSubmittedBody(nurseName),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 18),
              Container(
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
                      l10n.patientRequestSummary,
                      style: TextStyle(
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SummaryLine(label: l10n.patientRequestNurseLabel, value: nurseName),
                    _SummaryLine(label: l10n.patientRequestServiceLabel, value: serviceName),
                    _SummaryLine(
                      label: l10n.patientRequestDurationLabel,
                      value: l10n.patientAppointmentMinutes(
                        int.tryParse(durationInMinutes) ?? 0,
                      ),
                    ),
                    _SummaryLine(label: l10n.patientRequestDateLabel, value: date),
                    _SummaryLine(label: l10n.patientRequestTimeLabel, value: time),
                    if (status.isNotEmpty)
                      _SummaryLine(label: l10n.patientAppointmentStatusLabel, value: status),
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    _SummaryLine(
                      label: l10n.patientRequestTotalPriceLabel,
                      value: '$totalPrice JOD',
                      highlighted: true,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  child: Text(l10n.patientRequestBackToNurses),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0 || index == 1) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _SummaryLine({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: highlighted ? const Color(0xFF2F7F8D) : const Color(0xFF1F2937),
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
