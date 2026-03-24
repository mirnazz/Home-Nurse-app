import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/enums/appointment_status.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/Core/widgets/nurse_appointment_chip_style.dart';
import 'package:nurse_app/Core/widgets/patient_appointment_status_ui.dart';

String appointmentInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final p = parts[0];
    return p.isNotEmpty ? p[0].toUpperCase() : '?';
  }
  final a = parts.first.isNotEmpty ? parts.first[0] : '';
  final b = parts.last.isNotEmpty ? parts.last[0] : '';
  return ('$a$b').toUpperCase();
}

/// List card matching nurse/patient appointment mocks (banner, chip, date/time rows).
class AppointmentListCard extends StatelessWidget {
  final Appointment appointment;
  final bool isNurseView;
  final VoidCallback? onTap;

  const AppointmentListCard({
    super.key,
    required this.appointment,
    required this.isNurseView,
    this.onTap,
  });

  String get _primaryName => isNurseView ? appointment.patientName : appointment.nurseName;

  bool get _showPaymentBanner => isNurseView
      ? appointment.status == AppointmentStatus.waitingPayment
      : patientAppointmentShowsPaymentBanner(appointment.status);

  @override
  Widget build(BuildContext context) {
    final primary = AppointmentUiColors.tealHeader;
    final dateStr = DateFormat('yyyy-MM-dd').format(appointment.dateTime);
    final timeStr = DateFormat.jm().format(appointment.dateTime);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_showPaymentBanner)
                _PaymentBanner(
                  isNurseView: isNurseView,
                  isConfirmedAwaitingPayment: !isNurseView &&
                      patientAppointmentShowsPaymentBanner(appointment.status),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: primary.withValues(alpha: 0.15),
                          child: Text(
                            appointmentInitials(_primaryName),
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _primaryName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                appointment.serviceName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _ListStatusChip(
                          status: appointment.status,
                          nurseLabels: isNurseView,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 18, color: primary),
                        const SizedBox(width: 8),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time_rounded, size: 18, color: primary),
                        const SizedBox(width: 8),
                        Text(
                          timeStr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 18, color: primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            appointment.location,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isNurseView ? 'Your Earning' : 'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          '${appointment.price.toStringAsFixed(0)} JOD',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentBanner extends StatelessWidget {
  final bool isNurseView;
  /// Patient: nurse confirmed; show pay-to-continue copy (status chip still "Confirmed").
  final bool isConfirmedAwaitingPayment;

  const _PaymentBanner({
    required this.isNurseView,
    this.isConfirmedAwaitingPayment = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      color: AppointmentUiColors.orangeBanner,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNurseView
                      ? 'Waiting for Payment'
                      : (isConfirmedAwaitingPayment
                          ? 'Pay to continue'
                          : 'Payment required'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isNurseView
                      ? "Patient hasn't paid yet — you can contact or cancel."
                      : (isConfirmedAwaitingPayment
                          ? 'Your nurse confirmed this appointment. Please complete payment to activate it and keep your booking.'
                          : 'Complete payment to confirm your appointment.'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.3,
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

class _ListStatusChip extends StatelessWidget {
  final AppointmentStatus status;
  final bool nurseLabels;

  const _ListStatusChip({
    required this.status,
    this.nurseLabels = false,
  });

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, IconData icon, String label, Color? border) =
        nurseLabels ? nurseAppointmentChipStyle(status) : patientAppointmentChipStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: border != null ? Border.all(color: border, width: 1.2) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

}
