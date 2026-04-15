import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_billing_models.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

/// Reusable transaction row used in both the Payments & Billing summary and
/// the Transaction History screen.
///
/// Set [showDate] to true to render the calendar-icon date row (history screen).
class PaymentTransactionItem extends StatelessWidget {
  final PaymentTransactionModel transaction;
  final bool showDate;

  const PaymentTransactionItem({
    super.key,
    required this.transaction,
    this.showDate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.personName ?? '—',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1C1C),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      transaction.serviceType ?? '—',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.amount != null
                        ? '${transaction.amount!.toStringAsFixed(0)} JOD'
                        : '— JOD',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F7F8D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _PaymentStatusBadge(status: transaction.status),
                ],
              ),
            ],
          ),
          if (showDate && transaction.date != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 6),
                Text(
                  DateFormat('yyyy-MM-dd').format(transaction.date!),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Status badge pill shown inside [PaymentTransactionItem].
class _PaymentStatusBadge extends StatelessWidget {
  final PaymentTransactionStatus? status;

  const _PaymentStatusBadge({this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final isCompleted = status == PaymentTransactionStatus.completed;

    final Color bg =
        isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);
    final Color fg =
        isCompleted ? const Color(0xFF16A34A) : const Color(0xFFD97706);
    final String label =
        isCompleted ? l10n.paymentStatusCompleted : l10n.paymentStatusPending;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
