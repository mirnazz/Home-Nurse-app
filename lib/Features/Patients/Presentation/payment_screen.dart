import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_failed_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Appointment appointment;
  final bool mockPaymentSuccess;

  const PaymentScreen({
    super.key,
    required this.appointment,
    this.mockPaymentSuccess = true,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isSubmitting = false;

  Future<void> _confirmPayment() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    if (widget.mockPaymentSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => PaymentSuccessScreen(amount: widget.appointment.price),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => PaymentFailedScreen(appointment: widget.appointment),
        ),
      );
    }
  }

  String _formatAmount(double amount) {
    final hasDecimals = amount.truncateToDouble() != amount;
    return '${amount.toStringAsFixed(hasDecimals ? 2 : 0)} JOD';
  }

  @override
  Widget build(BuildContext context) {
    final apt = widget.appointment;

    return Scaffold(
      backgroundColor: AppointmentUiColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppointmentUiColors.tealHeader,
        elevation: 0,
        title: const Text('Payment', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SummaryRow(label: 'Nurse', value: apt.nurseName),
                  _SummaryRow(label: 'Service', value: apt.serviceName),
                  _SummaryRow(
                    label: 'Date',
                    value: DateFormat('EEE, dd MMM yyyy').format(apt.dateTime),
                  ),
                  _SummaryRow(
                    label: 'Time',
                    value: DateFormat('hh:mm a').format(apt.dateTime),
                  ),
                  _SummaryRow(
                    label: 'Amount',
                    value: _formatAmount(apt.price),
                    isLast: true,
                    highlight: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1F8E9C), Color(0xFF217C8A)],
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.credit_card_rounded, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '****  ****  ****  4242',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 1.1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Mock Visa Card',
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSubmitting ? null : _confirmPayment,
              style: FilledButton.styleFrom(
                backgroundColor: AppointmentUiColors.tealHeader,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                    )
                  : const Text(
                      'Confirm Payment',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      child: child,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: highlight ? AppointmentUiColors.tealHeader : const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
