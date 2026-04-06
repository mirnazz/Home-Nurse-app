import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nurse_app/Core/enums/appointment_status.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';

/// Visual style for nurse-facing appointment statuses (four states only).
(Color bg, Color fg, IconData icon, String label, Color? border) nurseAppointmentChipStyle(
  AppointmentStatus status,
) {
  switch (status) {
    case AppointmentStatus.waitingPayment:
      return (
        const Color(0xFFFFEDD5),
        AppointmentUiColors.orangeBannerDark,
        Icons.payments_outlined,
        'Waiting for Payment',
        AppointmentUiColors.orangeBannerDark,
      );
    case AppointmentStatus.paid:
      return (
        const Color(0xFFD1FAE5),
        const Color(0xFF15803D),
        Icons.verified_outlined,
        'Active / Paid',
        null,
      );
    case AppointmentStatus.completed:
      return (
        const Color(0xFFD1FAE5),
        const Color(0xFF15803D),
        Icons.check_circle_outline_rounded,
        'Completed',
        null,
      );
    case AppointmentStatus.cancelled:
      return (
        const Color(0xFFFEE2E2),
        const Color(0xFFB91C1C),
        Icons.cancel_outlined,
        'Cancelled',
        null,
      );
    default:
      return (
        const Color(0xFFF3F4F6),
        const Color(0xFF6B7280),
        Icons.help_outline_rounded,
        '—',
        null,
      );
  }
}

String nurseAppointmentStatusLabel(AppLocalizations l10n, AppointmentStatus status) {
  switch (status) {
    case AppointmentStatus.waitingPayment:
      return l10n.nurseAppointmentStatusWaitingPayment;
    case AppointmentStatus.paid:
      return l10n.nurseAppointmentStatusActivePaid;
    case AppointmentStatus.completed:
      return l10n.nurseStatusCompleted;
    case AppointmentStatus.cancelled:
      return l10n.nurseStatusCancelled;
    case AppointmentStatus.confirmed:
      return l10n.nurseStatusAccepted;
    case AppointmentStatus.rejected:
      return l10n.nurseStatusRejected;
    case AppointmentStatus.pending:
      return l10n.nurseStatusPending;
  }
}
