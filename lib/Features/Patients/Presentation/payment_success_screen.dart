import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final double amount;

  const PaymentSuccessScreen({super.key, required this.amount});

  String _formatAmount(double value) {
    final hasDecimals = value.truncateToDouble() != value;
    return '${value.toStringAsFixed(hasDecimals ? 2 : 0)} JOD';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppointmentUiColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppointmentUiColors.tealHeader,
        elevation: 0,
        title: const Text('Payment Status', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 460),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Color(0x0F000000), blurRadius: 14, offset: Offset(0, 6)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 84,
                  width: 84,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE7F8EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 56,
                    color: Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Payment Successful',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Amount paid: ${_formatAmount(amount)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppointmentUiColors.tealHeader,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Back to Appointments',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
