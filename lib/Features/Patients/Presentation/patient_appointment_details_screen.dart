import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/core/enums/appointment_status.dart';
import 'package:nurse_app/core/models/appointment.dart';
import 'package:nurse_app/core/theme/appointment_ui_colors.dart';
import '../../../Core/utils/contact_launch.dart';
import 'package:nurse_app/core/widgets/appointment_detail_row.dart';
import 'package:nurse_app/core/widgets/appointment_list_card.dart';
import 'package:nurse_app/core/widgets/patient_appointment_status_ui.dart';

/// Status chip on patient details (mock: amber Pending + border).
(Color, Color, IconData, String, Color) _patientDetailsStatusStyle(AppointmentStatus status) {
  return switch (status) {
    AppointmentStatus.pending => (
        const Color(0xFFFFFBEB),
        const Color(0xFFD97706),
        Icons.error_outline_rounded,
        'Pending',
        const Color(0xFFF59E0B),
      ),
    AppointmentStatus.confirmed => (
        const Color(0xFFD1FAE5),
        const Color(0xFF047857),
        Icons.check_circle_outline_rounded,
        'Confirmed',
        const Color(0xFF6EE7B7),
      ),
    AppointmentStatus.waitingPayment => (
        const Color(0xFFD1FAE5),
        const Color(0xFF047857),
        Icons.check_circle_outline_rounded,
        'Confirmed',
        const Color(0xFF6EE7B7),
      ),
    AppointmentStatus.paid => (
        const Color(0xFFD1FAE5),
        const Color(0xFF15803D),
        Icons.verified_outlined,
        'Active/Paid',
        const Color(0xFF6EE7B7),
      ),
    AppointmentStatus.completed => (
        const Color(0xFFD1FAE5),
        const Color(0xFF15803D),
        Icons.check_circle_outline_rounded,
        'Completed',
        const Color(0xFF6EE7B7),
      ),
    AppointmentStatus.cancelled => (
        const Color(0xFFFEE2E2),
        const Color(0xFFB91C1C),
        Icons.cancel_outlined,
        'Cancelled',
        const Color(0xFFF87171),
      ),
    AppointmentStatus.rejected => (
        const Color(0xFFFEE2E2),
        const Color(0xFFDC2626),
        Icons.block_rounded,
        'Rejected',
        const Color(0xFFF87171),
      ),
  };
}

/// Patient appointment details — layout matches dashboard mock (cards, teal theme).
/// TODO(backend): Wire pay / contact / cancel to API.
class PatientAppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const PatientAppointmentDetailsScreen({super.key, required this.appointment});

  static const _cardRadius = 18.0;
  static const _sectionTitleStyle = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 17,
    color: Color(0xFF111827),
    letterSpacing: -0.2,
  );

  static String _timeWithDuration(Appointment a) {
    final t = DateFormat.jm().format(a.dateTime);
    final m = a.durationMinutes;
    if (m == null) return t;
    if (m % 60 == 0 && m ~/ 60 > 0) return '$t (${m ~/ 60}hr)';
    return '$t (${m}min)';
  }

  /// Dark pill on teal payment card (mock: UNPAID / PAID on charcoal).
  static (String label, Color badgeBg) _paymentBadge(AppointmentStatus s) {
    return switch (s) {
      AppointmentStatus.pending => ('AWAITING NURSE', const Color(0xFF4B5563)),
      AppointmentStatus.waitingPayment => ('UNPAID', const Color(0xFF374151)),
      AppointmentStatus.confirmed => ('UNPAID', const Color(0xFF374151)),
      AppointmentStatus.paid => ('PAID', const Color(0xFF374151)),
      AppointmentStatus.completed => ('PAID', const Color(0xFF374151)),
      AppointmentStatus.cancelled => ('CANCELLED', const Color(0xFF4B5563)),
      AppointmentStatus.rejected => ('REJECTED', const Color(0xFF4B5563)),
    };
  }

  static BoxDecoration _whiteCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_cardRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(appointment.dateTime);
    final (paymentLabel, badgeBg) = _paymentBadge(appointment.status);
    final teal = AppointmentUiColors.tealHeader;
    final specialty = appointment.nurseSpecialty ?? appointment.serviceName;
    final nurseTel = appointment.nursePhone ?? '—';
    final nursePhoneRaw = nurseTel == '—' ? '' : nurseTel;

    return Scaffold(
      backgroundColor: AppointmentUiColors.pageBackground,
      appBar: AppBar(
        backgroundColor: teal,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        leadingWidth: 88,
        leading: TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              SizedBox(width: 4),
              Text('Back', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
        ),
        title: const Text(
          'Appointment Details',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
        children: [
          // 1 — Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: _whiteCardDecoration(),
            child: _PatientStatusRow(status: appointment.status),
          ),
          const SizedBox(height: 14),
          // 2 — Nurse information
          Container(
            padding: const EdgeInsets.all(18),
            decoration: _whiteCardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nurse Information', style: _sectionTitleStyle),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: teal.withValues(alpha: 0.18),
                      child: Text(
                        appointmentInitials(appointment.nurseName),
                        style: TextStyle(
                          color: teal,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.nurseName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            specialty,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            nurseTel,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppointmentCallWhatsAppRow(
                  phone: nursePhoneRaw,
                  accentTeal: teal,
                  callButtonLabel: 'Call',
                  numberDialogTitle: 'Nurse phone number',
                  greyCallStyle: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // 3 — Appointment details (date / time / address only)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: _whiteCardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Appointment Details', style: _sectionTitleStyle),
                const SizedBox(height: 14),
                AppointmentDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: dateStr,
                ),
                const SizedBox(height: 10),
                AppointmentDetailRow(
                  icon: Icons.access_time_rounded,
                  label: 'Time & Duration',
                  value: _timeWithDuration(appointment),
                ),
                const SizedBox(height: 10),
                AppointmentDetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: appointment.location,
                ),
              ],
            ),
          ),
          if (patientAppointmentShowsPaymentBanner(appointment.status)) ...[
            const SizedBox(height: 14),
            const _PatientPayToContinueBanner(),
          ],
          const SizedBox(height: 14),
          // 4 — Total cost & payment status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: teal,
              borderRadius: BorderRadius.circular(_cardRadius),
              boxShadow: [
                BoxShadow(
                  color: teal.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Cost',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${appointment.price.toStringAsFixed(0)} JOD',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Payment Status',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        paymentLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          ..._buildActionButtons(context, teal),
        ],
      ),
    );
  }

  List<Widget> _payAndCancel(BuildContext context, Color teal) {
    return [
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () => _stub(context, 'Pay now (API)'),
          style: FilledButton.styleFrom(
            backgroundColor: AppointmentUiColors.orangeBanner,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('Pay now', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      ),
      const SizedBox(height: 12),
      _cancelButton(context),
    ];
  }

  List<Widget> _buildActionButtons(BuildContext context, Color teal) {
    switch (appointment.status) {
      case AppointmentStatus.waitingPayment:
      case AppointmentStatus.confirmed:
        return _payAndCancel(context, teal);
      case AppointmentStatus.pending:
      case AppointmentStatus.paid:
        return [
          _cancelButton(context),
        ];
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
      case AppointmentStatus.rejected:
        return [
          Text(
            'No actions available for this appointment.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ];
    }
  }

  Widget _cancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _stub(context, 'Cancel appointment (API)'),
        icon: const Icon(Icons.block_rounded),
        label: const Text('Cancel Appointment'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFDC2626),
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFFECACA), width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  void _stub(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PatientPayToContinueBanner extends StatelessWidget {
  const _PatientPayToContinueBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppointmentUiColors.orangeBanner,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pay to continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your nurse confirmed this appointment. Please complete payment to activate it and keep your booking.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.35,
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

class _PatientStatusRow extends StatelessWidget {
  final AppointmentStatus status;

  const _PatientStatusRow({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon, label, border) = _patientDetailsStatusStyle(status);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Color(0xFF111827),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border, width: 1.4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
