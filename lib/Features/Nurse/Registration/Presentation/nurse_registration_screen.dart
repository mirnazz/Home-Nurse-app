import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/core/theme/api/api_service.dart';

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

  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  String? selectedGovernorate;
  bool agreeToTerms = false;

  File? nationalIdFile;
  File? licenseFile;
  File? profilePhotoFile;

  bool isLoading = false;

  bool _isPickingImage = false;

  final List<String> jordanGovernorates = [
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
    areaController.dispose();
    specializationController.dispose();
    experienceController.dispose();
    nationalIdController.dispose();
    super.dispose();
  }

  Future<File?> _pickImageFile() async {
    if (_isPickingImage) return null;
    _isPickingImage = true;

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked == null) return null;
      return File(picked.path);
    } finally {
      _isPickingImage = false;
    }
  }

  Future<void> _pickAndSetFile({
    required void Function(File file) setFile,
  }) async {
    if (isLoading) return;
    FocusScope.of(context).unfocus();

    final file = await _pickImageFile();
    if (file == null) return;

    if (!mounted) return;
    setState(() => setFile(file));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          "Nurse Registration",
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
                "Phone Number",
                phoneController,
                hint: "e.g. 079XXXXXXX",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              _buildInput(
                "National ID Number",
                nationalIdController,
                hint: "Enter your national ID",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              Text(
                "Governorate",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),

              DropdownButtonFormField<String>(
                initialValue: selectedGovernorate,
                hint: const Text("Select governorate"),
                items:
                    jordanGovernorates
                        .map(
                          (gov) =>
                              DropdownMenuItem(value: gov, child: Text(gov)),
                        )
                        .toList(),
                onChanged:
                    isLoading
                        ? null
                        : (value) =>
                            setState(() => selectedGovernorate = value),
                validator: (value) => value == null ? "Required field" : null,
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
                "Area / Neighborhood",
                areaController,
                hint: "e.g. Abdoun, Jabal Amman",
              ),
              const SizedBox(height: 16),

              _buildInput(
                "Specialization",
                specializationController,
                hint: "e.g. ICU, Elderly Care",
              ),
              const SizedBox(height: 16),

              _buildInput(
                "Experience Years",
                experienceController,
                hint: "e.g. 5",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              _uploadSection(
                title: "Upload National ID",
                file: nationalIdFile,
                onTap:
                    () => _pickAndSetFile(setFile: (f) => nationalIdFile = f),
              ),
              const SizedBox(height: 12),

              _uploadSection(
                title: "Upload Nursing License",
                file: licenseFile,
                onTap: () => _pickAndSetFile(setFile: (f) => licenseFile = f),
              ),
              const SizedBox(height: 12),

              _uploadSection(
                title: "Upload Profile Photo",
                file: profilePhotoFile,
                onTap:
                    () => _pickAndSetFile(setFile: (f) => profilePhotoFile = f),
              ),

              const SizedBox(height: 20),

              CheckboxListTile(
                value: agreeToTerms,
                activeColor: AppColors.primary,
                onChanged:
                    isLoading
                        ? null
                        : (value) =>
                            setState(() => agreeToTerms = value ?? false),
                title: Text(
                  "I confirm all information is accurate",
                  style: TextStyle(color: AppColors.primary),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
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
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            "Submit Registration",
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
  }) {
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
          validator:
              (value) =>
                  value == null || value.trim().isEmpty
                      ? "Required field"
                      : null,
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
    required File? file,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Opacity(
        opacity: isLoading ? 0.7 : 1,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child:
              file == null
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload, color: AppColors.primary),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      file,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
        ),
      ),
    );
  }

  Future<void> _submitRegistration() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (selectedGovernorate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select governorate")),
      );
      return;
    }

    if (!agreeToTerms ||
        nationalIdFile == null ||
        licenseFile == null ||
        profilePhotoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all required fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.submitNurseRegistrationMultipart(
        phoneNumber: phoneController.text.trim(),
        address: areaController.text.trim(),
        location: selectedGovernorate!,
        nationalIdNumber: nationalIdController.text.trim(),
        specialization: specializationController.text.trim(),
        experienceYears: experienceController.text.trim(),
        nationalIdFile: nationalIdFile!,
        licenseFile: licenseFile!,
        profilePhotoFile: profilePhotoFile!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration submitted (Pending)")),
      );

      Navigator.pushReplacementNamed(context, "/NursePending");
    } catch (e) {
      if (!mounted) return;
      print("NURSE SUBMIT ERROR => $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
