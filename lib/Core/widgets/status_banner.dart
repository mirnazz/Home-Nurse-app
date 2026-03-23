import 'package:flutter/material.dart';
import 'package:nurse_app/core/enums/appointment_status.dart';

/// Contextual banner for appointment details (Material 3 style).
class StatusBanner extends StatelessWidget {
  final AppointmentStatus status;
  final bool isNurseContext;

  const StatusBanner({
    super.key,
    required this.status,
    this.isNurseContext = false,
  });

  static (Color bg, Color fg, IconData icon, String message) _content({
    required AppointmentStatus status,
    required bool isNurseContext,
  }) {
    switch (status) {
      case AppointmentStatus.pending:
        return (
          const Color(0xFFF3F4F6),
          const Color(0xFF374151),
          Icons.schedule_rounded,
          isNurseContext
              ? 'This booking is waiting for your response.'
              : 'Your request is pending confirmation.',
        );
      case AppointmentStatus.confirmed:
        return (
          const Color(0xFFD1FAE5),
          const Color(0xFF047857),
          Icons.check_circle_outline_rounded,
          'Appointment confirmed. See you at the scheduled time.',
        );
      case AppointmentStatus.waitingPayment:
        return (
          const Color(0xFFFFEDD5),
          const Color(0xFFC2410C),
          Icons.payments_outlined,
          isNurseContext
              ? 'Payment is pending from the patient.'
              : 'Please complete payment to finalize this appointment.',
        );
      case AppointmentStatus.paid:
        return (
          const Color(0xFFD1FAE5),
          const Color(0xFF15803D),
          Icons.verified_outlined,
          'Payment received. Appointment is active.',
        );
      case AppointmentStatus.completed:
        return (
          const Color(0xFFDBEAFE),
          const Color(0xFF1D4ED8),
          Icons.task_alt_rounded,
          'This appointment has been completed.',
        );
      case AppointmentStatus.cancelled:
        return (
          const Color(0xFFFEE2E2),
          const Color(0xFFB91C1C),
          Icons.cancel_outlined,
          'This appointment was cancelled.',
        );
      case AppointmentStatus.rejected:
        return (
          const Color(0xFFFEE2E2),
          const Color(0xFF991B1B),
          Icons.block_rounded,
          'This request was not accepted.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon, message) = _content(
      status: status,
      isNurseContext: isNurseContext,
    );
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: fg, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
