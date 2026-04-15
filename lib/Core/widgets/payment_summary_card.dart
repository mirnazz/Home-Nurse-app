import 'package:flutter/material.dart';

/// Displays a single financial summary figure (Total Spent or Pending Amount).
///
/// [isDark] = true → filled teal card (Total Spent).
/// [isDark] = false → white card with yellow border (Pending).
/// [amount] should be a pre-formatted string (e.g. "156 JOD") or null for
/// the loading/empty placeholder "— JOD".
class PaymentSummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? amount;
  final bool isDark;

  static const _primary = Color(0xFF2F7F8D);
  static const _yellow = Color(0xFFF59E0B);

  const PaymentSummaryCard({
    super.key,
    required this.icon,
    required this.label,
    this.amount,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return isDark ? _darkCard() : _lightCard();
  }

  Widget _darkCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount ?? '— JOD',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _lightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _yellow, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _yellow.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _yellow, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount ?? '— JOD',
            style: const TextStyle(
              color: Color(0xFF1C1C1C),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
