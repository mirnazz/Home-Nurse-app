import 'package:flutter/material.dart';
import 'package:nurse_app/Core/enums/appointment_status.dart';

/// Small pill showing [AppointmentStatus] with role-aware colors.
/// Patient list: [waitingPayment] is shown as "Confirmed" (pay step) — use [patientAppointmentChipStyle] on patient screens.
/// Green: paid/active/completed · Red: cancelled/rejected.
class StatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const StatusChip({super.key, required this.status});

  static (Color bg, Color fg, String label) styleFor(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.pending:
        return (
          const Color(0xFFE5E7EB),
          const Color(0xFF374151),
          'Pending',
        );
      case AppointmentStatus.confirmed:
        return (
          const Color(0xFFD1FAE5),
          const Color(0xFF047857),
          'Confirmed',
        );
      case AppointmentStatus.waitingPayment:
        return (
          const Color(0xFFFFEDD5),
          const Color(0xFFC2410C),
          'Waiting payment',
        );
      case AppointmentStatus.paid:
        return (
          const Color(0xFFD1FAE5),
          const Color(0xFF15803D),
          'Active/Paid',
        );
      case AppointmentStatus.completed:
        return (
          const Color(0xFFD1FAE5),
          const Color(0xFF15803D),
          'Completed',
        );
      case AppointmentStatus.cancelled:
        return (
          const Color(0xFFFEE2E2),
          const Color(0xFFB91C1C),
          'Cancelled',
        );
      case AppointmentStatus.rejected:
        return (
          const Color(0xFFFEE2E2),
          const Color(0xFF991B1B),
          'Rejected',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = styleFor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
