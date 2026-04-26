import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_request_service_screen.dart';

class PatientNurseProfileData {
  final String nurseId;
  final String fullName;
  final String profileImageUrl;
  final String headline;
  final double rating;
  final int reviewsCount;
  final int experienceYears;
  final String location;
  final String address;
  final String availabilityLabel;

  const PatientNurseProfileData({
    required this.nurseId,
    required this.fullName,
    required this.profileImageUrl,
    required this.headline,
    required this.rating,
    required this.reviewsCount,
    required this.experienceYears,
    required this.location,
    required this.address,
    required this.availabilityLabel,
  });
}

class PatientNurseProfileScreen extends StatefulWidget {
  final PatientNurseProfileData profile;

  const PatientNurseProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<PatientNurseProfileScreen> createState() =>
      _PatientNurseProfileScreenState();
}

class _PatientNurseProfileScreenState
    extends State<PatientNurseProfileScreen> {
  static const Color _primary = Color(0xFF2F7F8D);
  static const Color _screenBg = Color(0xFFF4F6F8);

  List<String> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final data = await ApiService.getPatientNurseServices(
        nurseId: widget.profile.nurseId,
      );

      if (!mounted) return;

      setState(() {
        services = data
            .map((e) => (e['serviceName'] ?? '').toString())
            .where((name) => name.isNotEmpty)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('ERROR loading services: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _openRequestService() {
    final profile = widget.profile;

    final initials = profile.fullName
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PatientRequestServiceScreen(
          nurseId: profile.nurseId,
          nurseName: profile.fullName,
          nurseSubtitle: profile.headline,
          nurseInitials: initials,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = widget.profile;

    final initials = profile.fullName
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    final hasServices = services.isNotEmpty;

    return Scaffold(
      backgroundColor: _screenBg,
      body: Column(
        children: [
          Container(
            color: _primary,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        _ProfileAvatar(
                          imageUrl: profile.profileImageUrl,
                          initials: initials,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                profile.headline,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFF7B500),
                                    size: 17,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${profile.rating.toStringAsFixed(1)} (${profile.reviewsCount})',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.schedule,
                                    color: Colors.white70,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.patientBrowseExperienceYears(profile.experienceYears),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: _ProfileTab(
                            text: l10n.patientNurseProfileAboutTab,
                            selected: true,
                          ),
                        ),
                        Expanded(
                          child: _ProfileTab(
                            text: l10n.patientNurseProfileReviewsTab(profile.reviewsCount),
                            selected: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionCard(
                    title: l10n.patientNurseProfileLocation,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F4F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: _primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${profile.address}, ${profile.location}',
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    title: l10n.patientNurseProfileAvailability,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _availabilityBackground(
                              profile.availabilityLabel,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: _availabilityTextColor(
                                  profile.availabilityLabel,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                profile.availabilityLabel,
                                style: TextStyle(
                                  color: _availabilityTextColor(
                                    profile.availabilityLabel,
                                  ),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    title: l10n.patientNurseProfileServicesOffered,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : hasServices
                            ? Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final service in services)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF4F6),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        service,
                                        style: const TextStyle(
                                          color: _primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.patientNurseProfileNoServicesTitle,
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    l10n.patientNurseProfileNoServicesSubtitle,
                                    style: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: hasServices ? _openRequestService : null,
              icon: Icon(
                Icons.calendar_today_rounded,
                size: 18,
                color: hasServices ? Colors.white : Colors.white70,
              ),
              label: Text(
                hasServices
                    ? l10n.patientNurseProfileBookServiceRequest
                    : l10n.patientNurseProfileNoServicesAvailable,
                style: TextStyle(
                  color: hasServices ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    hasServices ? _primary : Colors.grey.shade300,
                foregroundColor: Colors.white,
                elevation: hasServices ? 4 : 0,
                shadowColor: hasServices
                    ? _primary.withOpacity(0.28)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _availabilityBackground(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('available')) {
      return const Color(0xFFE3F6EC);
    }
    return const Color(0xFFF3F4F6);
  }

  Color _availabilityTextColor(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('available')) {
      return const Color(0xFF1F8A4D);
    }
    return const Color(0xFF6B7280);
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final String initials;

  const _ProfileAvatar({
    required this.imageUrl,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

    if (imageUrl.isEmpty) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: const Color(0xFFE7F1F3),
        child: Text(
          initials,
          style: const TextStyle(
            color: primary,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: const Color(0xFFE7F1F3),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              width: 50,
              height: 50,
              color: const Color(0xFFE7F1F3),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final String text;
  final bool selected;

  const _ProfileTab({
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: selected ? const Color(0xFF2F7F8D) : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: selected ? const Color(0xFF2F7F8D) : const Color(0xFF6B7280),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}


