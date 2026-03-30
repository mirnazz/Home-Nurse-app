import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'patient_onboarding_constants.dart';
import 'patient_onboarding_styled_dropdown.dart';

class PatientOnboardingPersonalStep extends StatelessWidget {
  const PatientOnboardingPersonalStep({
    super.key,
    required this.gender,
    required this.onGenderChanged,
    required this.dateOfBirth,
    required this.onDateOfBirthChanged,
    required this.bloodType,
    required this.onBloodTypeChanged,
  });

  final String? gender;
  final ValueChanged<String?> onGenderChanged;
  final DateTime? dateOfBirth;
  final ValueChanged<DateTime?> onDateOfBirthChanged;
  final String? bloodType;
  final ValueChanged<String?> onBloodTypeChanged;

  static const _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  static const _genders = [
    'Male',
    'Female',
  ];

  Future<void> _pickDob(BuildContext context) async {
    final now = DateTime.now();
    final initial = dateOfBirth ?? DateTime(now.year - 25, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: PatientOnboardingTokens.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onDateOfBirthChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PatientOnboardingTokens.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Optional — you can skip and complete this later.',
            style: TextStyle(
              fontSize: 13.5,
              color: PatientOnboardingTokens.muted,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          _label('Gender'),
          const SizedBox(height: 8),
          PatientOnboardingStyledDropdown<String>(
            value: gender,
            hint: 'Select gender',
            items: _genders,
            onChanged: onGenderChanged,
            primary: primary,
          ),
          const SizedBox(height: 16),
          _label('Date of birth'),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _pickDob(context),
            borderRadius: BorderRadius.circular(16),
            child: InputDecorator(
              decoration: patientOnboardingOutlineDecoration(primary),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 20, color: PatientOnboardingTokens.muted),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dateOfBirth == null
                          ? 'Select date'
                          : '${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: dateOfBirth == null
                            ? const Color(0xFF94A3B8)
                            : PatientOnboardingTokens.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _label('Blood type'),
          const SizedBox(height: 8),
          PatientOnboardingStyledDropdown<String>(
            value: bloodType,
            hint: 'Select blood type',
            items: _bloodTypes,
            onChanged: onBloodTypeChanged,
            primary: primary,
          ),
        ],
      ),
    );
  }

  static Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: PatientOnboardingTokens.text,
        fontSize: 14,
      ),
    );
  }
}

