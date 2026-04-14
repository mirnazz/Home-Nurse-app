import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'patient_onboarding_constants.dart';
import 'patient_onboarding_styled_dropdown.dart';

String _onboardingGovernorateLabel(AppLocalizations l10n, String apiValue) {
  switch (apiValue) {
    case 'Zarqa':
      return l10n.patientGovZarqa;
    case 'Irbid':
      return l10n.patientGovIrbid;
    case 'Amman':
      return l10n.patientGovAmman;
    case 'Tafilah':
      return l10n.patientGovTafilah;
    case 'Karak':
      return l10n.patientGovKarak;
    case 'Madaba':
      return l10n.patientGovMadaba;
    case 'Balqa':
      return l10n.patientGovBalqa;
    case 'Ajloun':
      return l10n.patientGovAjloun;
    case 'Jerash':
      return l10n.patientGovJerash;
    case 'Aqaba':
      return l10n.patientGovAqaba;
    case "Ma'an":
      return l10n.patientGovMaan;
    case 'Mafraq':
      return l10n.patientGovMafraq;
    default:
      return apiValue;
  }
}

class PatientOnboardingAddressStep extends StatelessWidget {
  const PatientOnboardingAddressStep({
    super.key,
    required this.governorate,
    required this.onGovernorateChanged,
    required this.areaController,
    required this.addressController,
  });

  final String? governorate;
  final ValueChanged<String?> onGovernorateChanged;
  final TextEditingController areaController;
  final TextEditingController addressController;

  static const _governorates = [
    'Amman',
    'Irbid',
    'Zarqa',
    'Balqa',
    'Mafraq',
    'Jerash',
    'Ajloun',
    'Madaba',
    'Karak',
    'Tafilah',
    "Ma'an",
    'Aqaba',
  ];

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
            l10n.patientOnboardAddressTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PatientOnboardingTokens.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.patientOnboardAddressSubtitle,
            style: TextStyle(
              fontSize: 13.5,
              color: PatientOnboardingTokens.muted,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          _label(l10n.governorate),
          const SizedBox(height: 8),
          PatientOnboardingStyledDropdown<String>(
            value: governorate,
            hint: l10n.profileSelectGovernorate,
            items: _governorates,
            itemLabel: (g) => _onboardingGovernorateLabel(l10n, g),
            onChanged: onGovernorateChanged,
            primary: primary,
          ),
          const SizedBox(height: 16),
          _label(l10n.area),
          const SizedBox(height: 8),
          TextFormField(
            controller: areaController,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              primary,
              hint: l10n.patientOnboardAreaHint,
            ),
          ),
          const SizedBox(height: 16),
          _label(l10n.patientOnboardStreetLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: addressController,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            decoration: _inputDecoration(
              primary,
              hint: l10n.patientOnboardStreetHint,
            ),
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

  static InputDecoration _inputDecoration(Color primary, {required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: PatientOnboardingTokens.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 1.6),
      ),
    );
  }
}
