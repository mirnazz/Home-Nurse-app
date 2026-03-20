import 'package:flutter/material.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_bottom_nav_bar.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_request_service_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_service_request_models.dart';

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
  final String certificateUrl;
  final List<String> servicesOffered;

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
    required this.certificateUrl,
    required this.servicesOffered,
  });

  // TODO(Abeer): Wire this model to the profile endpoint response.
  // Expected shape:
  // {
  //   "nurseId": "...",
  //   "fullName": "...",
  //   "profileImageUrl": "...",
  //   "headline": "...",
  //   "rating": 0.0,
  //   "reviewsCount": 0,
  //   "experienceYears": 0,
  //   "location": "...",
  //   "address": "...",
  //   "availabilityLabel": "...",
  //   "certificateUrl": "...",
  //   "servicesOffered": ["..."]
  // }
  factory PatientNurseProfileData.fromApiJson(Map<String, dynamic> json) {
    final rawServices = (json['servicesOffered'] as List?) ?? const [];
    return PatientNurseProfileData(
      nurseId: (json['nurseId'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      profileImageUrl: (json['profileImageUrl'] ?? '').toString(),
      headline: (json['headline'] ?? '').toString(),
      rating: ((json['rating'] ?? 0) as num).toDouble(),
      reviewsCount: ((json['reviewsCount'] ?? 0) as num).toInt(),
      experienceYears: ((json['experienceYears'] ?? 0) as num).toInt(),
      location: (json['location'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      availabilityLabel: (json['availabilityLabel'] ?? 'Unavailable').toString(),
      certificateUrl: (json['certificateUrl'] ?? '').toString(),
      servicesOffered: rawServices.map((e) => e.toString()).toList(),
    );
  }
}

class PatientNurseProfileScreen extends StatelessWidget {
  final PatientNurseProfileData profile;

  const PatientNurseProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);
    const screenBg = Color(0xFFF4F6F8);
    final initials = profile.fullName
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: screenBg,
      body: Column(
        children: [
          Container(
            color: primary,
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
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFFE7F1F3),
                          backgroundImage:
                              profile.profileImageUrl.isNotEmpty
                                  ? NetworkImage(profile.profileImageUrl)
                                  : null,
                          child:
                              profile.profileImageUrl.isEmpty
                                  ? Text(
                                    initials,
                                    style: const TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  )
                                  : null,
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
                                  const Icon(Icons.star, color: Color(0xFFF7B500), size: 17),
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
                                  const Icon(Icons.schedule, color: Colors.white70, size: 15),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${profile.experienceYears} years',
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
                        const Expanded(
                          child: _ProfileTab(text: 'About', selected: true),
                        ),
                        Expanded(
                          child: _ProfileTab(
                            text: 'Reviews (${profile.reviewsCount})',
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
                  // ── Location row ──────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                            color: Color(0xFF2F7F8D),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location',
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profile.address}, ${profile.location}',
                              style: const TextStyle(
                                color: Color(0xFF1F2937),
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Availability ──────────────────────────────────────────
                  _SectionCard(
                    title: 'Availability',
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F6EC),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 8,
                                color: Color(0xFF1F8A4D),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                profile.availabilityLabel,
                                style: const TextStyle(
                                  color: Color(0xFF1F8A4D),
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

                  // ── Qualifications ────────────────────────────────────────
                  _SectionCard(
                    title: 'Qualifications & Certifications',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _CheckLine('Registered Nurse profile'),
                        const SizedBox(height: 8),
                        _CheckLine(
                          profile.certificateUrl.isEmpty
                              ? 'Certificate URL will appear after API binding'
                              : 'Certificate attached from backend response',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Services Offered ──────────────────────────────────────
                  _SectionCard(
                    title: 'Services Offered',
                    child: profile.servicesOffered.isEmpty
                        ? const Text(
                            'Services will appear after API data is loaded.',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final service in profile.servicesOffered)
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
                                      color: Color(0xFF2F7F8D),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PatientRequestServiceScreen(
                        nurseId: profile.nurseId,
                        nurseName: profile.fullName,
                        nurseSubtitle: profile.headline,
                        nurseInitials: initials,
                        // Temporary test payload until API integration is ready.
                        serviceOptions: const [
                          PatientServiceOption(
                            id: 'service_1',
                            title: 'IV Therapy',
                            durationLabel: 'Duration: 60 min',
                            priceJod: 50,
                          ),
                          PatientServiceOption(
                            id: 'service_2',
                            title: 'Wound Care & Dressing',
                            durationLabel: 'Duration: 45 min',
                            priceJod: 30,
                          ),
                          PatientServiceOption(
                            id: 'service_3',
                            title: 'Post-Surgery Care',
                            durationLabel: 'Duration: 90 min',
                            priceJod: 45,
                          ),
                          PatientServiceOption(
                            id: 'service_4',
                            title: 'Medication Management',
                            durationLabel: 'Duration: 30 min',
                            priceJod: 25,
                          ),
                        ],
                        availableTimeSlots: const [
                          '09:00',
                          '10:00',
                          '11:00',
                          '12:00',
                          '14:00',
                          '15:00',
                          '16:00',
                          '17:00',
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F7F8D),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: const Color(0xFF2F7F8D).withOpacity(0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                    letterSpacing: 0.3,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Book Service Request'),
                  ],
                ),
              ),
            ),
          ),
          PatientBottomNavBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 1) return;
              if (index == 0) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final String text;
  final bool selected;
  const _ProfileTab({required this.text, required this.selected});

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
  const _SectionCard({required this.title, required this.child});

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
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  final String text;
  const _CheckLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_rounded, color: Color(0xFF8AD1A7), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

