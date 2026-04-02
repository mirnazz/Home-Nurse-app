import 'package:flutter/material.dart';

/// Shared styling tokens (match SignUpScreen).
abstract final class PatientOnboardingTokens {
  static const Color bg = Color(0xFFF6F8FA);
  static const Color text = Color(0xFF1E293B);
  static const Color muted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
}

/// Outline decoration consistent with SignUp / onboarding fields.
InputDecoration patientOnboardingOutlineDecoration(
  Color primary, {
  String? hint,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: PatientOnboardingTokens.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: primary, width: 1.6),
    ),
  );
}
