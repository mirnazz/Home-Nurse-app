import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/nurse/models/nurse_service_model.dart';
import 'add_service_screen.dart';
import 'edit_service_screen.dart';

void _agentLogProfile({
  required String runId,
  required String hypothesisId,
  required String location,
  required String message,
  Map<String, Object?> data = const {},
}) {
  try {
    final payload = <String, Object?>{
      'sessionId': 'd86d99',
      'runId': runId,
      'hypothesisId': hypothesisId,
      'location': location,
      'message': message,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    final line = '${jsonEncode(payload)}\n';
    File('/Users/mirnabaqi/Desktop/Nurse_Home_app/nurse_app/.cursor/debug-d86d99.log')
        .writeAsStringSync(line, mode: FileMode.append, flush: true);
  } catch (_) {}
}

class NurseProfileScreen extends StatefulWidget {
  const NurseProfileScreen({
    super.key,
    this.onTabChanged,
    this.currentTabIndex = 1,
  });

  final ValueChanged<int>? onTabChanged;
  final int currentTabIndex;

  static const List<NurseServiceItem> _mockServices = [
    NurseServiceItem(name: "IV Therapy", durationMinutes: 60, priceJod: 50),
    NurseServiceItem(name: "Wound Care", durationMinutes: 45, priceJod: 30),
    NurseServiceItem(name: "Medication Management", durationMinutes: 30, priceJod: 22),
    NurseServiceItem(name: "Post-Surgery Care", durationMinutes: 90, priceJod: 65),
  ];

  @override
  State<NurseProfileScreen> createState() => _NurseProfileScreenState();
}

class _NurseProfileScreenState extends State<NurseProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _bioController;
  late final TextEditingController _licenseNumberController;
  late final TextEditingController _specializationController;
  late final TextEditingController _experienceController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: "Sarah Hassan");
    _emailController =
        TextEditingController(text: "sarah.hassan@email.com");
    _phoneController = TextEditingController(text: "+962 79 123 4567");
    _locationController = TextEditingController(text: "Amman, Jordan");
    _bioController = TextEditingController(
      text:
          "Experienced registered nurse specializing in critical care and home health services. Passionate about providing quality patient-centered care.",
    );
    _licenseNumberController = TextEditingController(text: "RN-2024-12345");
    _specializationController =
        TextEditingController(text: "Critical Care Nursing");
    _experienceController = TextEditingController(text: "8 years");
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _licenseNumberController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _onSaveProfile() {
    // TODO: Call nurse profile PUT endpoint here after service layer is connected.
    // Example payload should use current controller values.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated (mock). Backend integration TODO."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // #region agent log
    _agentLogProfile(
      runId: 'run2',
      hypothesisId: 'H3',
      location: 'nurse_profile_screen.dart:build',
      message: 'Profile screen build',
      data: <String, Object?>{
        'mockServicesCount': NurseProfileScreen._mockServices.length,
      },
    );
    // #endregion
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeader(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _PersonalInformationSection(
                  fullNameController: _fullNameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  locationController: _locationController,
                  bioController: _bioController,
                ),
                const SizedBox(height: 24),
                _ProfessionalDetailsSection(
                  licenseNumberController: _licenseNumberController,
                  specializationController: _specializationController,
                  experienceController: _experienceController,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSaveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _ServicesOfferedSection(
                  services: NurseProfileScreen._mockServices,
                  onAddService: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddServiceScreen(),
                      ),
                    );
                  },
                  onEditService: (service) {
                    // #region agent log
                    _agentLogProfile(
                      runId: 'run2',
                      hypothesisId: 'H4',
                      location: 'nurse_profile_screen.dart:onEditService',
                      message: 'Navigating to edit service',
                      data: <String, Object?>{
                        'serviceName': service.name,
                        'duration': service.durationMinutes,
                      },
                    );
                    // #endregion
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditServiceScreen(service: service),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
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
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Manage your professional information",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonalInformationSection extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextEditingController bioController;

  const _PersonalInformationSection({
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
    required this.bioController,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: "Personal Information",
      showEditIcon: true,
      child: Column(
        children: [
          _InfoField(
            icon: Icons.person_outline,
            label: "Full Name",
            controller: fullNameController,
          ),
          const SizedBox(height: 16),
          _InfoField(
            icon: Icons.email_outlined,
            label: "Email",
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _InfoField(
            icon: Icons.phone_outlined,
            label: "Phone Number",
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _InfoField(
            icon: Icons.location_on_outlined,
            label: "Location",
            controller: locationController,
          ),
          const SizedBox(height: 16),
          _InfoField(
            icon: Icons.description_outlined,
            label: "Bio",
            controller: bioController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _ProfessionalDetailsSection extends StatelessWidget {
  final TextEditingController licenseNumberController;
  final TextEditingController specializationController;
  final TextEditingController experienceController;

  const _ProfessionalDetailsSection({
    required this.licenseNumberController,
    required this.specializationController,
    required this.experienceController,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: "Professional Details",
      showEditIcon: true,
      child: Column(
        children: [
          _InfoField(
            icon: Icons.badge_outlined,
            label: "License Number",
            controller: licenseNumberController,
          ),
          const SizedBox(height: 16),
          _InfoField(
            icon: Icons.medical_services_outlined,
            label: "Specialization",
            controller: specializationController,
          ),
          const SizedBox(height: 16),
          _InfoField(
            icon: Icons.calendar_today_outlined,
            label: "Experience",
            controller: experienceController,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final bool showEditIcon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.showEditIcon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2433),
                ),
              ),
              if (showEditIcon)
                Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;

  const _InfoField({
    required this.icon,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: maxLines > 1 ? 4 : 1,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D2433),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.lightGrey,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ServicesOfferedSection extends StatelessWidget {
  final List<NurseServiceItem> services;
  final VoidCallback onAddService;
  final ValueChanged<NurseServiceItem> onEditService;

  const _ServicesOfferedSection({
    required this.services,
    required this.onAddService,
    required this.onEditService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Services Offered",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2433),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onAddService,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text("Add Service"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...services.map((s) => _ServiceCard(
            service: s,
            onEdit: () => onEditService(s),
          )),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final NurseServiceItem service;
  final VoidCallback onEdit;

  const _ServiceCard({required this.service, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Color(0xFF1D2433),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${service.durationMinutes} min • ${service.priceJod} JOD",
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
