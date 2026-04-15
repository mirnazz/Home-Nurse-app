import 'package:flutter/material.dart';
import 'package:nurse_app/Core/widgets/payment_transaction_item.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_billing_models.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

/// Transaction History screen — pushed from the Payments & Billing screen.
///
/// Data wiring: pass [transactions] from a repository/controller.
/// The list is empty by default so the screen renders a clean empty state.
class PaymentTransactionHistoryScreen extends StatelessWidget {
  final List<PaymentTransactionModel> transactions;

  static const _primary = Color(0xFF2F7F8D);
  static const _bg = Color(0xFFF6F7F9);

  const PaymentTransactionHistoryScreen({
    super.key,
    this.transactions = const [],
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
          l10n.paymentTransactionHistoryTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: transactions.isEmpty
          ? _EmptyHistory()
          : ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: transactions.length,
              itemBuilder: (context, index) => PaymentTransactionItem(
                transaction: transactions[index],
                showDate: true,
              ),
            ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4F6),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 40,
                color: Color(0xFF2F7F8D),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.paymentNoTransactions,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
