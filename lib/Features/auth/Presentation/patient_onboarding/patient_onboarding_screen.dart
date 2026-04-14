import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Core/widgets/language_selector_sheet.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'patient_onboarding_address_step.dart';
import 'patient_onboarding_constants.dart';
import 'patient_onboarding_data.dart';
import 'patient_onboarding_medical_step.dart';
import 'patient_onboarding_personal_step.dart';

const Map<String, String> _kMedicalConditionLabels = {
  'diabetes': 'Diabetes',
  'hypertension': 'Hypertension',
  'asthma': 'Asthma',
  'heart_disease': 'Heart Disease',
  'arthritis': 'Arthritis',
};

/// Steps 2–4 after account creation (step 1 is [SignUpScreen]).
///
/// [initialPageIndex]: `0` = step 2 (personal), `1` = step 3 (address),
/// `2` = step 4 (medical). Use for dev/testing when skipping signup.
class PatientOnboardingScreen extends StatefulWidget {
  const PatientOnboardingScreen({
    super.key,
    required this.data,
    this.initialPageIndex = 0,
  }) : assert(
          initialPageIndex >= 0 && initialPageIndex <= 2,
          'initialPageIndex must be 0, 1, or 2',
        );

  final PatientOnboardingData data;

  /// First onboarding page shown: 0 personal, 1 address, 2 medical.
  final int initialPageIndex;

  @override
  State<PatientOnboardingScreen> createState() =>
      _PatientOnboardingScreenState();
}

class _PatientOnboardingScreenState extends State<PatientOnboardingScreen> {
  late final PageController _pageController;

  int _pageIndex = 0;

  String? _gender;
  DateTime? _dateOfBirth;
  String? _bloodType;

  String? _governorate;
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final Set<String> _conditionKeys = {};
  final Set<String> _selectedAllergyLabels = {};
  final TextEditingController _otherConditionController =
      TextEditingController();
  final TextEditingController _customAllergyController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Color get _primary => AppColors.primary;

  @override
  void initState() {
    super.initState();
    final start = widget.initialPageIndex.clamp(0, 2);
    _pageIndex = start;
    _pageController = PageController(initialPage: start);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _otherConditionController.dispose();
    _customAllergyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _displayStep => _pageIndex + 2;

  void _goPatientHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/patientHome',
      (route) => false,
    );
  }

  void _onConditionToggle(String key, bool selected) {
    setState(() {
      if (key == 'none') {
        if (selected) {
          _conditionKeys
            ..clear()
            ..add('none');
        } else {
          _conditionKeys.remove('none');
        }
      } else {
        if (selected) {
          _conditionKeys.remove('none');
          _conditionKeys.add(key);
        } else {
          _conditionKeys.remove(key);
        }
      }
    });
  }

  void _onAllergyChipToggle(String label, bool selected) {
    setState(() {
      if (selected) {
        _selectedAllergyLabels.add(label);
      } else {
        _selectedAllergyLabels.remove(label);
      }
    });
  }

  void _syncDataFromForm() {
    final d = widget.data;
    d.gender = _gender;
    d.dateOfBirth = _dateOfBirth;
    d.bloodType = _bloodType;
    d.governorate = _governorate;
    d.area = _areaController.text.trim().isEmpty
        ? null
        : _areaController.text.trim();
    d.addressLine = _addressController.text.trim().isEmpty
        ? null
        : _addressController.text.trim();
    d.conditionKeys = Set<String>.from(_conditionKeys);
    final customConditionParts = _otherConditionController.text
        .split(RegExp(r'[,;\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (_conditionKeys.contains('none')) {
      d.allMedicalConditions = [
        'None',
        ...customConditionParts,
      ];
    } else {
      d.allMedicalConditions = [
        for (final k in _conditionKeys)
          if (_kMedicalConditionLabels.containsKey(k))
            _kMedicalConditionLabels[k]!,
        ...customConditionParts,
      ];
    }

    final customAllergyParts = _customAllergyController.text
        .split(RegExp(r'[,;\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty);
    d.allergies = [
      ..._selectedAllergyLabels,
      ...customAllergyParts,
    ];
    d.notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();
  }

  Future<void> _next() async {
    if (_pageIndex < 2) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _syncDataFromForm();
      _goPatientHome();
    }
  }

  void _back() {
    if (_pageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goPatientHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: PatientOnboardingTokens.bg,
        appBar: AppBar(
          backgroundColor: PatientOnboardingTokens.bg,
          elevation: 0,
          foregroundColor: PatientOnboardingTokens.text,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: _back,
          ),
          title: Text(
            l10n.patientOnboardStepOfFour(_displayStep),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: PatientOnboardingTokens.text,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: l10n.patientMoreLanguage,
              onPressed: () => showLanguageSelectorSheet(context),
              icon: const Icon(Icons.language_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: List.generate(3, (i) {
                  final active = i <= _pageIndex;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: 4,
                        decoration: BoxDecoration(
                          color: active
                              ? _primary
                              : PatientOnboardingTokens.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _pageIndex = i),
                children: [
                  PatientOnboardingPersonalStep(
                    gender: _gender,
                    onGenderChanged: (v) => setState(() => _gender = v),
                    dateOfBirth: _dateOfBirth,
                    onDateOfBirthChanged: (v) =>
                        setState(() => _dateOfBirth = v),
                    bloodType: _bloodType,
                    onBloodTypeChanged: (v) =>
                        setState(() => _bloodType = v),
                  ),
                  PatientOnboardingAddressStep(
                    governorate: _governorate,
                    onGovernorateChanged: (v) =>
                        setState(() => _governorate = v),
                    areaController: _areaController,
                    addressController: _addressController,
                  ),
                  PatientOnboardingMedicalStep(
                    conditionKeys: _conditionKeys,
                    onConditionToggle: _onConditionToggle,
                    otherConditionController: _otherConditionController,
                    selectedAllergyLabels: _selectedAllergyLabels,
                    onAllergyChipToggle: _onAllergyChipToggle,
                    customAllergyController: _customAllergyController,
                    notesController: _notesController,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _goPatientHome,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: PatientOnboardingTokens.muted,
                              side: const BorderSide(
                                color: PatientOnboardingTokens.border,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              l10n.patientOnboardSkipForNow,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: _next,
                              child: Text(
                                _pageIndex == 2
                                    ? l10n.patientOnboardGetStarted
                                    : l10n.patientOnboardNext,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
