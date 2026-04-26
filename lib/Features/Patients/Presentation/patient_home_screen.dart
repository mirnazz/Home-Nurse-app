import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/api/token_storage.dart';
import 'package:nurse_app/Features/Patients/Presentation/browse_nurses_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_bottom_nav_bar.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_appointments_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_review_dialog.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_review_models.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_more_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_payments_screen.dart';
import 'package:nurse_app/Features/Shared/Presentation/notifications_screen.dart';
import 'package:nurse_app/Core/widgets/language_selector_sheet.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/widgets/appointment_list_card.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_appointment_details_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  final List<PatientPendingReviewItem> pendingReviewRequests;
  final Future<List<PatientPendingReviewItem>> Function()?
  onFetchPendingReviewRequests;
  final Future<void> Function(PatientRatingSubmissionDraft draft)?
  onSubmitReview;

  const PatientHomeScreen({
    super.key,
    this.pendingReviewRequests = const [],
    this.onFetchPendingReviewRequests,
    this.onSubmitReview,
  });

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int currentTab = 0;
  String _userName = 'User';

  String? _browseSearch;
  int? _browseServiceId;
  String? _browseLocation;

  bool _isLoadingPendingReviews = false;
  late List<PatientPendingReviewItem> _pendingReviewRequests;

  final Set<String> _reviewDeferredForSession = {};
  bool _blockingReviewFlowActive = false;

  int _totalBookings = 0;
  int _activeRequests = 0;
  bool _isLoadingDashboardSummary = false;

  bool _hasUnreadNotifications = false;

  @override
  void initState() {
    super.initState();
    _pendingReviewRequests =
        widget.pendingReviewRequests.isNotEmpty
            ? List<PatientPendingReviewItem>.from(widget.pendingReviewRequests)
            : <PatientPendingReviewItem>[];

    _loadUserData();
    _loadDashboardSummary();
    _fetchPendingReviews();
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

  Future<void> _loadUserData() async {
    try {
      final me = await ApiService.getMe();

      if (!mounted) return;

      setState(() {
        _userName = (me['fullName'] ?? me['userName'] ?? '').toString();
      });
    } catch (e) {
      await TokenStorage.clearToken();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  Future<void> _loadDashboardSummary() async {
    setState(() => _isLoadingDashboardSummary = true);
    try {
      final summary = await ApiService.getPatientDashboardSummary();

      if (!mounted) return;

      setState(() {
        _totalBookings = _toInt(summary['totalBookings']);
        _activeRequests = _toInt(summary['activeRequests']);
      });
    } catch (e) {
      debugPrint('Error loading dashboard summary: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingDashboardSummary = false);
      }
    }
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> _fetchPendingReviews() async {
    setState(() => _isLoadingPendingReviews = true);

    try {
      final fetcher = widget.onFetchPendingReviewRequests;

      if (fetcher != null) {
        final requests = await fetcher();

        if (!mounted) return;
        setState(() {
          _pendingReviewRequests = requests;
        });
      } else {
        final pending = await ApiService.getPendingReview();

        if (!mounted) return;
        setState(() {
          _pendingReviewRequests =
              pending == null ? [] : <PatientPendingReviewItem>[pending];
        });
      }
    } catch (e) {
      debugPrint('Error loading pending review: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingPendingReviews = false);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scheduleBlockingReviewPrompt();
      });
    }
  }

  void _scheduleBlockingReviewPrompt() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tryShowBlockingReview();
    });
  }

  Future<void> _tryShowBlockingReview() async {
    if (!mounted || _blockingReviewFlowActive || _isLoadingPendingReviews) {
      return;
    }

    PatientPendingReviewItem? target;
    for (final r in _pendingReviewRequests) {
      if (!_reviewDeferredForSession.contains(r.requestId)) {
        target = r;
        break;
      }
    }
    if (target == null) return;

    _blockingReviewFlowActive = true;
    try {
      await _openReviewModal(target);
    } finally {
      if (mounted) {
        _blockingReviewFlowActive = false;
      }
    }

    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tryShowBlockingReview();
    });
  }

  Future<void> _openReviewModal(PatientPendingReviewItem request) async {
    final result = await showPatientReviewModal(context, request: request);

    if (!mounted || result == null) return;

    switch (result.action) {
      case PatientReviewModalAction.later:
        try {
          await ApiService.remindReviewLater(bookingId: request.bookingId);

          if (!mounted) return;
          setState(() {
            _reviewDeferredForSession.add(request.requestId);
          });
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
            ),
          );
        }
        return;

      case PatientReviewModalAction.dismissedForever:
        try {
          await ApiService.dismissReviewPrompt(bookingId: request.bookingId);

          if (!mounted) return;
          setState(() {
            _pendingReviewRequests.removeWhere(
              (item) => item.requestId == request.requestId,
            );
          });
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
            ),
          );
        }
        return;

      case PatientReviewModalAction.submitted:
        final draft = result.draft;
        if (draft == null) return;

        try {
          final submitter = widget.onSubmitReview;
          if (submitter != null) {
            await submitter(draft);
          } else {
            await ApiService.submitReview(draft: draft);
          }

          if (!mounted) return;

          setState(() {
            _pendingReviewRequests.removeWhere(
              (item) => item.requestId == request.requestId,
            );
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.patientReviewSubmittedThanks,
              ),
            ),
          );
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
            ),
          );
        }
    }
  }

  void _openNotifications() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder:
            (_) => const NotificationsScreen(
              audience: NotificationAudience.patient,
            ),
      ),
    );
  }

  void _openBrowseDefault() {
    setState(() {
      _browseSearch = null;
      _browseServiceId = null;
      _browseLocation = null;
      currentTab = 1;
    });
  }

  void _openBrowseWithService(int serviceCatalogId) {
    setState(() {
      _browseSearch = null;
      _browseServiceId = serviceCatalogId;
      _browseLocation = null;
      currentTab = 1;
    });
  }

  void _openAppointmentsUpcoming() {
    setState(() {
      currentTab = 2;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      currentTab = index;

      if (index == 1) {
        _browseSearch = null;
        _browseServiceId = null;
        _browseLocation = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7F9);
    final pages = [
      PatientHomeContent(
        name: _userName,
        onOpenNotifications: _openNotifications,
        onSearchTap: _openBrowseDefault,
        onQuickServiceTap: _openBrowseWithService,
        onUpcomingViewAllTap: _openAppointmentsUpcoming,
        isLoadingPendingReviews: _isLoadingPendingReviews,
        pendingReviewRequests: _pendingReviewRequests,
        onWriteReview: _openReviewModal,
        totalBookings: _totalBookings,
        activeRequests: _activeRequests,
        isLoadingDashboardSummary: _isLoadingDashboardSummary,
        hasUnreadNotifications: _hasUnreadNotifications,
      ),
      BrowseNursesScreen(
        key: ValueKey(
          'browse-${_browseSearch ?? ''}-${_browseServiceId ?? 'all'}-${_browseLocation ?? 'all'}',
        ),
        initialSearch: _browseSearch,
        initialServiceCatalogId: _browseServiceId,
        initialLocation: _browseLocation,
      ),
      const PatientAppointmentsScreen(),
      const PatientPaymentsScreen(),
      const PatientMoreScreen(),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: IndexedStack(index: currentTab, children: pages),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: currentTab,
        onTap: _onBottomNavTap,
      ),
    );
  }
}

class PatientHomeContent extends StatelessWidget {
  final String name;
  final VoidCallback onOpenNotifications;
  final VoidCallback onSearchTap;
  final ValueChanged<int> onQuickServiceTap;
  final VoidCallback onUpcomingViewAllTap;
  final bool isLoadingPendingReviews;
  final List<PatientPendingReviewItem> pendingReviewRequests;
  final ValueChanged<PatientPendingReviewItem> onWriteReview;
  final int totalBookings;
  final int activeRequests;
  final bool isLoadingDashboardSummary;
  final bool hasUnreadNotifications;

  const PatientHomeContent({
    super.key,
    required this.name,
    required this.onOpenNotifications,
    required this.onSearchTap,
    required this.onQuickServiceTap,
    required this.onUpcomingViewAllTap,
    required this.isLoadingPendingReviews,
    required this.pendingReviewRequests,
    required this.onWriteReview,
    required this.totalBookings,
    required this.activeRequests,
    required this.isLoadingDashboardSummary,
    required this.hasUnreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _HomeHeader(
              name: name,
              onNotificationTap: onOpenNotifications,
              hasUnread: hasUnreadNotifications,
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SearchEntryCard(onTap: onSearchTap),
                  const SizedBox(height: 18),
                  if (isLoadingPendingReviews) ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ] else if (pendingReviewRequests.isNotEmpty) ...[
                    _RateExperienceCard(
                      request: pendingReviewRequests.first,
                      onWriteReview:
                          () => onWriteReview(pendingReviewRequests.first),
                    ),
                    const SizedBox(height: 18),
                  ],
                  _SectionTitle(title: l10n.patientQuickServices),
                  const SizedBox(height: 12),
                  _QuickServicesRow(onServiceTap: onQuickServiceTap),
                  const SizedBox(height: 16),
                  _StatsRow(
                    totalBookings: totalBookings,
                    activeRequests: activeRequests,
                    isLoading: isLoadingDashboardSummary,
                  ),
                  const SizedBox(height: 18),
                  _SectionTitleWithAction(
                    title: l10n.patientUpcomingAppointments,
                    action: l10n.patientViewAll,
                    onActionTap: onUpcomingViewAllTap,
                  ),
                  const SizedBox(height: 12),
                  const _UpcomingAppointments(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;
  final String name;
  final bool hasUnread;

  const _HomeHeader({
    required this.onNotificationTap,
    required this.name,
    required this.hasUnread,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.patientWelcomeBackLine,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name.isEmpty ? l10n.user : name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onNotificationTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                          ),
                        ),
                        if (hasUnread)
                          Positioned(
                            right: 10,
                            top: 10,
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
              const SizedBox(width: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => showLanguageSelectorSheet(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.language_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _SearchEntryCard extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchEntryCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECF2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF6B7280)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.patientSearchNursesHint,
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w600,
                ),
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1D2433),
      ),
    );
  }
}

class _SectionTitleWithAction extends StatelessWidget {
  final String title;
  final String action;
  final String? subtitle;
  final VoidCallback? onActionTap;

  const _SectionTitleWithAction({
    required this.title,
    required this.action,
    this.subtitle,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2433),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ],
          ),
        ),
        TextButton(
          onPressed: onActionTap,
          child: Text(
            action,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF2F7F8D),
            ),
          ),
        ),
      ],
    );
  }
}

class _RateExperienceCard extends StatelessWidget {
  final PatientPendingReviewItem request;
  final VoidCallback onWriteReview;

  const _RateExperienceCard({
    required this.request,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFE1B3)),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.star_rounded, color: Color(0xFFFFA000)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.patientRateExperienceTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF8A4B00),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.patientRateExperienceSubtitle(request.nurseName),
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A4B00),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: onWriteReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(
                l10n.patientWriteReview,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickServicesRow extends StatelessWidget {
  final ValueChanged<int> onServiceTap;

  const _QuickServicesRow({required this.onServiceTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _ServiceTile(
            icon: Icons.water_drop_outlined,
            label: l10n.patientServiceIvTherapy,
            onTap: () => onServiceTap(1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ServiceTile(
            icon: Icons.favorite_border,
            label: l10n.patientServiceWoundCare,
            onTap: () => onServiceTap(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ServiceTile(
            icon: Icons.medical_services_outlined,
            label: l10n.patientServicePostSurgery,
            onTap: () => onServiceTap(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ServiceTile(
            icon: Icons.medication_outlined,
            label: l10n.patientServiceMedication,
            onTap: () => onServiceTap(5),
          ),
        ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECF2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: primary),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF374151),
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int totalBookings;
  final int activeRequests;
  final bool isLoading;

  const _StatsRow({
    required this.totalBookings,
    required this.activeRequests,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalText = isLoading ? '...' : totalBookings.toString();
    final activeText = isLoading ? '...' : activeRequests.toString();

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            filled: true,
            icon: Icons.show_chart_rounded,
            number: totalText,
            label: l10n.patientTotalBookings,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            filled: false,
            icon: Icons.medical_services_outlined,
            number: activeText,
            label: l10n.patientActiveRequests,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final bool filled;
  final IconData icon;
  final String number;
  final String label;

  const _StatCard({
    required this.filled,
    required this.icon,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

    final bg = filled ? primary : Colors.white;
    final textColor = filled ? Colors.white : const Color(0xFF1D2433);
    final subColor = filled ? Colors.white70 : const Color(0xFF6B7280);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: filled ? null : Border.all(color: const Color(0xFFE8ECF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: filled ? Colors.white : primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: subColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingAppointments extends StatefulWidget {
  const _UpcomingAppointments();

  @override
  State<_UpcomingAppointments> createState() => _UpcomingAppointmentsState();
}

class _UpcomingAppointmentsState extends State<_UpcomingAppointments> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadUpcomingAppointments();
  }

  Future<void> _loadUpcomingAppointments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final appointments = await ApiService.getPatientAppointments(
        tab: 'upcoming',
      );

      if (!mounted) return;

      setState(() {
        _appointments = appointments.take(2).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _appointments = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _openDetails(Appointment appointment) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder:
            (_) => PatientAppointmentDetailsScreen(appointment: appointment),
      ),
    );

    if (!mounted) return;
    await _loadUpcomingAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(18),
        width: double.infinity,
        decoration: _boxDecoration(),
        child: const Center(
          child: SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: _boxDecoration(),
        child: Text(
          _errorMessage!,
          style: const TextStyle(
            color: Color(0xFFD32F2F),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (_appointments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: _boxDecoration(),
        child: Text(
          l10n.patientAppointmentsNoUpcoming,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(
      children:
          _appointments.map((apt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _MiniAppointmentCard(
                appointment: apt,
                onTap: () => _openDetails(apt),
              ),
            );
          }).toList(),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE8ECF2)),
    );
  }
}

class _MiniAppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onTap;

  const _MiniAppointmentCard({required this.appointment, required this.onTap});

  Color get _statusBg {
    switch (appointment.status.name.toLowerCase()) {
      case 'accepted':
      case 'confirmed':
        return const Color(0xFFE0F2FE);
      case 'active':
      case 'paid':
        return const Color(0xFFDCFCE7);
      case 'pending':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color get _statusFg {
    switch (appointment.status.name.toLowerCase()) {
      case 'accepted':
      case 'confirmed':
        return const Color(0xFF0369A1);
      case 'active':
      case 'paid':
        return const Color(0xFF15803D);
      case 'pending':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _timeText(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month} • $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8ECF2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    appointment.nurseName.isNotEmpty
                        ? appointment.nurseName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.serviceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14.5,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      appointment.nurseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _timeText(appointment.dateTime),
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${appointment.price.toStringAsFixed(0)} JOD',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      appointment.status.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: _statusFg,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
