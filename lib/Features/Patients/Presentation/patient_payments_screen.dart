import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

/// Payments tab in the patient bottom navigation (no appointment context).
class PatientPaymentsScreen extends StatelessWidget {
  const PatientPaymentsScreen({super.key});

  static const Color _primary = Color(0xFF2F7F8D);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.patientNavPayments,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.patientPaymentsTabEmpty,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}
