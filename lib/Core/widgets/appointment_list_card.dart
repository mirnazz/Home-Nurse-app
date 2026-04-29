import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
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

  /// Nurse schedule: show banner only for "Waiting for Payment".
  /// Patient keeps pay banner when payment is still due.
  bool get _showPaymentBanner =>
      isNurseView
          ? appointment.status == AppointmentStatus.waitingPayment
          : patientAppointmentShowsPaymentBanner(appointment.status);

  @override
  Widget build(BuildContext context) {
    final primary = AppointmentUiColors.tealHeader;
    final dateStr = isNurseView
        ? DateFormat('yyyy-MM-dd').format(appointment.dateTime)
        : DateFormat('EEE, MMM d').format(appointment.dateTime);
    final timeStr = DateFormat.jm().format(appointment.dateTime);
    final r = AppointmentUiColors.scheduleCardRadius;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r),
        child: Container(
          decoration: AppointmentUiColors.scheduleCardDecoration(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_showPaymentBanner)
                _PaymentBanner(
                  isNurseView: isNurseView,
                  isConfirmedAwaitingPayment:
                      patientAppointmentShowsPaymentBanner(appointment.status),
                ),
              Padding(
                padding: AppointmentUiColors.scheduleCardPadding,
                child: isNurseView
                    ? _NurseScheduleCardBody(
                        appointment: appointment,
                        primaryName: _primaryName,
                        primaryColor: primary,
                        dateStr: dateStr,
                        timeStr: timeStr,
                      )
                    : _PatientScheduleCardBody(
                        appointment: appointment,
                        primaryName: _primaryName,
                        primaryColor: primary,
                        dateStr: dateStr,
                        timeStr: timeStr,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NurseScheduleCardBody extends StatelessWidget {
  final Appointment appointment;
  final String primaryName;
  final Color primaryColor;
  final String dateStr;
  final String timeStr;

  const _NurseScheduleCardBody({
    required this.appointment,
    required this.primaryName,
    required this.primaryColor,
    required this.dateStr,
    required this.timeStr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: primaryColor.withValues(alpha: 0.15),
              child: Text(
                appointmentInitials(primaryName),
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Color(0xFF111827),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
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
            const SizedBox(width: 8),
            _ListStatusChip(
              status: appointment.status,
              nurseLabels: true,
            ),
          ],
        ),
        const SizedBox(height: 10),
        _ScheduleMetaRow(
          icon: Icons.calendar_today_outlined,
          color: primaryColor,
          child: Text(
            dateStr,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(height: 6),
        _ScheduleMetaRow(
          icon: Icons.access_time_rounded,
          color: primaryColor,
          child: Text(
            timeStr,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(height: 6),
        _ScheduleMetaRow(
          icon: Icons.location_on_outlined,
          color: primaryColor,
          child: Text(
            appointment.location,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF4B5563),
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppLocalizations.of(context)!.nurseAppointmentYourEarnings,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${appointment.price.toStringAsFixed(0)} JOD',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PatientScheduleCardBody extends StatelessWidget {
  final Appointment appointment;
  final String primaryName;
  final Color primaryColor;
  final String dateStr;
  final String timeStr;

  const _PatientScheduleCardBody({
    required this.appointment,
    required this.primaryName,
    required this.primaryColor,
    required this.dateStr,
    required this.timeStr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: primaryColor.withValues(alpha: 0.15),
              child: Text(
                appointmentInitials(primaryName),
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          primaryName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Color(0xFF111827),
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _ListStatusChip(
                        status: appointment.status,
                        nurseLabels: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
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
          ],
        ),
        const SizedBox(height: 12),
        _ScheduleMetaRow(
          icon: Icons.calendar_today_outlined,
          color: primaryColor,
          child: Text(
            dateStr,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(height: 6),
        _ScheduleMetaRow(
          icon: Icons.access_time_rounded,
          color: primaryColor,
          child: Text(
            timeStr,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(height: 6),
        _ScheduleMetaRow(
          icon: Icons.location_on_outlined,
          color: primaryColor,
          child: Text(
            appointment.location,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF4B5563),
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppLocalizations.of(context)!.patientAppointmentTotal,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${appointment.price.toStringAsFixed(0)} JOD',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScheduleMetaRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Widget child;

  const _ScheduleMetaRow({
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }
}

class _PaymentBanner extends StatelessWidget {
  final bool isNurseView;
  final bool isConfirmedAwaitingPayment;

  const _PaymentBanner({
    required this.isNurseView,
    this.isConfirmedAwaitingPayment = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      color: AppointmentUiColors.orangeBanner,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNurseView
                      ? l10n.nurseAppointmentStatusWaitingPayment
                      : (isConfirmedAwaitingPayment
                          ? l10n.patientPayBannerTitlePayContinue
                          : l10n.patientPayBannerTitlePaymentRequired),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isNurseView
                      ? l10n.nurseAppointmentPaymentPendingBannerBody
                      : (isConfirmedAwaitingPayment
                          ? l10n.patientPayBannerBodyPayContinue
                          : l10n.patientPayBannerBodyPaymentRequired),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
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
    final (Color bg, Color fg, IconData icon, String labelEn, Color? border) =
        nurseLabels ? nurseAppointmentChipStyle(status) : patientAppointmentChipStyle(status);
    final l10n = AppLocalizations.of(context)!;
    final label = nurseLabels
        ? nurseAppointmentStatusLabel(l10n, status)
        : patientAppointmentStatusLabel(l10n, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: border != null ? Border.all(color: border, width: 1.2) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
