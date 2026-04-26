import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

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
    final iconBg =
        isDark ? Colors.white.withValues(alpha: 0.15) : AppColors.primary.withValues(alpha: 0.10);
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

class EarningsListItem extends StatelessWidget {
  final String? serviceName;
  final String? patientName;
  final double? amount;
  final DateTime? date;
  final String status;

  const EarningsListItem({
    super.key,
    this.serviceName,
    this.patientName,
    this.amount,
    this.date,
    required this.status,
  });

  bool get _isCompleted =>
      status.toLowerCase() == 'paid' || status.toLowerCase() == 'completed';

  String _formatDate(DateTime? value) {
    if (value == null) return '—';
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final Color statusBg =
        _isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);
    final Color statusFg =
        _isCompleted ? const Color(0xFF16A34A) : const Color(0xFFD97706);
    final String statusLabel = _isCompleted ? 'Completed' : 'Pending';

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
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount != null ? '${amount!.toStringAsFixed(0)} JOD' : '— JOD',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

class NurseEarningsScreen extends StatefulWidget {
  const NurseEarningsScreen({super.key});

  @override
  State<NurseEarningsScreen> createState() => _NurseEarningsScreenState();
}

class _NurseEarningsScreenState extends State<NurseEarningsScreen> {
  int _selectedTab = 0;

  bool _isLoadingSummary = true;
  bool _isLoadingHistory = true;
  String? _errorMessage;

  double _totalEarnings = 0;
  double _monthlyEarnings = 0;
  double _pendingAmount = 0;

  List<EarningsListItem> _earningsList = [];

  String get _selectedBackendTab {
    if (_selectedTab == 1) return 'thisMonth';
    if (_selectedTab == 2) return 'history';
    return 'all';
  }

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _loadSummary(),
      _loadHistory(),
    ]);
  }

  Future<void> _loadSummary() async {
    setState(() {
      _isLoadingSummary = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getNursePaymentSummary();

      if (!mounted) return;

      setState(() {
        _totalEarnings = _toDouble(data['totalEarnings']);
        _monthlyEarnings =
            _toDouble(data['thisMonthEarnings'] ?? data['monthlyEarnings']);
        _pendingAmount = _toDouble(data['pendingAmount']);
        _isLoadingSummary = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoadingSummary = false;
      });
    }
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoadingHistory = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getNursePaymentHistory(
        tab: _selectedBackendTab,
      );

      final mapped = data.map<EarningsListItem>((item) {
        final map = item as Map<String, dynamic>;

        return EarningsListItem(
          serviceName: (map['serviceName'] ?? '—').toString(),
          patientName: (map['patientName'] ?? '—').toString(),
          amount: _toDouble(map['amount']),
          status: (map['status'] ?? 'Pending').toString(),
          date: DateTime.tryParse((map['createdAt'] ?? '').toString()),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        _earningsList = mapped;
        _isLoadingHistory = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _earningsList = [];
        _isLoadingHistory = false;
      });
    }
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  String _amountText(double value) => value.toStringAsFixed(0);

  int get _completedServicesCount =>
      _earningsList.where((e) => e.status.toLowerCase() == 'paid' || e.status.toLowerCase() == 'completed').length;

  int get _monthlyServicesCount =>
      _earningsList.length;

  Future<void> _onRefresh() async {
    await _loadAll();
  }

  void _onTabChanged(int index) {
    setState(() => _selectedTab = index);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final tabs = [
      l10n.nurseEarningsTabAll,
      l10n.nurseEarningsTabThisMonth,
      l10n.nurseEarningsTabHistory,
    ];

    final completedSubtitle =
        '$_completedServicesCount ${l10n.nurseEarningsCompletedServices}';
    final monthlySubtitle =
        '$_monthlyServicesCount ${l10n.nurseEarningsServicesThisMonth}';

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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          children: [
            EarningsSummaryCard(
              label: l10n.nurseEarningsTotalLabel,
              amount: _isLoadingSummary ? null : _amountText(_totalEarnings),
              subtitle: completedSubtitle,
              isDark: true,
              icon: Icons.attach_money_rounded,
            ),
            const SizedBox(height: 12),

            EarningsSummaryCard(
              label: l10n.nurseEarningsThisMonthLabel,
              amount: _isLoadingSummary ? null : _amountText(_monthlyEarnings),
              subtitle: monthlySubtitle,
              isDark: false,
              icon: Icons.trending_up_rounded,
            ),
            const SizedBox(height: 12),

            EarningsSummaryCard(
              label: l10n.nurseEarningsPendingLabel,
              amount: _isLoadingSummary ? null : _amountText(_pendingAmount),
              subtitle: l10n.nurseEarningsAwaitingPayment,
              isDark: false,
              icon: Icons.access_time_rounded,
            ),
            const SizedBox(height: 24),

            EarningsFilterTabs(
              selectedIndex: _selectedTab,
              labels: tabs,
              onTap: _onTabChanged,
            ),
            const SizedBox(height: 24),

            Text(
              l10n.nurseEarningsRecords,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1D2433),
              ),
            ),
            const SizedBox(height: 12),

            if (_errorMessage != null)
              _ErrorEarnings(
                message: _errorMessage!,
                onRetry: _onRefresh,
              )
            else if (_isLoadingHistory)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 36),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_earningsList.isEmpty)
              _EmptyEarnings(l10n: l10n)
            else
              ..._earningsList,
          ],
        ),
      ),
    );
  }
}

class _ErrorEarnings extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorEarnings({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

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
            child: const Icon(
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
