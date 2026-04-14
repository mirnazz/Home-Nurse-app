import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
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

  static const _conditionKeys = [
    'diabetes',
    'hypertension',
    'asthma',
    'heart_disease',
    'arthritis',
    'none',
  ];

  static const _allergyChips = [
    'Penicillin',
    'Dust',
    'Food',
    'Latex',
    'Pollen',
  ];

  static String _conditionLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'diabetes':
        return l10n.profileConditionDiabetes;
      case 'hypertension':
        return l10n.profileConditionHypertension;
      case 'asthma':
        return l10n.profileConditionAsthma;
      case 'heart_disease':
        return l10n.profileConditionHeartDisease;
      case 'arthritis':
        return l10n.profileConditionArthritis;
      case 'none':
        return l10n.profileConditionNone;
      default:
        return key;
    }
  }

  static String _allergyLabel(AppLocalizations l10n, String en) {
    switch (en) {
      case 'Penicillin':
        return l10n.profileAllergyPenicillin;
      case 'Dust':
        return l10n.profileAllergyDust;
      case 'Food':
        return l10n.profileAllergyFood;
      case 'Latex':
        return l10n.profileAllergyLatex;
      case 'Pollen':
        return l10n.profileAllergyPollen;
      default:
        return en;
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
            l10n.patientOnboardMedicalTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PatientOnboardingTokens.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.patientOnboardMedicalSubtitle,
            style: TextStyle(
              fontSize: 13.5,
              color: PatientOnboardingTokens.muted,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.patientOnboardConditionsSection,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: PatientOnboardingTokens.text,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.patientOnboardConditionsHint,
            style: TextStyle(
              fontSize: 12.5,
              color: PatientOnboardingTokens.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          ..._conditionKeys.map((key) {
            final label = _conditionLabel(l10n, key);
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
          Text(
            l10n.patientOnboardOtherConditionLabel,
            style: const TextStyle(
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
              hint: l10n.patientOnboardOtherConditionHint,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.patientOnboardAllergiesSection,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: PatientOnboardingTokens.text,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.patientOnboardAllergiesHint,
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
            children: _allergyChips.map((enKey) {
              final sel = selectedAllergyLabels.contains(enKey);
              return FilterChip(
                label: Text(_allergyLabel(l10n, enKey)),
                selected: sel,
                onSelected: (v) => onAllergyChipToggle(enKey, v),
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
          Text(
            l10n.patientOnboardOtherAllergiesLabel,
            style: const TextStyle(
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
              hint: l10n.patientOnboardOtherAllergiesHint,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.patientOnboardNotes,
            style: const TextStyle(
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
              hint: l10n.patientOnboardNotesHint,
            ),
          ),
        ],
      ),
    );
  }
}
