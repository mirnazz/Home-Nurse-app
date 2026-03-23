import 'package:flutter/material.dart';
import 'package:nurse_app/core/enums/appointment_status.dart';

/// Patient dashboard appointment presentation (list + details).
///
/// **Upcoming:** Pending, Confirmed (+ pay message), Rejected, Active/Paid.
/// **Past:** Cancelled, Completed.
///
/// [waitingPayment] is treated like [confirmed] in the UI (nurse accepted; patient must pay).
bool patientAppointmentShowsPaymentBanner(AppointmentStatus status) {
  return status == AppointmentStatus.confirmed || status == AppointmentStatus.waitingPayment;
}

/// Chip colors/label for patient-facing appointment cards and details.
(Color bg, Color fg, IconData icon, String label, Color? border) patientAppointmentChipStyle(
  AppointmentStatus status,
) {
  return switch (status) {
    AppointmentStatus.pending => (
        const Color(0xFFF3F4F6),
        const Color(0xFF374151),
        Icons.schedule_rounded,
        'Pending',
        null,
      ),
    AppointmentStatus.confirmed => (
        const Color(0xFFD1FAE5),
        const Color(0xFF047857),
        Icons.check_circle_outline_rounded,
        'Confirmed',
        null,
      ),
    AppointmentStatus.waitingPayment => (
        const Color(0xFFD1FAE5),
        const Color(0xFF047857),
        Icons.check_circle_outline_rounded,
        'Confirmed',
        null,
      ),
    AppointmentStatus.paid => (
        const Color(0xFFD1FAE5),
        const Color(0xFF15803D),
        Icons.verified_outlined,
        'Active/Paid',
        null,
      ),
    AppointmentStatus.completed => (
        const Color(0xFFD1FAE5),
        const Color(0xFF15803D),
        Icons.check_circle_outline_rounded,
        'Completed',
        null,
      ),
    AppointmentStatus.cancelled => (
        const Color(0xFFFEE2E2),
        const Color(0xFFB91C1C),
        Icons.cancel_outlined,
        'Cancelled',
        null,
      ),
    AppointmentStatus.rejected => (
        const Color(0xFFFEE2E2),
        const Color(0xFFDC2626),
        Icons.block_rounded,
        'Rejected',
        null,
      ),
  };
}
