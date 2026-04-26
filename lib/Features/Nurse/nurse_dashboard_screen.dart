import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Core/widgets/language_selector_sheet.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_appointments_screen.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_requests_screen.dart';
import 'package:nurse_app/Features/Shared/Presentation/notifications_screen.dart';
import 'nurse_availability_screen.dart';
import 'nurse_profile_screen.dart';
import 'nurse_services_screen.dart';

typedef NurseDashboardNavigate = void Function(int tabIndex);

class NurseDashboardScreen extends StatefulWidget {
  const NurseDashboardScreen({super.key});

  @override
  State<NurseDashboardScreen> createState() => _NurseDashboardScreenState();
}

class _NurseDashboardScreenState extends State<NurseDashboardScreen> {
  int currentTab = 0;
  String nurseName = "";
  bool isLoading = true;

  int pendingRequestsCount = 0;
  List<Appointment> todayAppointments = const [];
  double todayEarnings = 0;
  bool _hasUnreadNotifications = false;

  Future<void> _navigate(int tabIndex) async {
    setState(() => currentTab = tabIndex);
    if (tabIndex == 0) {
      await loadDashboardData();
    }
  }

  void _openNotifications() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const NotificationsScreen(
          audience: NotificationAudience.nurse,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
    _loadUnreadNotifications();
  }

  Future<void> _loadUnreadNotifications() async {
    try {
      final notifications = await ApiService.getNotifications();
      if (!mounted) return;
      setState(() {
        _hasUnreadNotifications = notifications.any((n) => !n.isRead);
      });
    } catch (_) {}
  }

  Future<void> loadInitialData() async {
    setState(() => isLoading = true);
    await Future.wait([loadNurse(), loadDashboardData()]);
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> loadDashboardData() async {
    await Future.wait([loadPendingRequestsCount(), loadTodayAppointments()]);
  }

  Future<void> loadNurse() async {
    try {
      final data = await ApiService.getAccount();
      if (!mounted) return;
      setState(() => nurseName = data["fullName"] ?? '');
    } catch (_) {
      if (!mounted) return;
      setState(() => nurseName = '');
    }
  }

  Future<void> loadPendingRequestsCount() async {
    try {
      final data = await ApiService.getNurseRequests(status: 'Pending');
      if (!mounted) return;
      setState(() => pendingRequestsCount = data.length);
    } catch (_) {
      if (!mounted) return;
      setState(() => pendingRequestsCount = 0);
    }
  }

  Future<void> loadTodayAppointments() async {
    try {
      final appointments = await ApiService.getNurseAppointments(tab: 'today');
      final total = appointments.fold<double>(0, (sum, item) => sum + item.price);
      if (!mounted) return;
      setState(() {
        todayAppointments = appointments;
        todayEarnings = total;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        todayAppointments = const [];
        todayEarnings = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : IndexedStack(
                index: currentTab,
                children: [
                  NurseHomeScreen(
                    nurseName: nurseName,
                    onNavigate: (tabIndex) => _navigate(tabIndex),
                    onOpenNotifications: _openNotifications,
                    pendingCount: pendingRequestsCount,
                    todayAppointments: todayAppointments,
                    todayEarnings: todayEarnings,
                    onRefreshDashboard: loadDashboardData,
                    hasUnreadNotifications: _hasUnreadNotifications,
                  ),
                  const NurseAvailabilityScreen(),
                  const NurseAppointmentsScreen(),
                  const NurseRequestsScreen(),
                  const NurseProfileScreen(),
                ],
              ),
      ),
      bottomNavigationBar: _NurseBottomNav(
        currentIndex: currentTab,
        pendingCount: pendingRequestsCount,
        onChanged: (i) => _navigate(i),
        l10n: AppLocalizations.of(context)!,
      ),
    );
  }
}

class NurseHomeScreen extends StatelessWidget {
  final String nurseName;
  final NurseDashboardNavigate onNavigate;
  final VoidCallback onOpenNotifications;
  final int pendingCount;
  final List<Appointment> todayAppointments;
  final double todayEarnings;
  final Future<void> Function() onRefreshDashboard;
  final bool hasUnreadNotifications;

  const NurseHomeScreen({
    super.key,
    required this.nurseName,
    required this.onNavigate,
    required this.onOpenNotifications,
    required this.pendingCount,
    required this.todayAppointments,
    required this.todayEarnings,
    required this.onRefreshDashboard,
    required this.hasUnreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: onRefreshDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NurseHeader(
              name: nurseName,
              onNotificationsTap: onOpenNotifications,
              hasUnread: hasUnreadNotifications,
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryCardsRow(
                    l10n: l10n,
                    pendingCount: pendingCount,
                    todayAppointmentsCount: todayAppointments.length,
                    todayEarnings: todayEarnings,
                  ),
                  const SizedBox(height: 32),
                  _QuickActionsTitle(l10n: l10n),
                  const SizedBox(height: 12),
                  _QuickActionsList(
                    l10n: l10n,
                    onNavigate: onNavigate,
                    pendingCount: pendingCount,
                  ),
                  const SizedBox(height: 24),
                  _TodayScheduleSection(
                    l10n: l10n,
                    appointments: todayAppointments,
                    onViewAll: () => onNavigate(2),
                  ),
                  const SizedBox(height: 24),
                  _AvailabilityCard(onOpenAvailability: () => onNavigate(1)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NurseHeader extends StatelessWidget {
  final String name;
  final VoidCallback onNotificationsTap;
  final bool hasUnread;

  const _NurseHeader({
    required this.name,
    required this.onNotificationsTap,
    required this.hasUnread,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final localeTag = Localizations.localeOf(context).toString();
    final dateStr = DateFormat.yMMMEd(localeTag).format(now);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.nurseHomeWelcomeBack,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name.isEmpty ? l10n.nurseHomeDefaultName : name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: l10n.patientMoreLanguage,
                child: IconButton(
                  onPressed: () => showLanguageSelectorSheet(context),
                  icon: Icon(
                    Icons.language_outlined,
                    color: Colors.white.withValues(alpha: 0.95),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onNotificationsTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Center(
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        if (hasUnread)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF4D4D),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
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

class _SummaryCardsRow extends StatelessWidget {
  final AppLocalizations l10n;
  final int pendingCount;
  final int todayAppointmentsCount;
  final double todayEarnings;

  const _SummaryCardsRow({
    required this.l10n,
    required this.pendingCount,
    required this.todayAppointmentsCount,
    required this.todayEarnings,
  });

  String _formatMoney(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.calendar_today_outlined,
            value: todayAppointmentsCount.toString(),
            label: l10n.nurseHomeSummaryTodayAppointments,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.access_time_outlined,
            value: pendingCount.toString(),
            label: l10n.nurseHomeSummaryPendingRequests,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.attach_money,
            value: _formatMoney(todayEarnings),
            label: l10n.nurseHomeSummaryJodToday,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D2433),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsTitle extends StatelessWidget {
  const _QuickActionsTitle({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Text(
      l10n.nurseHomeQuickActionsTitle,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1D2433),
      ),
    );
  }
}

class _QuickActionsList extends StatelessWidget {
  final AppLocalizations l10n;
  final NurseDashboardNavigate onNavigate;
  final int pendingCount;

  const _QuickActionsList({
    required this.l10n,
    required this.onNavigate,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuickActionTile(
          onTap: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const NurseServicesScreen(),
              ),
            );
          },
          icon: Icons.medical_services_outlined,
          title: l10n.nurseProfileMyServicesTitle,
          subtitle: l10n.nurseProfileMyServicesSubtitle,
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        _QuickActionTile(
          onTap: () => onNavigate(1),
          icon: Icons.calendar_month_outlined,
          title: l10n.nurseHomeActionManageAvailabilityTitle,
          subtitle: l10n.nurseHomeActionManageAvailabilitySubtitle,
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        _QuickActionTile(
          onTap: () => onNavigate(3),
          icon: Icons.description_outlined,
          title: l10n.nurseHomeActionViewRequestsTitle,
          subtitle: l10n.nurseHomeActionViewRequestsSubtitle,
          trailing: pendingCount > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8A00),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    pendingCount > 99 ? '99+' : pendingCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                )
              : const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        _QuickActionTile(
          onTap: () => onNavigate(2),
          icon: Icons.calendar_today_outlined,
          title: l10n.nurseHomeActionAppointmentsTitle,
          subtitle: l10n.nurseHomeActionAppointmentsSubtitle,
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _QuickActionTile({
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF1D2433))),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayScheduleSection extends StatelessWidget {
  final AppLocalizations l10n;
  final List<Appointment> appointments;
  final VoidCallback onViewAll;

  const _TodayScheduleSection({
    required this.l10n,
    required this.appointments,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.nurseHomeTodayScheduleTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1D2433))),
            TextButton(
              onPressed: onViewAll,
              child: Text(l10n.nurseHomeViewAll, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (appointments.isEmpty)
          _EmptyTodayScheduleCard(l10n: l10n)
        else
          ...appointments.take(3).map(
                (appointment) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ScheduleAppointmentCard(
                    patientName: appointment.patientName.isEmpty ? l10n.nurseHomePatientFallback : appointment.patientName,
                    service: appointment.serviceName,
                    status: _statusLabel(l10n, appointment),
                    statusColor: _statusColor(appointment),
                    statusBg: _statusBackground(appointment),
                    time: DateFormat.jm(localeTag).format(appointment.dateTime),
                    earningsDisplay: l10n.nurseHomeEarningsJod(_formatMoney(appointment.price)),
                  ),
                ),
              ),
      ],
    );
  }

  static String _formatMoney(double value) =>
      value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);

  static String _statusLabel(AppLocalizations l10n, Appointment appointment) {
    switch (appointment.status.name) {
      case 'confirmed': return l10n.nurseStatusAccepted;
      case 'paid': return l10n.nurseStatusActive;
      case 'completed': return l10n.nurseStatusCompleted;
      case 'cancelled': return l10n.nurseStatusCancelled;
      case 'rejected': return l10n.nurseStatusRejected;
      default: return l10n.nurseStatusPending;
    }
  }

  static Color _statusColor(Appointment appointment) {
    switch (appointment.status.name) {
      case 'confirmed': return const Color(0xFF22C55E);
      case 'paid': return const Color(0xFF0EA5E9);
      case 'completed': return const Color(0xFF16A34A);
      case 'cancelled':
      case 'rejected': return const Color(0xFFDC2626);
      default: return const Color(0xFFF59E0B);
    }
  }

  static Color _statusBackground(Appointment appointment) {
    switch (appointment.status.name) {
      case 'confirmed': return const Color(0xFFEAFBF0);
      case 'paid': return const Color(0xFFE0F2FE);
      case 'completed': return const Color(0xFFDCFCE7);
      case 'cancelled':
      case 'rejected': return const Color(0xFFFEE2E2);
      default: return const Color(0xFFFEF3C7);
    }
  }
}

class _ScheduleAppointmentCard extends StatelessWidget {
  final String patientName;
  final String service;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String time;
  final String earningsDisplay;

  const _ScheduleAppointmentCard({
    required this.patientName,
    required this.service,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.time,
    required this.earningsDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF2)),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(patientName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF1D2433))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(999)),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 11.5)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(service, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF6B7280))),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(time, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF6B7280))),
              const SizedBox(width: 16),
              const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(earningsDisplay, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyTodayScheduleCard extends StatelessWidget {
  const _EmptyTodayScheduleCard({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_busy_outlined, color: Color(0xFF9CA3AF), size: 32),
          const SizedBox(height: 10),
          Text(l10n.nurseHomeNoAppointmentsToday, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF374151))),
          const SizedBox(height: 4),
          Text(l10n.nurseHomeNoAppointmentsTodayHint, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  final VoidCallback onOpenAvailability;
  const _AvailabilityCard({required this.onOpenAvailability});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onOpenAvailability,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFA5D6A7)),
          ),
          child: Row(
            children: [
              Container(
                height: 12,
                width: 12,
                decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.nurseHomeAvailableTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF2E7D32))),
                    const SizedBox(height: 4),
                    Text(l10n.nurseHomeAvailableSubtitle, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32).withOpacity(0.85))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NurseBottomNav extends StatelessWidget {
  final int currentIndex;
  final int pendingCount;
  final ValueChanged<int> onChanged;
  final AppLocalizations l10n;

  const _NurseBottomNav({
    required this.currentIndex,
    required this.pendingCount,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, -8))],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onChanged,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF9CA3AF),
        selectedFontSize: 11,
        unselectedFontSize: 10,
        iconSize: 24,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.nurseNavHome),
          BottomNavigationBarItem(icon: const Icon(Icons.calendar_today), label: l10n.nurseNavAvailability),
          BottomNavigationBarItem(icon: const Icon(Icons.event_available_outlined), label: l10n.nurseNavAppointments),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications),
                if (pendingCount > 0)
                  Positioned(
                    right: -4,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Color(0xFFFF4D4D), shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      alignment: Alignment.center,
                      child: Text(
                        pendingCount > 99 ? '99+' : pendingCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
              ],
            ),
            label: l10n.nurseNavRequests,
          ),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: l10n.nurseNavProfile),
        ],
      ),
    );
  }
}
