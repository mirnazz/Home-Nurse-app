import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/enums/appointment_status.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';

class NurseAppointmentDetailsScreen extends StatefulWidget {
  final Appointment appointment;

  const NurseAppointmentDetailsScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<NurseAppointmentDetailsScreen> createState() =>
      _NurseAppointmentDetailsScreenState();
}

class _NurseAppointmentDetailsScreenState
    extends State<NurseAppointmentDetailsScreen> {
  late Appointment _appointment;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
  }

  bool get _canCancel {
    return _appointment.status == AppointmentStatus.pending ||
        _appointment.status == AppointmentStatus.confirmed;
  }

  bool get _canComplete {
    return _appointment.status == AppointmentStatus.confirmed ||
        _appointment.status == AppointmentStatus.paid;
  }

  String _statusLabel(AppLocalizations l10n) {
    switch (_appointment.status) {
      case AppointmentStatus.pending:
        return l10n.nurseAppointmentStatusWaitingPayment;
      case AppointmentStatus.confirmed:
        return l10n.nurseStatusAccepted;
      case AppointmentStatus.paid:
        return l10n.nurseAppointmentStatusActivePaid;
      case AppointmentStatus.completed:
        return l10n.nurseStatusCompleted;
      case AppointmentStatus.cancelled:
        return l10n.nurseStatusCancelled;
      case AppointmentStatus.rejected:
        return l10n.nurseStatusRejected;
      case AppointmentStatus.waitingPayment:
        return l10n.nurseAppointmentStatusWaitingPayment;
    }
  }

  Color get _statusColor {
    switch (_appointment.status) {
      case AppointmentStatus.pending:
      case AppointmentStatus.waitingPayment:
        return const Color(0xFFF97316);
      case AppointmentStatus.confirmed:
        return const Color(0xFF2563EB);
      case AppointmentStatus.paid:
        return const Color(0xFF16A34A);
      case AppointmentStatus.completed:
        return const Color(0xFF16A34A);
      case AppointmentStatus.cancelled:
      case AppointmentStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }

  Color get _statusBg {
    switch (_appointment.status) {
      case AppointmentStatus.pending:
      case AppointmentStatus.waitingPayment:
        return const Color(0xFFFFEDD5);
      case AppointmentStatus.confirmed:
        return const Color(0xFFDBEAFE);
      case AppointmentStatus.paid:
        return const Color(0xFFDCFCE7);
      case AppointmentStatus.completed:
        return const Color(0xFFDCFCE7);
      case AppointmentStatus.cancelled:
      case AppointmentStatus.rejected:
        return const Color(0xFFFEE2E2);
    }
  }

  String _paymentLabel(AppLocalizations l10n) {
    switch (_appointment.status) {
      case AppointmentStatus.paid:
      case AppointmentStatus.completed:
        return l10n.nurseAppointmentPaymentPaid;
      case AppointmentStatus.cancelled:
      case AppointmentStatus.rejected:
        return l10n.nurseAppointmentPaymentNotApplicable;
      case AppointmentStatus.pending:
      case AppointmentStatus.waitingPayment:
      case AppointmentStatus.confirmed:
        return l10n.nurseAppointmentPaymentUnpaid;
    }
  }

  Color _paymentChipBg(AppLocalizations l10n) {
    switch (_appointment.status) {
      case AppointmentStatus.paid:
      case AppointmentStatus.completed:
        return Colors.white.withOpacity(0.18);
      case AppointmentStatus.pending:
      case AppointmentStatus.waitingPayment:
      case AppointmentStatus.confirmed:
        return Colors.white.withOpacity(0.18);
      default:
        return Colors.white.withOpacity(0.12);
    }
  }

  String get _formattedDate {
    return DateFormat('yyyy-MM-dd').format(_appointment.dateTime);
  }

  String _formattedTimeAndDuration(AppLocalizations l10n) {
    final time = DateFormat.jm().format(_appointment.dateTime);
    final duration = _appointment.durationMinutes;
    if (duration == null || duration <= 0) return time;
    return '$time (${l10n.nurseRequestsDurationMinutes(duration)})';
  }

  String _patientName(AppLocalizations l10n) {
    return _appointment.patientName.trim().isEmpty
        ? l10n.nurseHomePatientFallback
        : _appointment.patientName.trim();
  }

  String _serviceName(AppLocalizations l10n) {
    return _appointment.serviceName.trim().isEmpty
        ? l10n.nurseAppointmentServiceFallback
        : _appointment.serviceName.trim();
  }

  String get _phone {
    return (_appointment.patientPhone ?? '').trim();
  }

  String get _notes {
    // إذا كنتِ ما زلتِ مخزنة additionalNotes داخل nurseSpecialty مؤقتًا
    return (_appointment.nurseSpecialty ?? '').trim();
  }

  String get _priceText {
    return _appointment.price % 1 == 0
        ? _appointment.price.toStringAsFixed(0)
        : _appointment.price.toStringAsFixed(2);
  }

  String get _initials {
    final l10n = AppLocalizations.of(context)!;
    final parts = _patientName(l10n)
        .split(' ')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'P';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmText,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: _isProcessing ? null : () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.nurseDialogNo),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    destructive ? const Color(0xFFDC2626) : AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: _isProcessing ? null : () => Navigator.pop(context, true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCancel() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _showConfirmDialog(
      title: l10n.nurseAppointmentCancelTitle,
      message: l10n.nurseAppointmentCancelConfirmMessage,
      confirmText: l10n.nurseAppointmentCancelTitle,
      destructive: true,
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    try {
      await ApiService.cancelNurseAppointment(bookingId: _appointment.id);

      if (!mounted) return;

      setState(() {
        _appointment = _appointment.copyWith(
          status: AppointmentStatus.cancelled,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseAppointmentCancelledSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleComplete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _showConfirmDialog(
      title: l10n.nurseAppointmentMarkCompleted,
      message: l10n.nurseAppointmentCompleteConfirmMessage,
      confirmText: l10n.nurseAppointmentMarkCompleted,
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    try {
      await ApiService.completeNurseAppointment(bookingId: _appointment.id);

      if (!mounted) return;

      setState(() {
        _appointment = _appointment.copyWith(
          status: AppointmentStatus.completed,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseAppointmentCompletedSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 72,
        leading: TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.white),
          label: Text(
            l10n.profileCancel,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(
          l10n.nurseAppointmentDetailsTitle,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          children: [
            if (_appointment.status == AppointmentStatus.pending ||
                _appointment.status == AppointmentStatus.waitingPayment)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.nurseAppointmentWaitingBanner,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            _SectionCard(
              title: l10n.nurseAppointmentStatusLabel,
              child: Align(
                alignment: Alignment.centerRight,
                child: _StatusChip(
                  label: _statusLabel(l10n),
                  color: _statusColor,
                  background: _statusBg,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              title: l10n.nurseAppointmentPatientInformation,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          _initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _patientName(l10n),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _serviceName(l10n),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              if (_notes.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(
                                  _notes,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionMiniButton(
                          icon: Icons.call_outlined,
                          label: l10n.nurseAppointmentCallPatient,
                          enabled: _phone.isNotEmpty,
                          borderColor: const Color(0xFFE5E7EB),
                          textColor: const Color(0xFF9CA3AF),
                          iconColor: const Color(0xFF9CA3AF),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionMiniButton(
                          icon: Icons.chat_outlined,
                          label: l10n.nurseAppointmentWhatsAppPatient,
                          enabled: _phone.isNotEmpty,
                          borderColor: const Color(0xFF22C55E),
                          textColor: const Color(0xFF22C55E),
                          iconColor: const Color(0xFF22C55E),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              title: l10n.nurseAppointmentDetailsSectionTitle,
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.calendar_today_outlined,
                    label: l10n.nurseAppointmentDateLabel,
                    value: _formattedDate,
                  ),
                  const SizedBox(height: 10),
                  _InfoTile(
                    icon: Icons.access_time_outlined,
                    label: l10n.nurseAppointmentTimeDurationLabel,
                    value: _formattedTimeAndDuration(l10n),
                  ),
                  const SizedBox(height: 10),
                  _InfoTile(
                    icon: Icons.location_on_outlined,
                    label: l10n.nurseAppointmentServiceLocationLabel,
                    value: _appointment.location.trim().isEmpty
                        ? '-'
                        : _appointment.location.trim(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.nurseAppointmentYourEarnings,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$_priceText JOD',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.nurseAppointmentPaymentStatusLabel,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _paymentChipBg(l10n),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _paymentLabel(l10n),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_canComplete) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handleComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.nurseAppointmentMarkCompleted,
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                ),
              ),
            ],

            if (_canCancel) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: _isProcessing ? null : _handleCancel,
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFFDC2626),
                    size: 18,
                  ),
                  label: Text(
                    l10n.nurseAppointmentCancelTitle,
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF5B8FA3)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
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

class _ActionMiniButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionMiniButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = enabled ? textColor : const Color(0xFFBFC6CF);
    final ic = enabled ? iconColor : const Color(0xFFBFC6CF);
    final bd = enabled ? borderColor : const Color(0xFFE5E7EB);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: bd),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: ic),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
