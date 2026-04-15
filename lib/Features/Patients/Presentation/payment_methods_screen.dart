import 'package:flutter/material.dart';
import 'package:nurse_app/Core/widgets/payment_card_widget.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_billing_models.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

/// Payment Methods screen — pushed from the Payments & Billing screen.
///
/// Data wiring: pass [cards] from a repository/controller.
/// [primaryCard] is derived as the first card with isPrimary == true (or the
/// first card in the list). All fields are nullable for graceful empty states.
class PaymentMethodsScreen extends StatelessWidget {
  final List<PaymentCardModel> cards;

  /// Called when the user taps "Add New Payment Method". Wire up to your
  /// add-card flow when the backend is ready.
  final VoidCallback? onAddCard;

  static const _primary = Color(0xFF2F7F8D);
  static const _bg = Color(0xFFF6F7F9);

  const PaymentMethodsScreen({
    super.key,
    this.cards = const [],
    this.onAddCard,
  });

  PaymentCardModel? get _primaryCard {
    if (cards.isEmpty) return null;
    return cards.firstWhere(
      (c) => c.isPrimary,
      orElse: () => cards.first,
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // ── Primary card ─────────────────────────────────────────────────
          PaymentCardWidget(
            card: _primaryCard,
            primaryLabel: l10n.paymentPrimaryLabel,
          ),
          const SizedBox(height: 20),

          // ── Add new method button ─────────────────────────────────────────
          _AddNewMethodButton(onTap: onAddCard),
          const SizedBox(height: 28),

          // ── Supported payment methods ─────────────────────────────────────
          Text(
            l10n.paymentSupportedMethods,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C1C1C),
            ),
          ),
          const SizedBox(height: 14),
          _SupportedMethodItem(
            icon: Icons.credit_card_outlined,
            label: l10n.paymentCreditDebitCards,
            isComingSoon: false,
          ),
          const SizedBox(height: 10),
          _SupportedMethodItem(
            icon: Icons.attach_money_rounded,
            label: l10n.paymentCashComingSoon,
            isComingSoon: true,
          ),
        ],
      ),
    );
  }
}

// ── Add New Method button ─────────────────────────────────────────────────────

class _AddNewMethodButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddNewMethodButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2F7F8D),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.credit_card_outlined,
              color: Color(0xFF2F7F8D),
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.paymentAddNewMethod,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F7F8D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Supported method row ──────────────────────────────────────────────────────

class _SupportedMethodItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isComingSoon;

  const _SupportedMethodItem({
    required this.icon,
    required this.label,
    required this.isComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        isComingSoon ? const Color(0xFF9CA3AF) : const Color(0xFF1C1C1C);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 14),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
