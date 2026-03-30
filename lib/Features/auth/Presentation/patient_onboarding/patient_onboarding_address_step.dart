import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'patient_onboarding_constants.dart';
import 'patient_onboarding_styled_dropdown.dart';

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
    final primary = AppColors.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PatientOnboardingTokens.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Optional — helps nurses find you faster.',
            style: TextStyle(
              fontSize: 13.5,
              color: PatientOnboardingTokens.muted,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          _label('Governorate'),
          const SizedBox(height: 8),
          PatientOnboardingStyledDropdown<String>(
            value: governorate,
            hint: 'Select governorate',
            items: _governorates,
            onChanged: onGovernorateChanged,
            primary: primary,
          ),
          const SizedBox(height: 16),
          _label('Area'),
          const SizedBox(height: 8),
          TextFormField(
            controller: areaController,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              primary,
              hint: 'e.g. Abdoun, Jubeiha',
            ),
          ),
          const SizedBox(height: 16),
          _label('Street / building details'),
          const SizedBox(height: 8),
          TextFormField(
            controller: addressController,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            decoration: _inputDecoration(
              primary,
              hint: 'Apartment, building, landmarks',
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
