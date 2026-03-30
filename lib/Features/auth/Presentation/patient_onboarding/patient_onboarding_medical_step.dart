import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'patient_onboarding_constants.dart';

class PatientOnboardingMedicalStep extends StatelessWidget {
  const PatientOnboardingMedicalStep({
    super.key,
    required this.conditionKeys,
    required this.onConditionToggle,
    required this.otherConditionController,
    required this.selectedAllergyLabels,
    required this.onAllergyChipToggle,
    required this.customAllergyController,
    required this.notesController,
  });

  final Set<String> conditionKeys;
  final void Function(String key, bool selected) onConditionToggle;
  final TextEditingController otherConditionController;
  final Set<String> selectedAllergyLabels;
  final void Function(String label, bool selected) onAllergyChipToggle;
  final TextEditingController customAllergyController;
  final TextEditingController notesController;

  static const _conditions = [
    ('diabetes', 'Diabetes'),
    ('hypertension', 'Hypertension'),
    ('asthma', 'Asthma'),
    ('heart_disease', 'Heart Disease'),
    ('arthritis', 'Arthritis'),
    ('none', 'None'),
  ];

  static const _allergyChips = [
    'Penicillin',
    'Dust',
    'Food',
    'Latex',
    'Pollen',
  ];

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medical info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PatientOnboardingTokens.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Optional — share only what you are comfortable with.',
            style: TextStyle(
              fontSize: 13.5,
              color: PatientOnboardingTokens.muted,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Conditions',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: PatientOnboardingTokens.text,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select any that apply. None cannot be combined with other conditions.',
            style: TextStyle(
              fontSize: 12.5,
              color: PatientOnboardingTokens.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          ..._conditions.map((e) {
            final key = e.$1;
            final label = e.$2;
            final checked = conditionKeys.contains(key);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => onConditionToggle(key, !checked),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: checked ? primary : PatientOnboardingTokens.border,
                      width: checked ? 1.6 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: checked,
                          onChanged: (v) =>
                              onConditionToggle(key, v ?? false),
                          activeColor: primary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: PatientOnboardingTokens.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          const Text(
            'Other condition (optional)',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: PatientOnboardingTokens.text,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: otherConditionController,
            textInputAction: TextInputAction.next,
            decoration: patientOnboardingOutlineDecoration(
              primary,
              hint: 'e.g. Cancer, Kidney disease',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Allergies',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: PatientOnboardingTokens.text,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap common allergies or add your own below.',
            style: TextStyle(
              fontSize: 12.5,
              color: PatientOnboardingTokens.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allergyChips.map((label) {
              final sel = selectedAllergyLabels.contains(label);
              return FilterChip(
                label: Text(label),
                selected: sel,
                onSelected: (v) => onAllergyChipToggle(label, v),
                selectedColor: primary.withValues(alpha: 0.18),
                checkmarkColor: primary,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: sel ? primary : PatientOnboardingTokens.text,
                ),
                side: BorderSide(
                  color: sel ? primary : PatientOnboardingTokens.border,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          const Text(
            'Other allergies (optional)',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: PatientOnboardingTokens.text,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: customAllergyController,
            textInputAction: TextInputAction.next,
            decoration: patientOnboardingOutlineDecoration(
              primary,
              hint: 'e.g. Sulfa, nuts, seafood',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Notes',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: PatientOnboardingTokens.text,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: notesController,
            maxLines: 4,
            minLines: 3,
            decoration: patientOnboardingOutlineDecoration(
              primary,
              hint: 'Anything else your care team should know...',
            ),
          ),
        ],
      ),
    );
  }
}
