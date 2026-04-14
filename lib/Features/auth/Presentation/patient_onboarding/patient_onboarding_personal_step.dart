import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
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

  static String _genderLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'Male':
        return l10n.profileGenderMale;
      case 'Female':
        return l10n.profileGenderFemale;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = AppColors.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.patientOnboardPersonalTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PatientOnboardingTokens.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.patientOnboardPersonalSubtitle,
            style: TextStyle(
              fontSize: 13.5,
              color: PatientOnboardingTokens.muted,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          _label(l10n.gender),
          const SizedBox(height: 8),
          PatientOnboardingStyledDropdown<String>(
            value: gender,
            hint: l10n.patientOnboardSelectGender,
            items: _genders,
            itemLabel: (v) => _genderLabel(l10n, v),
            onChanged: onGenderChanged,
            primary: primary,
          ),
          const SizedBox(height: 16),
          _label(l10n.dateOfBirth),
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
                          ? l10n.patientOnboardSelectDate
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
          _label(l10n.bloodType),
          const SizedBox(height: 8),
          PatientOnboardingStyledDropdown<String>(
            value: bloodType,
            hint: l10n.patientOnboardSelectBloodType,
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
