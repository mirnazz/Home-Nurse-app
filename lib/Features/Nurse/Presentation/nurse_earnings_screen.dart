import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

// ── Reusable widgets ──────────────────────────────────────────────────────────

/// Large teal summary card — Total Earnings.
class EarningsSummaryCard extends StatelessWidget {
  final String label;
  final String? amount;
  final String subtitle;
  final bool isDark;
  final IconData icon;

  const EarningsSummaryCard({
    super.key,
    required this.label,
    required this.subtitle,
    required this.isDark,
    required this.icon,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.primary : Colors.white;
    final fg = isDark ? Colors.white : const Color(0xFF1D2433);
    final subFg =
        isDark ? Colors.white.withValues(alpha: 0.75) : const Color(0xFF6B7280);
    final iconBg = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : AppColors.primary.withValues(alpha: 0.10);
    final iconFg = isDark ? Colors.white : AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.30)
                : const Color(0x0D000000),
            blurRadius: isDark ? 20 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: subFg,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  amount != null ? '$amount JOD' : '— JOD',
                  style: TextStyle(
                    fontSize: isDark ? 28 : 22,
                    fontWeight: FontWeight.w900,
                    color: fg,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subFg,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconFg, size: isDark ? 28 : 24),
          ),
        ],
      ),
    );
  }
}

/// Segmented filter tab row.
class EarningsFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onTap;

  const EarningsFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.labels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Single row in the earnings records list.
class EarningsListItem extends StatelessWidget {
  final String? serviceName;
  final String? patientName;
  final double? amount;
  final DateTime? date;
  final bool isCompleted;

  const EarningsListItem({
    super.key,
    this.serviceName,
    this.patientName,
    this.amount,
    this.date,
    this.isCompleted = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusBg = isCompleted
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFEF3C7);
    final Color statusFg = isCompleted
        ? const Color(0xFF16A34A)
        : const Color(0xFFD97706);
    final String statusLabel = isCompleted ? 'Completed' : 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName ?? '—',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D2433),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  patientName ?? '—',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount != null
                    ? '${amount!.toStringAsFixed(0)} JOD'
                    : '— JOD',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusFg,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Main Screen ───────────────────────────────────────────────────────────────

class NurseEarningsScreen extends StatefulWidget {
  final double? totalEarnings;
  final double? monthlyEarnings;
  final double? pendingAmount;
  final int? completedServicesCount;
  final int? monthlyServicesCount;
  final List<EarningsListItem> earningsList;

  const NurseEarningsScreen({
    super.key,
    this.totalEarnings,
    this.monthlyEarnings,
    this.pendingAmount,
    this.completedServicesCount,
    this.monthlyServicesCount,
    this.earningsList = const [],
  });

  @override
  State<NurseEarningsScreen> createState() => _NurseEarningsScreenState();
}

class _NurseEarningsScreenState extends State<NurseEarningsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final tabs = [
      l10n.nurseEarningsTabAll,
      l10n.nurseEarningsTabThisMonth,
      l10n.nurseEarningsTabHistory,
    ];

    final completedSubtitle =
        '${widget.completedServicesCount ?? 0} ${l10n.nurseEarningsCompletedServices}';
    final monthlySubtitle =
        '${widget.monthlyServicesCount ?? 0} ${l10n.nurseEarningsServicesThisMonth}';

    final totalStr = widget.totalEarnings != null
        ? widget.totalEarnings!.toStringAsFixed(0)
        : null;
    final monthlyStr = widget.monthlyEarnings != null
        ? widget.monthlyEarnings!.toStringAsFixed(0)
        : null;
    final pendingStr = widget.pendingAmount != null
        ? widget.pendingAmount!.toStringAsFixed(0)
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.nurseProfileEarningsTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              l10n.nurseEarningsSubtitle,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        leadingWidth: 48,
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          // ── Total Earnings (dark teal) ─────────────────────────────────
          EarningsSummaryCard(
            label: l10n.nurseEarningsTotalLabel,
            amount: totalStr,
            subtitle: completedSubtitle,
            isDark: true,
            icon: Icons.attach_money_rounded,
          ),
          const SizedBox(height: 12),

          // ── Earnings This Month ────────────────────────────────────────
          EarningsSummaryCard(
            label: l10n.nurseEarningsThisMonthLabel,
            amount: monthlyStr,
            subtitle: monthlySubtitle,
            isDark: false,
            icon: Icons.trending_up_rounded,
          ),
          const SizedBox(height: 12),

          // ── Pending Amount ─────────────────────────────────────────────
          EarningsSummaryCard(
            label: l10n.nurseEarningsPendingLabel,
            amount: pendingStr,
            subtitle: l10n.nurseEarningsAwaitingPayment,
            isDark: false,
            icon: Icons.access_time_rounded,
          ),
          const SizedBox(height: 24),

          // ── Filter tabs ────────────────────────────────────────────────
          EarningsFilterTabs(
            selectedIndex: _selectedTab,
            labels: tabs,
            onTap: (i) => setState(() => _selectedTab = i),
          ),
          const SizedBox(height: 24),

          // ── Earnings Records header ────────────────────────────────────
          Text(
            l10n.nurseEarningsRecords,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D2433),
            ),
          ),
          const SizedBox(height: 12),

          // ── Records list / empty state ─────────────────────────────────
          if (widget.earningsList.isEmpty)
            _EmptyEarnings(l10n: l10n)
          else
            ...widget.earningsList,
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyEarnings extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyEarnings({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.nurseEarningsEmpty,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
