import 'package:flutter/material.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_screen.dart';

class PaymentFailedScreen extends StatelessWidget {
  final Appointment appointment;

  const PaymentFailedScreen({super.key, required this.appointment});

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
                    color: Color(0xFFFFECEC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.error_rounded, size: 52, color: Color(0xFFDC2626)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Payment Failed',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We could not process your payment. Please try again.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => PaymentScreen(appointment: appointment),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppointmentUiColors.tealHeader,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Retry Payment',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF374151),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
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
