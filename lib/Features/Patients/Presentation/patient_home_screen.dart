import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/token_storage.dart';
import 'package:nurse_app/Features/Patients/Presentation/browse_nurses_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_appointments_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_review_bottom_sheet.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_review_models.dart';

class PatientHomeScreen extends StatefulWidget {
  final List<PatientPendingReviewItem> pendingReviewRequests;
  final Future<List<PatientPendingReviewItem>> Function()? onFetchPendingReviewRequests;
  final Future<void> Function(PatientRatingSubmissionDraft draft)? onSubmitReview;

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
  bool _isLoadingPendingReviews = false;
  late List<PatientPendingReviewItem> _pendingReviewRequests;

  @override
  void initState() {
    super.initState();
    _pendingReviewRequests = widget.pendingReviewRequests.isNotEmpty
        ? List<PatientPendingReviewItem>.from(widget.pendingReviewRequests)
        : List<PatientPendingReviewItem>.from(_previewPendingReviewRequests);
    _fetchPendingReviews();
  }

  Future<void> _fetchPendingReviews() async {
    final fetcher = widget.onFetchPendingReviewRequests;
    if (fetcher == null) return;

    setState(() => _isLoadingPendingReviews = true);
    try {
      final requests = await fetcher();
      if (!mounted) return;
      setState(() => _pendingReviewRequests = requests);
    } catch (_) {
      // TODO(Abeer): handle backend fetch errors using app-level error strategy.
    } finally {
      if (mounted) {
        setState(() => _isLoadingPendingReviews = false);
      }
    }
  }

  Future<void> _openReviewBottomSheet(PatientPendingReviewItem request) async {
    final draft = await showModalBottomSheet<PatientRatingSubmissionDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PatientReviewBottomSheet(request: request),
    );

    if (draft == null || !mounted) return;

    try {
      final submitter = widget.onSubmitReview;
      if (submitter != null) {
        await submitter(draft);
      }

      if (!mounted) return;
      setState(() {
        _pendingReviewRequests.removeWhere((item) => item.requestId == request.requestId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanks! Your review was submitted.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submission failed: $e')),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await TokenStorage.clearToken();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  Widget _buildHomeBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _HomeHeader(onLogout: _logout),
            const SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoadingPendingReviews) ...[
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
                  ] else if (_pendingReviewRequests.isNotEmpty) ...[
                    _RateExperienceCard(
                      request: _pendingReviewRequests.first,
                      onWriteReview: () => _openReviewBottomSheet(_pendingReviewRequests.first),
                    ),
                    const SizedBox(height: 18),
                  ],
                  const _SectionTitle(title: "Quick Services"),
                  const SizedBox(height: 12),
                  const _QuickServicesRow(),
                  const SizedBox(height: 16),
                  const _StatsRow(),
                  const SizedBox(height: 18),
                  const _SectionTitleWithAction(
                    title: "Upcoming Appointments",
                    action: "View All",
                  ),
                  const SizedBox(height: 12),
                  const _UpcomingAppointments(),
                  const SizedBox(height: 18),
                  const _SectionTitleWithAction(
                    title: "Recommended for You",
                    action: "See All",
                    subtitle: "Based on location, ratings & availability",
                  ),
                  const SizedBox(height: 10),
                  const _LocationCard(),
                  const SizedBox(height: 12),
                  const _RecommendedCard(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7F9);

    return Scaffold(
      backgroundColor: bg,
      body: IndexedStack(
        index: currentTab,
        children: [
          _buildHomeBody(),
          const BrowseNursesScreen(),
          const PatientAppointmentsScreen(),
          _PatientTabPlaceholder(title: 'Payments', message: 'Payment history will appear here.'),
          _PatientTabPlaceholder(title: 'More', message: 'Settings and more coming soon.'),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: currentTab,
        onChanged: (i) => setState(() => currentTab = i),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final VoidCallback onLogout;

  const _HomeHeader({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "John",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    onLogout();
                  }
                },
                icon: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
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

  const _SectionTitleWithAction({
    required this.title,
    required this.action,
    this.subtitle,
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
          onPressed: () {},
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
                const Text(
                  "Rate Your Experience",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF8A4B00),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Help others by sharing your feedback\nabout ${request.nurseName}",
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
              child: const Text(
                "Write Review",
                style: TextStyle(
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

const List<PatientPendingReviewItem> _previewPendingReviewRequests = [
  PatientPendingReviewItem(
    requestId: 'preview_request_1',
    appointmentId: 'preview_appointment_1',
    serviceName: 'Post-Surgery Care',
    nurseName: 'Noor Ibrahim',
    completedAt: null,
  ),
];

class _QuickServicesRow extends StatelessWidget {
  const _QuickServicesRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _ServiceTile(
            icon: Icons.water_drop_outlined,
            label: "IV\nTherapy",
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _ServiceTile(
            icon: Icons.favorite_border,
            label: "Wound\nCare",
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _ServiceTile(
            icon: Icons.medical_services_outlined,
            label: "Post-\nSurgery",
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _ServiceTile(
            icon: Icons.medication_outlined,
            label: "Medication",
          ),
        ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ServiceTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

    return Container(
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
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            filled: true,
            icon: Icons.show_chart_rounded,
            number: "12",
            label: "Total Bookings",
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            filled: false,
            icon: Icons.medical_services_outlined,
            number: "3",
            label: "Active Requests",
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: subColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingAppointments extends StatelessWidget {
  const _UpcomingAppointments();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _AppointmentCard(
          name: "Sarah Hassan",
          service: "IV Therapy",
          day: "Today",
          time: "2:00 PM",
          statusText: "Confirmed",
          statusColor: Color(0xFF22C55E),
          statusBg: Color(0xFFEAFBF0),
        ),
        SizedBox(height: 12),
        _AppointmentCard(
          name: "Layla Ahmed",
          service: "Wound Care",
          day: "Tomorrow",
          time: "10:00 AM",
          statusText: "Pending",
          statusColor: Color(0xFFF59E0B),
          statusBg: Color(0xFFFFF7ED),
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String name;
  final String service;
  final String day;
  final String time;
  final String statusText;
  final Color statusColor;
  final Color statusBg;

  const _AppointmentCard({
    required this.name,
    required this.service,
    required this.day,
    required this.time,
    required this.statusText,
    required this.statusColor,
    required this.statusBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF2F7F8D),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1D2433),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  service,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2F7F8D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD6EEF6)),
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
            child: const Icon(Icons.location_on_outlined, color: primary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Location",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1D2433),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Abdali, Amman",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F7F8D),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: null,
            child: Text(
              "Change",
              style: TextStyle(fontWeight: FontWeight.w900, color: primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard();

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

    return Container(
      padding: const EdgeInsets.all(14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "SH",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sarah Hassan",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1D2433),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "IV Therapy • Wound Care",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAFBF0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      "Best Match",
                      style: TextStyle(
                        color: Color(0xFF22C55E),
                        fontWeight: FontWeight.w900,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "25 JOD/hr",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.star_rounded, color: Color(0xFFFFA000), size: 18),
              SizedBox(width: 4),
              Text(
                "4.95 (156)",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2433),
                ),
              ),
              SizedBox(width: 12),
              Icon(
                Icons.location_on_outlined,
                color: Color(0xFF6B7280),
                size: 18,
              ),
              SizedBox(width: 4),
              Text(
                "1.2 km away",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              _Chip(text: "95% Match"),
              SizedBox(width: 8),
              _Chip(text: "Closest to you"),
              SizedBox(width: 8),
              _Chip(text: "Fast responder"),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAFB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE4F0F2)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2F7F8D),
        ),
      ),
    );
  }
}

class _PatientTabPlaceholder extends StatelessWidget {
  final String title;
  final String message;

  const _PatientTabPlaceholder({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction_rounded, size: 48, color: primary.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2433),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _BottomNav({required this.currentIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

    return Container(
      padding: const EdgeInsets.only(top: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onChanged,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: const Color(0xFF9CA3AF),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: "Nurses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments_outlined),
            label: "Payments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_rounded),
            label: "More",
          ),
        ],
      ),
    );
  }
}
