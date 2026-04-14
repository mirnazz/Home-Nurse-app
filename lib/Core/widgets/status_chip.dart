import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/enums/appointment_status.dart';

/// Small pill showing [AppointmentStatus] with role-aware colors.
/// Patient list: [waitingPayment] is shown as "Confirmed" (pay step) — use [patientAppointmentChipStyle] on patient screens.
/// Green: paid/active/completed · Red: cancelled/rejected.
class StatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const StatusChip({super.key, required this.status});

  static (Color bg, Color fg, String label) styleFor(
    AppLocalizations l10n,
    AppointmentStatus s,
  ) {
    switch (s) {
      case AppointmentStatus.pending:
        return (
          const Color(0xFFE5E7EB),
          const Color(0xFF374151),
          l10n.patientAppointmentStatusPending,
        );
      case AppointmentStatus.confirmed:
        return (
          const Color(0xFFD1FAE5),
          const Color(0xFF047857),
          l10n.patientAppointmentStatusConfirmed,
        );
      case AppointmentStatus.waitingPayment:
        return (
          const Color(0xFFFFEDD5),
          const Color(0xFFC2410C),
          l10n.nurseAppointmentStatusWaitingPayment,
        );
      case AppointmentStatus.paid:
        return (
          const Color(0xFFD1FAE5),
          const Color(0xFF15803D),
          l10n.patientAppointmentStatusActivePaid,
        );
      case AppointmentStatus.completed:
        return (
          const Color(0xFFD1FAE5),
          const Color(0xFF15803D),
          l10n.patientAppointmentStatusCompleted,
        );
      case AppointmentStatus.cancelled:
        return (
          const Color(0xFFFEE2E2),
          const Color(0xFFB91C1C),
          l10n.patientAppointmentStatusCancelled,
        );
      case AppointmentStatus.rejected:
        return (
          const Color(0xFFFEE2E2),
          const Color(0xFF991B1B),
          l10n.patientAppointmentStatusRejected,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = styleFor(AppLocalizations.of(context)!, status);
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
