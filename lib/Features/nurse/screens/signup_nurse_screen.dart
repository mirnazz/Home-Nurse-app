import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NurseRegistrationScreen extends StatefulWidget {
  const NurseRegistrationScreen({super.key});

  @override
  State<NurseRegistrationScreen> createState() =>
      _NurseRegistrationScreenState();
}

class _NurseRegistrationScreenState
    extends State<NurseRegistrationScreen> {

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController experienceController =
      TextEditingController();

  String? selectedGovernorate;
  bool agreeToTerms = false;

  File? nationalIdFile;
  File? licenseFile;
  File? profilePhotoFile;

  final List<String> jordanGovernorates = [
    "Amman", "Irbid", "Zarqa", "Aqaba", "Balqa", "Karak",
    "Ma'an", "Madaba", "Mafraq", "Jerash", "Ajloun", "Tafilah",
  ];

  Future<void> pickImage(Function(File) onPicked) async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => onPicked(File(picked.path)));
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    areaController.dispose();
    specializationController.dispose();
    experienceController.dispose();
    super.dispose();
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
              _buildInput("Phone Number", phoneController,
                  hint: "e.g. 079XXXXXXX", keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              Text("Governorate",
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedGovernorate,
                hint: const Text("Select governorate"),
                items: jordanGovernorates
                    .map((gov) => DropdownMenuItem(value: gov, child: Text(gov)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedGovernorate = value),
                validator: (value) =>
                    value == null ? "Please select a governorate" : null,
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
              _buildInput("Area / Neighborhood", areaController,
                  hint: "e.g. Abdoun, Jabal Amman"),
              const SizedBox(height: 16),
              _buildInput("Specialization", specializationController,
                  hint: "e.g. ICU, Elderly Care"),
              const SizedBox(height: 16),
              _buildInput("Experience Years", experienceController,
                  hint: "e.g. 5", keyboardType: TextInputType.number),
              const SizedBox(height: 24),
              _uploadSection("Upload National ID", nationalIdFile,
                  (file) => nationalIdFile = file),
              const SizedBox(height: 12),
              _uploadSection("Upload Nursing License", licenseFile,
                  (file) => licenseFile = file),
              const SizedBox(height: 12),
              _uploadSection("Upload Profile Photo", profilePhotoFile,
                  (file) => profilePhotoFile = file),
              const SizedBox(height: 20),
              CheckboxListTile(
                value: agreeToTerms,
                activeColor: AppColors.primary,
                onChanged: (value) =>
                    setState(() => agreeToTerms = value!),
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
                  onPressed: _submitRegistration,
                  child: const Text(
                    "Submit Registration",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
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
        Text(label,
            style: TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) =>
              value == null || value.isEmpty ? "Required field" : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _uploadSection(
      String title, File? file, Function(File) onPicked) {
    return GestureDetector(
      onTap: () => pickImage(onPicked),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.primary.withOpacity(0.3)),
        ),
        child: file == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload, color: AppColors.primary),
                    const SizedBox(height: 6),
                    Text(title,
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
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
    );
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) return;
    if (!agreeToTerms ||
        nationalIdFile == null ||
        licenseFile == null ||
        profilePhotoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please complete all required fields")),
      );
      return;
    }
    // TODO: Send to backend as multipart/form-data (another developer will implement)
  }
}
