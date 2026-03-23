import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/core/enums/appointment_status.dart';
import 'package:nurse_app/core/models/appointment.dart';
import 'package:nurse_app/core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/core/widgets/appointment_detail_row.dart';
import 'package:nurse_app/core/widgets/appointment_list_card.dart';
import '../../../Core/utils/contact_launch.dart';
import 'package:nurse_app/core/widgets/nurse_appointment_chip_style.dart';

/// Nurse appointment details: only [waitingPayment], [paid], [completed], [cancelled] appear in lists.
/// TODO(backend): Wire call / message / cancel / complete to API.
class NurseAppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const NurseAppointmentDetailsScreen({super.key, required this.appointment});

  static String _timeWithDuration(Appointment a) {
    final t = DateFormat.jm().format(a.dateTime);
    final m = a.durationMinutes;
    if (m == null) return t;
    if (m % 60 == 0 && m ~/ 60 > 0) return '$t (${m ~/ 60}hr)';
    return '$t (${m}min)';
  }

  static (String label, Color chipBg) _paymentChipStyle(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.waitingPayment:
        return ('UNPAID', Colors.white.withValues(alpha: 0.22));
      case AppointmentStatus.paid:
      case AppointmentStatus.completed:
        return ('PAID', Colors.white.withValues(alpha: 0.22));
      case AppointmentStatus.cancelled:
        return ('CANCELLED', Colors.white.withValues(alpha: 0.22));
      default:
        return ('—', Colors.white.withValues(alpha: 0.22));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(appointment.dateTime);
    final (paymentLabel, chipBg) = _paymentChipStyle(appointment.status);
    final teal = AppointmentUiColors.tealHeader;
    final phone = appointment.patientPhone?.trim().isNotEmpty == true
        ? appointment.patientPhone!
        : '—';
    final patientPhoneForActions = phone == '—' ? '' : phone;

    return Scaffold(
      backgroundColor: AppointmentUiColors.pageBackground,
      appBar: AppBar(
        backgroundColor: teal,
        foregroundColor: Colors.white,
        elevation: 0,
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          if (appointment.status == AppointmentStatus.waitingPayment) ...[
            _WaitingPaymentBanner(),
            const SizedBox(height: 14),
          ],
          _WhiteCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                _NurseDetailStatusChip(status: appointment.status),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Patient Information',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: teal,
                      child: Text(
                        appointmentInitials(appointment.patientName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.patientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment.serviceName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            phone,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppointmentCallWhatsAppRow(
                  phone: patientPhoneForActions,
                  accentTeal: teal,
                  callButtonLabel: 'Call Patient',
                  numberDialogTitle: "Patient's number",
                  greyCallStyle: true,
                  whatsappLabel: 'Message on WhatsApp',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appointment Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    color: Color(0xFF111827),
                  ),
                ),
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
                  label: 'Service Location',
                  value: appointment.location,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: teal,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Earnings',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${appointment.price.toStringAsFixed(0)} JOD',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
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
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        paymentLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._buildActionButtons(context),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    switch (appointment.status) {
      case AppointmentStatus.waitingPayment:
        return [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _stub(context, 'Cancel appointment (API)'),
              icon: const Icon(Icons.block_rounded),
              label: const Text('Cancel Appointment'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFFECACA)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ];
      case AppointmentStatus.paid:
        return [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _stub(context, 'Mark as completed (API)'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Mark as completed'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _stub(context, 'Cancel appointment (API)'),
              icon: const Icon(Icons.block_rounded),
              label: const Text('Cancel Appointment'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFFECACA)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ];
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
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
      default:
        return [
          Text(
            'This appointment is not shown in the nurse schedule.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ];
    }
  }

  void _stub(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _WaitingPaymentBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppointmentUiColors.orangeBanner,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Waiting for Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You confirmed this appointment. The patient needs to complete payment to activate it. '
                  'You can contact them or cancel if needed.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
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

class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Status chip on details screen (matches list styling for nurse four states).
class _NurseDetailStatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const _NurseDetailStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, IconData icon, String label, Color? border) =
        nurseAppointmentChipStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        border: border != null ? Border.all(color: border, width: 1.2) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
