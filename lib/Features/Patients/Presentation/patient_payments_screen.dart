import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/widgets/payment_summary_card.dart';
import 'package:nurse_app/Core/widgets/payment_transaction_item.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_billing_models.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_methods_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/payment_transaction_history_screen.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

class PatientPaymentsScreen extends StatefulWidget {
  const PatientPaymentsScreen({super.key});

  @override
  State<PatientPaymentsScreen> createState() => _PatientPaymentsScreenState();
}

class _PatientPaymentsScreenState extends State<PatientPaymentsScreen> {
  static const _primary = Color(0xFF2F7F8D);
  static const _bg = Color(0xFFF6F7F9);

  bool _isLoading = true;
  String? _errorMessage;

  PaymentSummaryModel? _summary;
  List<PaymentTransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getPatientPaymentHistory();

      final transactions =
          data.map<PaymentTransactionModel>((item) {
            final map = item as Map<String, dynamic>;

            final amount = ((map['amount'] ?? 0) as num).toDouble();
            final statusText = (map['status'] ?? '').toString().toLowerCase();

            return PaymentTransactionModel(
              id: (map['paymentId'] ?? '').toString(),
              personName: (map['nurseName'] ?? '—').toString(),
              serviceType: (map['serviceName'] ?? '—').toString(),
              amount: amount,
              date: DateTime.tryParse((map['createdAt'] ?? '').toString()),
              status:
                  statusText == 'paid'
                      ? PaymentTransactionStatus.completed
                      : PaymentTransactionStatus.pending,
            );
          }).toList();

      double totalSpent = 0;
      double pendingAmount = 0;

      for (final t in transactions) {
        final amount = t.amount ?? 0;
        if (t.status == PaymentTransactionStatus.completed) {
          totalSpent += amount;
        } else {
          pendingAmount += amount;
        }
      }

      if (!mounted) return;

      setState(() {
        _transactions = transactions;
        _summary = PaymentSummaryModel(
          totalSpent: totalSpent,
          pendingAmount: pendingAmount,
        );
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
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
          l10n.paymentBillingTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? _ErrorState(message: _errorMessage!, onRetry: _loadPayments)
              : RefreshIndicator(
                onRefresh: _loadPayments,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  children: [
                    _SummaryRow(summary: _summary),
                    const SizedBox(height: 20),

                    _NavCard(
                      icon: Icons.receipt_long_outlined,
                      title: l10n.paymentTransactionHistoryTitle,
                      subtitle: l10n.paymentTransactionHistorySubtitle,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => PaymentTransactionHistoryScreen(
                                  transactions: _transactions,
                                ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    _NavCard(
                      icon: Icons.credit_card_outlined,
                      title: l10n.paymentMethodsTitle,
                      subtitle: l10n.paymentMethodsSubtitle,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => PaymentMethodsScreen(
                                  cards: const [
                                    PaymentCardModel(
                                      cardBrand: 'Visa',
                                      lastFourDigits: '4242',
                                      expiryDate: '12/34',
                                      isPrimary: true,
                                    ),
                                  ],
                                ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    _RecentTransactionsHeader(
                      onViewAll: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => PaymentTransactionHistoryScreen(
                                  transactions: _transactions,
                                ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    if (_transactions.isEmpty)
                      const _EmptyTransactions()
                    else
                      ..._transactions
                          .take(3)
                          .map((t) => PaymentTransactionItem(transaction: t)),
                  ],
                ),
              ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final PaymentSummaryModel? summary;

  const _SummaryRow({this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final totalLabel =
        summary?.totalSpent != null
            ? '${summary!.totalSpent!.toStringAsFixed(0)} JOD'
            : null;

    final pendingLabel =
        summary?.pendingAmount != null
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

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 46,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
