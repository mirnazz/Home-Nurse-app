import 'package:flutter/material.dart';
import 'package:nurse_app/Core/widgets/payment_card_widget.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_billing_models.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

class PaymentMethodsScreen extends StatelessWidget {
  final List<PaymentCardModel> cards;

  static const _primary = Color(0xFF2F7F8D);
  static const _bg = Color(0xFFF6F7F9);

  const PaymentMethodsScreen({super.key, this.cards = const []});

  PaymentCardModel get _primaryCard {
    if (cards.isEmpty) {
      return const PaymentCardModel(
        cardBrand: 'Visa',
        lastFourDigits: '4242',
        expiryDate: '12/34',
        isPrimary: true,
      );
    }

    return cards.firstWhere((c) => c.isPrimary, orElse: () => cards.first);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.paymentMethodsTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          /// 💳 Card Section
          Text(
            l10n.paymentPrimaryLabel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          PaymentCardWidget(card: _primaryCard, primaryLabel: "Primary"),

          const SizedBox(height: 24),

          /// 🚫 Add Card (Disabled but clear)
          _DisabledAddCard(),

          const SizedBox(height: 28),

          /// 💡 Supported methods
          Text(
            l10n.paymentSupportedMethods,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C1C1C),
            ),
          ),
          const SizedBox(height: 14),

          _SupportedItem(
            icon: Icons.credit_card_outlined,
            title: l10n.paymentCreditDebitCards,
            subtitle: "Visa, MasterCard",
            isActive: true,
          ),
          const SizedBox(height: 10),

          _SupportedItem(
            icon: Icons.attach_money_rounded,
            title: l10n.paymentCashComingSoon,
            subtitle: "Pay at visit",
            isActive: false,
          ),
        ],
      ),
    );
  }
}

/// 🔥 Add card disabled (clean UX)
class _DisabledAddCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, color: Color(0xFF6B7280)),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Add new card",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Available in a future update",
                  style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),

          const Icon(Icons.lock, size: 16, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}

/// 💡 Supported method row
class _SupportedItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isActive;

  const _SupportedItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF1C1C1C) : const Color(0xFF9CA3AF);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w700, color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          if (!isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                "Coming soon",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
