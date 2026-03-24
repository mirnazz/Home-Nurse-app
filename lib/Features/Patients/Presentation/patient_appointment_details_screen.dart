import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/enums/appointment_status.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:url_launcher/url_launcher.dart';


(Color bg, Color fg, IconData icon, String label, Color border)
    _patientDetailsStatusStyle(AppointmentStatus status) {
  switch (status) {
    case AppointmentStatus.pending:
      return (
        const Color(0xFFFFFBEB),
        const Color(0xFFD97706),
        Icons.access_time_rounded,
        'Pending',
        const Color(0xFFF59E0B),
      );
    case AppointmentStatus.confirmed:
    case AppointmentStatus.waitingPayment:
      return (
        const Color(0xFFD1FAE5),
        const Color(0xFF047857),
        Icons.check_circle_outline_rounded,
        'Confirmed',
        const Color(0xFF6EE7B7),
      );
    case AppointmentStatus.paid:
      return (
        const Color(0xFFD1FAE5),
        const Color(0xFF15803D),
        Icons.verified_outlined,
        'Active/Paid',
        const Color(0xFF6EE7B7),
      );
    case AppointmentStatus.completed:
      return (
        const Color(0xFFD1FAE5),
        const Color(0xFF15803D),
        Icons.check_circle_outline_rounded,
        'Completed',
        const Color(0xFF6EE7B7),
      );
    case AppointmentStatus.cancelled:
      return (
        const Color(0xFFFEE2E2),
        const Color(0xFFB91C1C),
        Icons.cancel_outlined,
        'Cancelled',
        const Color(0xFFF87171),
      );
    case AppointmentStatus.rejected:
      return (
        const Color(0xFFFEE2E2),
        const Color(0xFFDC2626),
        Icons.block_rounded,
        'Rejected',
        const Color(0xFFF87171),
      );
  }
}

class PatientAppointmentDetailsScreen extends StatefulWidget {
  final Appointment appointment;

  const PatientAppointmentDetailsScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<PatientAppointmentDetailsScreen> createState() =>
      _PatientAppointmentDetailsScreenState();
}

class _PatientAppointmentDetailsScreenState
    extends State<PatientAppointmentDetailsScreen> {
  late Appointment _appointment;
  bool _isLoading = true;
  bool _isCancelling = false;
  String? _errorMessage;

  static const _cardRadius = 18.0;
  static const _sectionTitleStyle = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 17,
    color: Color(0xFF111827),
    letterSpacing: -0.2,
  );

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final details = await ApiService.getPatientAppointmentDetails(
        bookingId: _appointment.id,
      );

      if (!mounted) return;

      setState(() {
        _appointment = details;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  static String _timeWithDuration(Appointment a) {
    final t = DateFormat.jm().format(a.dateTime);
    final m = a.durationMinutes;
    if (m == null) return t;
    if (m % 60 == 0 && m ~/ 60 > 0) return '$t (${m ~/ 60}hr)';
    return '$t (${m}min)';
  }

  static ({String label, Color badgeBg}) _paymentBadge(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.pending:
        return (label: 'AWAITING NURSE', badgeBg: const Color(0xFF4B5563));
      case AppointmentStatus.confirmed:
      case AppointmentStatus.waitingPayment:
        return (label: 'UNPAID', badgeBg: const Color(0xFF374151));
      case AppointmentStatus.paid:
      case AppointmentStatus.completed:
        return (label: 'PAID', badgeBg: const Color(0xFF374151));
      case AppointmentStatus.cancelled:
        return (label: 'CANCELLED', badgeBg: const Color(0xFF4B5563));
      case AppointmentStatus.rejected:
        return (label: 'REJECTED', badgeBg: const Color(0xFF4B5563));
    }
  }

  bool get _showPayBanner =>
      _appointment.status == AppointmentStatus.confirmed ||
      _appointment.status == AppointmentStatus.waitingPayment;

  bool get _canCancel =>
      _appointment.status == AppointmentStatus.pending ||
      _appointment.status == AppointmentStatus.confirmed ||
      _appointment.status == AppointmentStatus.waitingPayment;

  Future<void> _makeCall() async {
    final phone = _appointment.nursePhone;
    if (phone == null || phone.trim().isEmpty) {
      _showSnack('Phone number is not available.');
      return;
    }

    final uri = Uri.parse('tel:${phone.trim()}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnack('Could not open dialer.');
    }
  }

  Future<void> _openWhatsApp() async {
    final phone = _appointment.nursePhone;
    if (phone == null || phone.trim().isEmpty) {
      _showSnack('Phone number is not available.');
      return;
    }

    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$digits');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnack('Could not open WhatsApp.');
    }
  }

  Future<void> _cancelAppointment() async {
    if (!_canCancel || _isCancelling) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel appointment'),
          content: const Text(
            'Are you sure you want to cancel this appointment?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes, cancel'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() => _isCancelling = true);

    try {
      await ApiService.cancelPatientAppointment(
        bookingId: _appointment.id,
      );

      if (!mounted) return;

      setState(() {
        _appointment = _appointment.copyWith(
          status: AppointmentStatus.cancelled,
        );
        _isCancelling = false;
      });

      _showSnack('Appointment cancelled successfully.');
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCancelling = false);
      _showSnack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _payNowStub() {
    _showSnack('Payment integration is not implemented yet.');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _initials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'N';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final teal = AppointmentUiColors.tealHeader;
    final payment = _paymentBadge(_appointment.status);
final String paymentLabel = payment.label;
final Color badgeBg = payment.badgeBg;

    return Scaffold(
      backgroundColor: AppointmentUiColors.pageBackground,
      appBar: AppBar(
        backgroundColor: teal,
        elevation: 0,
        title: const Text(
          'Appointment Details',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _DetailsErrorState(
                  message: _errorMessage!,
                  onRetry: _loadDetails,
                )
              : SafeArea(
                  top: false,
                  child: RefreshIndicator(
                    onRefresh: _loadDetails,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      children: [
                        _SectionCard(
                          child: _PatientStatusRow(status: _appointment.status),
                        ),
                        const SizedBox(height: 12),
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nurse Information',
                                style: _sectionTitleStyle,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFFDCECEF),
                                    child: Text(
                                      _initials(_appointment.nurseName),
                                      style: const TextStyle(
                                        color: Color(0xFF1D7D8A),
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _appointment.nurseName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 17,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          (_appointment.nurseSpecialty != null &&
                                                  _appointment.nurseSpecialty!
                                                      .trim()
                                                      .isNotEmpty)
                                              ? _appointment.nurseSpecialty!
                                              : _appointment.serviceName,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _makeCall,
                                      icon: const Icon(Icons.call_outlined),
                                      label: const Text('Call'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFF6B7280),
                                        side: const BorderSide(
                                          color: Color(0xFFE5E7EB),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _openWhatsApp,
                                      icon: const Icon(Icons.chat_outlined),
                                      label: const Text('WhatsApp'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFF22C55E),
                                        side: const BorderSide(
                                          color: Color(0xFF22C55E),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Appointment Details',
                                style: _sectionTitleStyle,
                              ),
                              const SizedBox(height: 14),
                              _DetailInfoTile(
                                icon: Icons.calendar_month_outlined,
                                label: 'Date',
                                value: DateFormat(
                                  'yyyy-MM-dd',
                                ).format(_appointment.dateTime),
                              ),
                              const SizedBox(height: 10),
                              _DetailInfoTile(
                                icon: Icons.access_time_rounded,
                                label: 'Time & Duration',
                                value: _timeWithDuration(_appointment),
                              ),
                              const SizedBox(height: 10),
                              _DetailInfoTile(
                                icon: Icons.location_on_outlined,
                                label: 'Address',
                                value: _appointment.location,
                              ),
                            ],
                          ),
                        ),
                        if (_showPayBanner) ...[
                          const SizedBox(height: 12),
                          const _PatientPayToContinueBanner(),
                        ],
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: teal,
                            borderRadius: BorderRadius.circular(_cardRadius),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Cost',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.92,
                                        ),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${_appointment.price.toStringAsFixed(_appointment.price.truncateToDouble() == _appointment.price ? 0 : 2)} JOD',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
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
                                      color: Colors.white.withValues(
                                        alpha: 0.92,
                                      ),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
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
                  ),
                ),
    );
  }

  List<Widget> _payAndCancel(BuildContext context, Color teal) {
    return [
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _payNowStub,
          style: FilledButton.styleFrom(
            backgroundColor: AppointmentUiColors.orangeBanner,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Pay now',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ),
      ),
      const SizedBox(height: 12),
      _cancelButton(context),
    ];
  }

  List<Widget> _buildActionButtons(BuildContext context, Color teal) {
    switch (_appointment.status) {
      case AppointmentStatus.waitingPayment:
      case AppointmentStatus.confirmed:
        return _payAndCancel(context, teal);

      case AppointmentStatus.pending:
        return [
          _cancelButton(context),
        ];

      case AppointmentStatus.paid:
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
        onPressed: _isCancelling ? null : _cancelAppointment,
        icon: _isCancelling
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.block_rounded),
        label: Text(_isCancelling ? 'Cancelling...' : 'Cancel Appointment'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFDC2626),
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFFECACA), width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _DetailsErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _DetailsErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load appointment details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _DetailInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1D7D8A)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
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
            border: Border.all(color: border, width: 1.2),
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
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
