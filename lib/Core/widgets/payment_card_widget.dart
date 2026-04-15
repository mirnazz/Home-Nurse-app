import 'package:flutter/material.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_billing_models.dart';

/// Displays a saved payment card in the teal card UI style.
/// Accepts a nullable [card]; shows a blank/placeholder layout when null.
class PaymentCardWidget extends StatelessWidget {
  final PaymentCardModel? card;
  final String primaryLabel;

  static const _primary = Color(0xFF2F7F8D);

  const PaymentCardWidget({
    super.key,
    this.card,
    required this.primaryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final brand = card?.cardBrand ?? 'Card';
    final last4 = card?.lastFourDigits ?? '••••';
    final expiry = card?.expiryDate ?? '——';
    final isPrimary = card?.isPrimary ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.credit_card_outlined,
                color: Colors.white,
                size: 28,
              ),
              if (isPrimary)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    primaryLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            brand,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '•••• •••• •••• $last4',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Expires $expiry',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
