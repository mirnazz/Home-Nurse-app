import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'nurse_service_model.dart';
import 'add_service_screen.dart';
import 'edit_service_screen.dart';

class NursePersonalInfoScreen extends StatefulWidget {
  const NursePersonalInfoScreen({super.key});

  @override
  State<NursePersonalInfoScreen> createState() => _NursePersonalInfoScreenState();
}

class _NursePersonalInfoScreenState extends State<NursePersonalInfoScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _addressController;
  late final TextEditingController _bioController;
  late final TextEditingController _licenseNumberController;
  late final TextEditingController _specializationController;
  late final TextEditingController _experienceController;
  late final TextEditingController _nationalIdController;

  bool isLoading = true;
  bool isSaving = false;

  List<NurseServiceItem> services = [];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _addressController = TextEditingController();
    _bioController = TextEditingController();
    _licenseNumberController = TextEditingController();
    _specializationController = TextEditingController();
    _experienceController = TextEditingController();
    _nationalIdController = TextEditingController();

    _loadProfileData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _licenseNumberController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      final account = await ApiService.getAccount();
      final personal = await ApiService.getNursePersonalInfo();
      final professional = await ApiService.getNurseProfessionalDetails();
      final servicesResponse = await ApiService.getNurseServices();

      if (!mounted) return;

      _fullNameController.text = (account["fullName"] ?? "").toString();
      _emailController.text = (account["email"] ?? "").toString();

      _phoneController.text = (personal["phoneNumber"] ?? "").toString();
      _locationController.text = (personal["location"] ?? "").toString();
      _addressController.text = (personal["address"] ?? "").toString();
      _bioController.text = (personal["bio"] ?? "").toString();
      _nationalIdController.text = (personal["nationalId"] ?? "").toString();

      _licenseNumberController.text =
          (professional["licenseNumber"] ?? "").toString();
      _specializationController.text =
          (professional["specialization"] ?? "").toString();
      _experienceController.text =
          (professional["experienceYears"] ?? "").toString();

      services = servicesResponse
          .map<NurseServiceItem>((e) => NurseServiceItem.fromJson(e))
          .toList();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to load profile: ${e.toString().replaceFirst('Exception: ', '')}",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _onSaveProfile() async {
    final experienceYears = int.tryParse(_experienceController.text.trim());

    if (experienceYears == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Experience must be a valid number")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await ApiService.updateNurseProfileMultipart(
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        location: _locationController.text.trim(),
        bio: _bioController.text.trim(),
        licenseNumber: _licenseNumberController.text.trim(),
        specialization: _specializationController.text.trim(),
        experienceYears: experienceYears,
        nationalId: _nationalIdController.text.trim(),
        profileImage: null,
        certificate: null,
        nationalIdImage: null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );

      await _loadProfileData();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update profile: ${e.toString().replaceFirst('Exception: ', '')}",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Future<void> _openAddService() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddServiceScreen(),
      ),
    );

    if (result == true) {
      await _loadProfileData();
    }
  }

  Future<void> _openEditService(NurseServiceItem service) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditServiceScreen(service: service),
      ),
    );

    if (result == true) {
      await _loadProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfileData,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: const _ProfileHeader(showBack: true),
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
                          addressController: _addressController,
                          bioController: _bioController,
                          nationalIdController: _nationalIdController,
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
                            onPressed: isSaving ? null : _onSaveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
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
                          services: services,
                          onAddService: _openAddService,
                          onEditService: _openEditService,
                        ),
                        const SizedBox(height: 100),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final bool showBack;

  const _ProfileHeader({this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, showBack ? 8 : 24, 20, 28),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBack)
            IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
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
                      "Personal Info",
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
  final TextEditingController addressController;
  final TextEditingController bioController;
  final TextEditingController nationalIdController;

  const _PersonalInformationSection({
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
    required this.addressController,
    required this.bioController,
    required this.nationalIdController,
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
            enabled: false,
          ),
          const SizedBox(height: 16),
          _InfoField(
            icon: Icons.email_outlined,
            label: "Email",
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: false,
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
            icon: Icons.home_outlined,
            label: "Address",
            controller: addressController,
          ),
          const SizedBox(height: 16),
          _InfoField(
            icon: Icons.badge_outlined,
            label: "National ID",
            controller: nationalIdController,
            keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.number,
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
            color: Colors.black.withOpacity(0.05),
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
                const Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
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
  final bool enabled;

  const _InfoField({
    required this.icon,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.enabled = true,
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
          enabled: enabled,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D2433),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.lightGrey,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderGrey),
            ),
            disabledBorder: OutlineInputBorder(
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
            color: Colors.black.withOpacity(0.05),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (services.isEmpty)
            const Text(
              "No services found.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            )
          else
            ...services.map(
              (s) => _ServiceCard(
                service: s,
                onEdit: () => onEditService(s),
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final NurseServiceItem service;
  final VoidCallback onEdit;

  const _ServiceCard({
    required this.service,
    required this.onEdit,
  });

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
                  service.serviceName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Color(0xFF1D2433),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${service.durationInMinutes} min • ${service.price} JOD",
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
            icon: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
