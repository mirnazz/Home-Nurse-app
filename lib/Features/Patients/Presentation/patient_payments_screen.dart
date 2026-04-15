import 'package:flutter/material.dart';
import 'package:nurse_app/Core/widgets/payment_summary_card.dart';
import 'package:nurse_app/Core/widgets/payment_transaction_item.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_billing_models.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_transaction_history_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_methods_screen.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

/// Payments & Billing tab — root screen shown in the patient bottom nav (index 3).
///
/// Data wiring: inject [summary], [recentTransactions], and [primaryCard] from
/// a repository/controller when the backend is ready. All fields are nullable so
/// the screen gracefully renders an empty/loading state out of the box.
class PatientPaymentsScreen extends StatelessWidget {
  final PaymentSummaryModel? summary;
  final List<PaymentTransactionModel> recentTransactions;
  final PaymentCardModel? primaryCard;

  static const _primary = Color(0xFF2F7F8D);
  static const _bg = Color(0xFFF6F7F9);

  const PatientPaymentsScreen({
    super.key,
    this.summary,
    this.recentTransactions = const [],
    this.primaryCard,
  });

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
          l10n.paymentBillingTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // ── Summary cards ──────────────────────────────────────────────────
          _SummaryRow(summary: summary),
          const SizedBox(height: 20),

          // ── Navigation cards ───────────────────────────────────────────────
          _NavCard(
            icon: Icons.receipt_long_outlined,
            title: l10n.paymentTransactionHistoryTitle,
            subtitle: l10n.paymentTransactionHistorySubtitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PaymentTransactionHistoryScreen(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _NavCard(
            icon: Icons.credit_card_outlined,
            title: l10n.paymentMethodsTitle,
            subtitle: l10n.paymentMethodsSubtitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PaymentMethodsScreen(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Recent transactions ────────────────────────────────────────────
          _RecentTransactionsHeader(
            onViewAll: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PaymentTransactionHistoryScreen(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (recentTransactions.isEmpty)
            _EmptyTransactions()
          else
            ...recentTransactions.map(
              (t) => PaymentTransactionItem(transaction: t),
            ),
        ],
      ),
    );
  }
}

// ── Summary row ──────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final PaymentSummaryModel? summary;

  const _SummaryRow({this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final totalLabel = summary?.totalSpent != null
        ? '${summary!.totalSpent!.toStringAsFixed(0)} JOD'
        : null;
    final pendingLabel = summary?.pendingAmount != null
        ? '${summary!.pendingAmount!.toStringAsFixed(0)} JOD'
        : null;

    return Row(
      children: [
        Expanded(
          child: PaymentSummaryCard(
            icon: Icons.attach_money_rounded,
            label: l10n.paymentTotalSpent,
            amount: totalLabel,
            isDark: true,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: PaymentSummaryCard(
            icon: Icons.access_time_rounded,
            label: l10n.paymentPendingLabel,
            amount: pendingLabel,
            isDark: false,
          ),
        ),
      ],
    );
  }
}

// ── Navigation card ───────────────────────────────────────────────────────────

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF2F7F8D), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C1C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Recent transactions section header ────────────────────────────────────────

class _RecentTransactionsHeader extends StatelessWidget {
  final VoidCallback onViewAll;

  const _RecentTransactionsHeader({required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.paymentRecentTransactions,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1C1C1C),
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l10n.paymentViewAll,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2F7F8D),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Text(
        l10n.paymentNoTransactions,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}
