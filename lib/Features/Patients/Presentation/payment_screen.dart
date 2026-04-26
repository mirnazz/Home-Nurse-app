import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_failed_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Appointment appointment;

  const PaymentScreen({super.key, required this.appointment});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isSubmitting = false;

  Future<void> _confirmPayment() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final bookingId = widget.appointment.id;

      // 1) create payment intent from backend
      final clientSecret = await ApiService.createPaymentIntent(
        bookingId: bookingId,
      );

      // 2) init payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'NurseNow',
          style: ThemeMode.light,

          // 🔥 مهم
          allowsDelayedPaymentMethods: false,
        ),
      );
      // 3) present payment sheet to user
      await Stripe.instance.presentPaymentSheet();

      // 4) notify backend after Stripe success
      await ApiService.confirmPayment(bookingId: bookingId);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (_) => PaymentSuccessScreen(amount: widget.appointment.price),
        ),
      );
    } on StripeException {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PaymentFailedScreen(appointment: widget.appointment),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment error: $e')));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PaymentFailedScreen(appointment: widget.appointment),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
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
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
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
                children: const [
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Stripe Payment Sheet will open when you confirm payment.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child:
                  _isSubmitting
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.2,
                        ),
                      )
                      : const Text(
                        'Confirm Payment',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
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
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
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
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color:
                  highlight
                      ? AppointmentUiColors.tealHeader
                      : const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
