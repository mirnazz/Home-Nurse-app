import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';

class NurseRegistrationScreen extends StatefulWidget {
  final String email;

  const NurseRegistrationScreen({super.key, required this.email});

  @override
  State<NurseRegistrationScreen> createState() =>
      _NurseRegistrationScreenState();
}

class _NurseRegistrationScreenState extends State<NurseRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController licenseNumberController =
      TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String? selectedGovernorate;
  bool agreeToTerms = false;

  File? nationalIdImageFile;
  File? licensePdfFile;
  File? profilePhotoFile;

  bool isLoading = false;
  bool _isPickingImage = false;

  final List<String> jordanGovernorates = const [
    "Amman",
    "Irbid",
    "Zarqa",
    "Aqaba",
    "Balqa",
    "Karak",
    "Ma'an",
    "Madaba",
    "Mafraq",
    "Jerash",
    "Ajloun",
    "Tafilah",
  ];

  @override
  void dispose() {
    phoneController.dispose();
    nationalIdController.dispose();
    licenseNumberController.dispose();
    areaController.dispose();
    specializationController.dispose();
    experienceController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<File?> _pickImageFile() async {
    if (_isPickingImage) return null;
    _isPickingImage = true;

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return null;
      return File(picked.path);
    } finally {
      _isPickingImage = false;
    }
  }

  Future<File?> _pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.single.path == null) return null;
    return File(result.files.single.path!);
  }

  Future<void> _pickAndSetImage({
    required void Function(File file) setFile,
  }) async {
    if (isLoading) return;
    FocusScope.of(context).unfocus();

    final file = await _pickImageFile();
    if (file == null) return;

    if (!mounted) return;
    setState(() => setFile(file));
  }

  Future<void> _pickAndSetPdf({
    required void Function(File file) setFile,
  }) async {
    if (isLoading) return;
    FocusScope.of(context).unfocus();

    final file = await _pickPdfFile();
    if (file == null) return;

    if (!mounted) return;
    setState(() => setFile(file));
  }

  Future<void> _submitRegistration() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (selectedGovernorate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseRegSelectGovernorateError)),
      );
      return;
    }

    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseRegConfirmInfoError)),
      );
      return;
    }

    final experienceYears = int.tryParse(experienceController.text.trim());
    if (experienceYears == null || experienceYears < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseRegExperienceInvalid)),
      );
      return;
    }

    if (nationalIdImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseRegUploadNationalIdError)),
      );
      return;
    }

    if (licensePdfFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseRegUploadLicenseError)),
      );
      return;
    }

    if (profilePhotoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseRegUploadProfilePhotoError)),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.updateNurseProfileMultipart(
        phoneNumber: phoneController.text.trim(),
        address: areaController.text.trim(),
        location: selectedGovernorate!,
        bio: bioController.text.trim(),
        licenseNumber: licenseNumberController.text.trim(),
        specialization: specializationController.text.trim(),
        experienceYears: experienceYears,
        nationalId: nationalIdController.text.trim(),
        profileImage: profilePhotoFile,
        certificate: licensePdfFile,
        nationalIdImage: nationalIdImageFile,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseRegSubmittedSuccess)),
      );

      Navigator.pushReplacementNamed(context, "/NursePending");
    } catch (e) {
      if (!mounted) return;

      debugPrint("NURSE SUBMIT ERROR => $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst("Exception: ", ""),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          l10n.nurseRegTitle,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              _buildInput(
                l10n.nurseRegPhoneLabel,
                phoneController,
                hint: l10n.nurseRegPhoneHint,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              _buildInput(
                l10n.nurseRegNationalIdLabel,
                nationalIdController,
                hint: l10n.nurseRegNationalIdHint,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              _buildInput(
                l10n.nurseRegLicenseLabel,
                licenseNumberController,
                hint: l10n.nurseRegLicenseHint,
              ),
              const SizedBox(height: 16),

              Text(
                l10n.nurseRegGovernorateLabel,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),

              DropdownButtonFormField<String>(
                value: selectedGovernorate,
                hint: Text(l10n.nurseRegGovernorateSelect),
                items: jordanGovernorates
                    .map(
                      (gov) =>
                          DropdownMenuItem(value: gov, child: Text(gov)),
                    )
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (value) => setState(() => selectedGovernorate = value),
                validator: (value) =>
                    value == null ? l10n.nurseRegRequiredField : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildInput(
                l10n.nurseRegAreaLabel,
                areaController,
                hint: l10n.nurseRegAreaHint,
              ),
              const SizedBox(height: 16),

              _buildInput(
                l10n.nurseRegSpecializationLabel,
                specializationController,
                hint: l10n.nurseRegSpecializationHint,
              ),
              const SizedBox(height: 16),

              _buildInput(
                l10n.nurseRegExperienceLabel,
                experienceController,
                hint: l10n.nurseRegExperienceHint,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              _buildInput(
                l10n.nurseRegBioLabel,
                bioController,
                hint: l10n.nurseRegBioHint,
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              _uploadSection(
                title: l10n.nurseRegUploadNationalIdTitle,
                subtitle: l10n.nurseRegUploadImageHint,
                file: nationalIdImageFile,
                onTap: () => _pickAndSetImage(
                  setFile: (f) => nationalIdImageFile = f,
                ),
              ),
              const SizedBox(height: 12),

              _uploadSection(
                title: l10n.nurseRegUploadLicenseTitle,
                subtitle: l10n.nurseRegUploadPdfHint,
                file: licensePdfFile,
                onTap: () => _pickAndSetPdf(
                  setFile: (f) => licensePdfFile = f,
                ),
              ),
              const SizedBox(height: 12),

              _uploadSection(
                title: l10n.nurseRegUploadProfileTitle,
                subtitle: l10n.nurseRegUploadImageHint,
                file: profilePhotoFile,
                onTap: () => _pickAndSetImage(
                  setFile: (f) => profilePhotoFile = f,
                ),
              ),

              const SizedBox(height: 20),

              CheckboxListTile(
                value: agreeToTerms,
                activeColor: AppColors.primary,
                onChanged: isLoading
                    ? null
                    : (value) =>
                        setState(() => agreeToTerms = value ?? false),
                title: Text(
                  l10n.nurseRegConfirmAccuracy,
                  style: TextStyle(color: AppColors.primary),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: isLoading ? null : _submitRegistration,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.nurseRegSubmit,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: !isLoading,
          maxLines: maxLines,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.nurseRegRequiredField;
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _uploadSection({
    required String title,
    required String subtitle,
    required File? file,
    required VoidCallback onTap,
  }) {
    final fileName = file != null ? file.path.split('/').last : null;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Opacity(
        opacity: isLoading ? 0.7 : 1,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.upload_file,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: file == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D2433),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            fileName ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

