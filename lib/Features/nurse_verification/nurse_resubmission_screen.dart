import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/nurse_verification/nurse_pending_screen.dart';

class NurseResubmissionScreen extends StatefulWidget {
  const NurseResubmissionScreen({super.key});

  @override
  State<NurseResubmissionScreen> createState() =>
      _NurseResubmissionScreenState();
}

class _NurseResubmissionScreenState extends State<NurseResubmissionScreen> {
  static const primary = Color(0xFF1F7A8C);
  static const bg = Color(0xFFF6F7F9);

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final locationController = TextEditingController();
  final nationalIdController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final specializationController = TextEditingController();
  final experienceYearsController = TextEditingController();

  File? nationalIdFile;
  File? licenseFile;
  File? profilePhotoFile;

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    locationController.dispose();
    nationalIdController.dispose();
    licenseNumberController.dispose();
    specializationController.dispose();
    experienceYearsController.dispose();
    super.dispose();
  }

  InputDecoration _dec({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8ECF2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
    );
  }

  Future<File?> _pickFile({List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: false,
      withData: false,
    );

    if (result == null || result.files.isEmpty) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    return File(path);
  }

  String _fileName(File? f) {
    if (f == null) return "No file selected";
    return f.path.split(Platform.pathSeparator).last;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final experienceYears = int.tryParse(experienceYearsController.text.trim());
    if (experienceYears == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Experience years must be a valid number"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final account = await ApiService.getAccount();
      final fullName = (account["fullName"] ?? "").toString();

      await ApiService.updateNursePersonalInfo(
        fullName: fullName,
        phoneNumber: phoneController.text.trim(),
        location: locationController.text.trim(),
        address: addressController.text.trim(),
        bio: "",
      );

      await ApiService.updateNurseProfessionalDetails(
        licenseNumber: licenseNumberController.text.trim(),
        specialization: specializationController.text.trim(),
        experienceYears: experienceYears,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Resubmitted successfully. Waiting for admin approval."),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NursePendingScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Submit failed: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _fileCard({
    required String title,
    required String hint,
    required File? file,
    required IconData icon,
    required VoidCallback onPick,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFECFEFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  file == null ? hint : _fileName(file),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: file == null
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: isLoading ? null : onPick,
            child: const Text(
              "Choose",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF111827),
                      ),
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Resubmit Verification",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(
                            "Update your details",
                            "Fix the requested items and resubmit your information.\nAfter submitting, your status will return to Pending.",
                          ),
                          const SizedBox(height: 14),

                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: _dec(
                                    hint: "Phone number",
                                    icon: Icons.phone_outlined,
                                  ),
                                  validator: (v) {
                                    final s = (v ?? "").trim();
                                    if (s.isEmpty) return "Phone is required";
                                    if (s.length < 9) {
                                      return "Enter a valid phone number";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

                                TextFormField(
                                  controller: addressController,
                                  decoration: _dec(
                                    hint: "Address",
                                    icon: Icons.location_on_outlined,
                                  ),
                                  validator: (v) {
                                    if ((v ?? "").trim().isEmpty) {
                                      return "Address is required";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

                                TextFormField(
                                  controller: locationController,
                                  decoration: _dec(
                                    hint: "City / Location (e.g., Amman)",
                                    icon: Icons.map_outlined,
                                  ),
                                  validator: (v) {
                                    if ((v ?? "").trim().isEmpty) {
                                      return "Location is required";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

                                TextFormField(
                                  controller: nationalIdController,
                                  keyboardType: TextInputType.number,
                                  decoration: _dec(
                                    hint: "National ID number",
                                    icon: Icons.badge_outlined,
                                  ),
                                  validator: (v) {
                                    final s = (v ?? "").trim();
                                    if (s.isEmpty) {
                                      return "National ID is required";
                                    }
                                    if (s.length < 8) {
                                      return "Enter a valid National ID";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

                                TextFormField(
                                  controller: licenseNumberController,
                                  decoration: _dec(
                                    hint: "License number",
                                    icon: Icons.assignment_ind_outlined,
                                  ),
                                  validator: (v) {
                                    final s = (v ?? "").trim();
                                    if (s.isEmpty) {
                                      return "License number is required";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

                                TextFormField(
                                  controller: specializationController,
                                  decoration: _dec(
                                    hint: "Specialization (e.g., ICU)",
                                    icon: Icons.medical_services_outlined,
                                  ),
                                  validator: (v) {
                                    if ((v ?? "").trim().isEmpty) {
                                      return "Specialization is required";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

                                TextFormField(
                                  controller: experienceYearsController,
                                  keyboardType: TextInputType.number,
                                  decoration: _dec(
                                    hint: "Experience years",
                                    icon: Icons.timeline_outlined,
                                  ),
                                  validator: (v) {
                                    final s = (v ?? "").trim();
                                    if (s.isEmpty) {
                                      return "Experience years is required";
                                    }
                                    final n = int.tryParse(s);
                                    if (n == null || n < 0 || n > 60) {
                                      return "Enter a valid number";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(
                            "Documents",
                            "Files are selected locally for now.\nBackend upload is not connected yet in the current API service.",
                          ),
                          const SizedBox(height: 14),

                          _fileCard(
                            title: "National ID",
                            hint: "Upload your National ID (image/PDF)",
                            file: nationalIdFile,
                            icon: Icons.perm_identity_outlined,
                            onPick: () async {
                              final f = await _pickFile(
                                allowedExtensions: ["png", "jpg", "jpeg", "pdf"],
                              );
                              if (f != null && mounted) {
                                setState(() => nationalIdFile = f);
                              }
                            },
                          ),
                          const SizedBox(height: 10),

                          _fileCard(
                            title: "Nursing License",
                            hint: "Upload your license (image/PDF)",
                            file: licenseFile,
                            icon: Icons.assignment_outlined,
                            onPick: () async {
                              final f = await _pickFile(
                                allowedExtensions: ["png", "jpg", "jpeg", "pdf"],
                              );
                              if (f != null && mounted) {
                                setState(() => licenseFile = f);
                              }
                            },
                          ),
                          const SizedBox(height: 10),

                          _fileCard(
                            title: "Profile Photo",
                            hint: "Upload a profile photo (image)",
                            file: profilePhotoFile,
                            icon: Icons.photo_camera_outlined,
                            onPick: () async {
                              final f = await _pickFile(
                                allowedExtensions: ["png", "jpg", "jpeg"],
                              );
                              if (f != null && mounted) {
                                setState(() => profilePhotoFile = f);
                              }
                            },
                          ),

                          const SizedBox(height: 14),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: const Text(
                              "Note: document upload is currently pending backend support. The selected files are not sent yet with the current API service.",
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Submit for Review",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
