import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/auth/Presentation/patient_onboarding/patient_onboarding_constants.dart';
import 'package:nurse_app/Features/auth/Presentation/patient_onboarding/patient_onboarding_styled_dropdown.dart';

String _profileErrorUserMessage(BuildContext context, Object e) {
  final raw = e.toString().replaceFirst('Exception: ', '').trim();
  final lower = raw.toLowerCase();
  if (lower.contains('not logged in')) {
    return AppLocalizations.of(context)!.notLoggedIn;
  }
  return raw;
}

String _profileGovernorateLabel(AppLocalizations l10n, String apiValue) {
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

String _profileConditionLabel(AppLocalizations l10n, String key) {
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

String _profileGenderDisplay(AppLocalizations l10n, String? g) {
  if (g == null || g.isEmpty) return '';
  if (g == 'Male') return l10n.profileGenderMale;
  if (g == 'Female') return l10n.profileGenderFemale;
  return g;
}

String _profileAllergyChipLabel(AppLocalizations l10n, String en) {
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

class PatientProfileLocalModel {
  PatientProfileLocalModel();

  String fullName = '';
  String email = '';
  String phone = '';
  String? gender;
  DateTime? dateOfBirth;
  String? bloodType;
  String? governorate;
  String area = '';
  String addressLine = '';
  Set<String> conditionKeys = {};
  String otherConditionsText = '';
  Set<String> selectedAllergyChips = {};
  String otherAllergiesText = '';
  String notes = '';

  PatientProfileLocalModel copy() {
    final m = PatientProfileLocalModel();
    m.fullName = fullName;
    m.email = email;
    m.phone = phone;
    m.gender = gender;
    m.dateOfBirth = dateOfBirth;
    m.bloodType = bloodType;
    m.governorate = governorate;
    m.area = area;
    m.addressLine = addressLine;
    m.conditionKeys = Set<String>.from(conditionKeys);
    m.otherConditionsText = otherConditionsText;
    m.selectedAllergyChips = Set<String>.from(selectedAllergyChips);
    m.otherAllergiesText = otherAllergiesText;
    m.notes = notes;
    return m;
  }

  void applyFrom(PatientProfileLocalModel o) {
    fullName = o.fullName;
    email = o.email;
    phone = o.phone;
    gender = o.gender;
    dateOfBirth = o.dateOfBirth;
    bloodType = o.bloodType;
    governorate = o.governorate;
    area = o.area;
    addressLine = o.addressLine;
    conditionKeys = Set<String>.from(o.conditionKeys);
    otherConditionsText = o.otherConditionsText;
    selectedAllergyChips = Set<String>.from(o.selectedAllergyChips);
    otherAllergiesText = o.otherAllergiesText;
    notes = o.notes;
  }
}

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  static const Color primary = Color(0xFF2F7F8D);
  static const Color text = Color(0xFF1D2433);
  static const Color muted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE8ECF2);
  static const Color pageBg = Color(0xFFF6F7F9);

  static const Map<String, String> conditionKeyLabels = {
    'diabetes': 'Diabetes',
    'hypertension': 'Hypertension',
    'asthma': 'Asthma',
    'heart_disease': 'Heart Disease',
    'arthritis': 'Arthritis',
    'none': 'None',
  };

  static const List<String> profileConditionKeyOrder = [
    'diabetes',
    'hypertension',
    'asthma',
    'heart_disease',
    'arthritis',
    'none',
  ];

  static const List<String> allergyChips = [
    'Penicillin',
    'Dust',
    'Food',
    'Latex',
    'Pollen',
  ];

  static const List<String> governorates = [
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

  static const List<String> genders = ['Male', 'Female'];

  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final PatientProfileLocalModel _model = PatientProfileLocalModel();
  PatientProfileLocalModel? _editBaseline;

  bool _isEditing = false;
  bool _isInitialLoading = true;
  bool _isSaving = false;

  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _areaCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _otherCondCtrl;
  late final TextEditingController _otherAllergiesCtrl;
  late final TextEditingController _notesCtrl;

  String? _gender;
  DateTime? _dob;
  String? _bloodType;
  String? _governorate;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _areaCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    _otherCondCtrl = TextEditingController();
    _otherAllergiesCtrl = TextEditingController();
    _notesCtrl = TextEditingController();

    _loadProfile();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _areaCtrl.dispose();
    _addressCtrl.dispose();
    _otherCondCtrl.dispose();
    _otherAllergiesCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isInitialLoading = true);

    try {
      final data = await ApiService.getPatientProfile();
      _applyApiToModel(data);
      _pushControllersFromModel();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _profileErrorUserMessage(context, e),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isInitialLoading = false);
      }
    }
  }

  void _applyApiToModel(Map<String, dynamic> data) {
    _model.fullName = (data['fullName'] ?? '').toString();
    _model.email = (data['email'] ?? '').toString();
    _model.phone = (data['phoneNumber'] ?? data['phone'] ?? '').toString();

    final gender = data['gender']?.toString().trim();
    _model.gender = (gender == null || gender.isEmpty) ? null : gender;

    final dobRaw = data['dateOfBirth']?.toString();
    _model.dateOfBirth =
        (dobRaw == null || dobRaw.isEmpty) ? null : DateTime.tryParse(dobRaw);

    final bloodType = data['bloodType']?.toString().trim();
    _model.bloodType =
        (bloodType == null || bloodType.isEmpty) ? null : bloodType;

    final governorate = data['governorate']?.toString().trim();
    _model.governorate =
        (governorate == null || governorate.isEmpty) ? null : governorate;

    _model.area = (data['area'] ?? '').toString();
    _model.addressLine = (data['address'] ?? '').toString();

    final parsedConditions = _parseConditions(data['conditions']?.toString());
    _model.conditionKeys = parsedConditions.$1;
    _model.otherConditionsText = parsedConditions.$2;

    final parsedAllergies = _parseAllergies(data['allergies']?.toString());
    _model.selectedAllergyChips = parsedAllergies.$1;
    _model.otherAllergiesText = parsedAllergies.$2;

    _model.notes = (data['notes'] ?? '').toString();
  }

  (Set<String>, String) _parseConditions(String? raw) {
    final known = <String, String>{
      'diabetes': 'diabetes',
      'hypertension': 'hypertension',
      'asthma': 'asthma',
      'heart disease': 'heart_disease',
      'arthritis': 'arthritis',
      'none': 'none',
    };

    final selected = <String>{};
    final custom = <String>[];

    if (raw == null || raw.trim().isEmpty) {
      return (selected, '');
    }

    final items = raw
        .split(RegExp(r'[,;\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);

    for (final item in items) {
      final normalized = item.toLowerCase();
      final matched = known[normalized];
      if (matched != null) {
        selected.add(matched);
      } else {
        custom.add(item);
      }
    }

    return (selected, custom.join(', '));
  }

  (Set<String>, String) _parseAllergies(String? raw) {
    final chipSet =
        PatientProfileScreen.allergyChips.map((e) => e.toLowerCase()).toSet();

    final selected = <String>{};
    final custom = <String>[];

    if (raw == null || raw.trim().isEmpty) {
      return (selected, '');
    }

    final items = raw
        .split(RegExp(r'[,;\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);

    for (final item in items) {
      final normalized = item.toLowerCase();
      final matched = PatientProfileScreen.allergyChips.where(
        (chip) => chip.toLowerCase() == normalized,
      );

      if (matched.isNotEmpty && chipSet.contains(normalized)) {
        selected.add(matched.first);
      } else {
        custom.add(item);
      }
    }

    return (selected, custom.join(', '));
  }

  void _pushControllersFromModel() {
    _fullNameCtrl.text = _model.fullName;
    _emailCtrl.text = _model.email;
    _phoneCtrl.text = _model.phone;
    _areaCtrl.text = _model.area;
    _addressCtrl.text = _model.addressLine;
    _otherCondCtrl.text = _model.otherConditionsText;
    _otherAllergiesCtrl.text = _model.otherAllergiesText;
    _notesCtrl.text = _model.notes;
    _gender = _model.gender;
    _dob = _model.dateOfBirth;
    _bloodType = _model.bloodType;
    _governorate = _model.governorate;
  }

  void _pullControllersIntoModel() {
    _model.fullName = _fullNameCtrl.text.trim();
    _model.email = _emailCtrl.text.trim();
    _model.phone = _phoneCtrl.text.trim();
    _model.area = _areaCtrl.text.trim();
    _model.addressLine = _addressCtrl.text.trim();
    _model.otherConditionsText = _otherCondCtrl.text.trim();
    _model.otherAllergiesText = _otherAllergiesCtrl.text.trim();
    _model.notes = _notesCtrl.text.trim();
    _model.gender = _gender;
    _model.dateOfBirth = _dob;
    _model.bloodType = _bloodType;
    _model.governorate = _governorate;
  }

  void _startEdit() {
    setState(() {
      _editBaseline = _model.copy();
      _pushControllersFromModel();
      _isEditing = true;
    });
  }

  String? _joinConditionsForApi() {
    if (_model.conditionKeys.contains('none')) {
      return 'None';
    }

    final labels = <String>[
      for (final key in _model.conditionKeys)
        if (PatientProfileScreen.conditionKeyLabels.containsKey(key))
          PatientProfileScreen.conditionKeyLabels[key]!,
    ];

    final custom = _model.otherConditionsText
        .split(RegExp(r'[,;\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);

    final result = [...labels, ...custom].join(', ').trim();
    return result.isEmpty ? null : result;
  }

  String? _joinAllergiesForApi() {
    final custom = _model.otherAllergiesText
        .split(RegExp(r'[,;\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);

    final result = [..._model.selectedAllergyChips, ...custom].join(', ').trim();
    return result.isEmpty ? null : result;
  }

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() {
      _pullControllersIntoModel();
      _isSaving = true;
    });

    try {
      await ApiService.updatePatientPersonalInfo(
        gender: _model.gender,
        dateOfBirth: _model.dateOfBirth,
        bloodType: _model.bloodType,
      );

      await ApiService.updatePatientAddress(
        governorate: _model.governorate,
        area: _model.area.isEmpty ? null : _model.area,
        address: _model.addressLine.isEmpty ? null : _model.addressLine,
      );

      await ApiService.updatePatientMedicalInfo(
        conditions: _joinConditionsForApi(),
        allergies: _joinAllergiesForApi(),
        notes: _model.notes.isEmpty ? null : _model.notes,
      );

      if (!mounted) return;

      setState(() {
        _isEditing = false;
        _editBaseline = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.profileUpdatedSuccess),
        ),
      );
    } catch (e) {
      if (_editBaseline != null) {
        _model.applyFrom(_editBaseline!);
        _pushControllersFromModel();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _profileErrorUserMessage(context, e),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _cancel() {
    setState(() {
      if (_editBaseline != null) {
        _model.applyFrom(_editBaseline!);
        _pushControllersFromModel();
      }
      _isEditing = false;
      _editBaseline = null;
    });
  }

  void _onConditionToggle(String key, bool selected) {
    setState(() {
      if (key == 'none') {
        if (selected) {
          _model.conditionKeys
            ..clear()
            ..add('none');
        } else {
          _model.conditionKeys.remove('none');
        }
      } else {
        if (selected) {
          _model.conditionKeys.remove('none');
          _model.conditionKeys.add(key);
        } else {
          _model.conditionKeys.remove(key);
        }
      }
    });
  }

  void _onAllergyToggle(String label, bool selected) {
    setState(() {
      if (selected) {
        _model.selectedAllergyChips.add(label);
      } else {
        _model.selectedAllergyChips.remove(label);
      }
    });
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year - 25, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: PatientProfileScreen.primary,
              onPrimary: Colors.white,
              onSurface: PatientProfileScreen.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  String _formatDob(DateTime? d) {
    if (d == null) return '';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  List<String> _conditionDisplayLines(AppLocalizations l10n) {
    final custom = _model.otherConditionsText
        .split(RegExp(r'[,;\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (_model.conditionKeys.contains('none')) {
      return [l10n.profileConditionNone, ...custom];
    }
    final labels = <String>[
      for (final k in _model.conditionKeys)
        if (PatientProfileScreen.conditionKeyLabels.containsKey(k))
          _profileConditionLabel(l10n, k),
      ...custom,
    ];
    return labels;
  }

  List<String> _allergyDisplayLines(AppLocalizations l10n) {
    final custom = _model.otherAllergiesText
        .split(RegExp(r'[,;\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final chips = _model.selectedAllergyChips
        .map((c) => _profileAllergyChipLabel(l10n, c))
        .toList();
    return [...chips, ...custom];
  }

  @override
  Widget build(BuildContext context) {
    const p = PatientProfileScreen.primary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: PatientProfileScreen.pageBg,
      appBar: AppBar(
        backgroundColor: p,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.profileTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _isInitialLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProfileSectionCard(
                          child: _buildHeader(p),
                        ),
                        const SizedBox(height: 12),
                        _ProfileSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(l10n.personalInfo),
                              _isEditing
                                  ? _buildPersonalEdit(p, l10n)
                                  : _buildPersonalView(l10n),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _ProfileSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(l10n.profileAddressSection),
                              _isEditing
                                  ? _buildAddressEdit(p, l10n)
                                  : _buildAddressView(l10n),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _ProfileSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(l10n.profileMedicalSection),
                              _isEditing
                                  ? _buildMedicalEdit(p, l10n)
                                  : _buildMedicalView(l10n),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!_isEditing) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _startEdit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: p,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                l10n.profileEditProfile,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isSaving ? null : _cancel,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: PatientProfileScreen.muted,
                                    side: const BorderSide(
                                      color: PatientProfileScreen.border,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.profileCancel,
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isSaving ? null : _save,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: p,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: _isSaving
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            l10n.profileSave,
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
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader(Color p) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFFEAF4F6),
          child: Icon(Icons.person_rounded, size: 44, color: p),
        ),
        const SizedBox(height: 12),
        if (_model.fullName.isNotEmpty)
          Text(
            _model.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: PatientProfileScreen.text,
            ),
          ),
        if (_model.phone.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            _model.phone,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: PatientProfileScreen.muted,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: PatientProfileScreen.text,
        ),
      ),
    );
  }

  Widget _buildPersonalView(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _viewRow(l10n.fullName, _model.fullName),
        _viewRow(l10n.email, _model.email),
        _viewRow(l10n.phoneNumber, _model.phone),
        _viewRow(
          l10n.gender,
          _profileGenderDisplay(l10n, _model.gender),
        ),
        _viewRow(l10n.dateOfBirth, _formatDob(_model.dateOfBirth)),
        _viewRow(l10n.bloodType, _model.bloodType ?? ''),
      ],
    );
  }

  Widget _buildPersonalEdit(Color p, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textField(
          p,
          label: l10n.fullName,
          controller: _fullNameCtrl,
          readOnly: true,
        ),
        _textField(
          p,
          label: l10n.email,
          controller: _emailCtrl,
          keyboard: TextInputType.emailAddress,
          readOnly: true,
        ),
        _textField(
          p,
          label: l10n.phoneNumber,
          controller: _phoneCtrl,
          keyboard: TextInputType.phone,
          readOnly: true,
        ),
        _dropdown<String>(
          p,
          label: l10n.gender,
          value: _gender,
          hint: l10n.profileSelectGender,
          items: PatientProfileScreen.genders,
          onChanged: (v) => setState(() => _gender = v),
          itemLabel: (g) => _profileGenderDisplay(l10n, g),
        ),
        _label(l10n.dateOfBirth),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDob,
          borderRadius: BorderRadius.circular(16),
          child: InputDecorator(
            decoration: patientOnboardingOutlineDecoration(p),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: PatientProfileScreen.muted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _dob == null
                        ? l10n.profileSelectDate
                        : _formatDob(_dob),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _dob == null
                          ? const Color(0xFF94A3B8)
                          : PatientProfileScreen.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _dropdown<String>(
          p,
          label: l10n.bloodType,
          value: _bloodType,
          hint: l10n.profileSelectBloodType,
          items: PatientProfileScreen.bloodTypes,
          onChanged: (v) => setState(() => _bloodType = v),
        ),
      ],
    );
  }

  Widget _buildAddressView(AppLocalizations l10n) {
    final gov = (_model.governorate ?? '').trim();
    final govDisplay =
        gov.isEmpty ? '' : _profileGovernorateLabel(l10n, gov);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _viewRow(l10n.governorate, govDisplay),
        _viewRow(l10n.area, _model.area),
        _viewRow(l10n.address, _model.addressLine),
      ],
    );
  }

  Widget _buildAddressEdit(Color p, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdown<String>(
          p,
          label: l10n.governorate,
          value: _governorate,
          hint: l10n.profileSelectGovernorate,
          items: PatientProfileScreen.governorates,
          onChanged: (v) => setState(() => _governorate = v),
          itemLabel: (g) => _profileGovernorateLabel(l10n, g),
        ),
        _textField(p, label: l10n.area, controller: _areaCtrl),
        _textField(
          p,
          label: l10n.address,
          controller: _addressCtrl,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildMedicalView(AppLocalizations l10n) {
    final condLines = _conditionDisplayLines(l10n);
    final allergyLines = _allergyDisplayLines(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileConditions,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 8),
        if (condLines.isEmpty)
          Text(
            '—',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: PatientProfileScreen.muted,
            ),
          )
        else
          ...condLines.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $e',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: PatientProfileScreen.text,
                ),
              ),
            ),
          ),
        const SizedBox(height: 14),
        Text(
          l10n.profileAllergies,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          allergyLines.isEmpty ? '—' : allergyLines.join(', '),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: allergyLines.isEmpty
                ? PatientProfileScreen.muted
                : PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.profileNotes,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _model.notes.isEmpty ? '—' : _model.notes,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.35,
            color: _model.notes.isEmpty
                ? PatientProfileScreen.muted
                : PatientProfileScreen.text,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalEdit(Color p, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileConditions,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.profileNoneCombinationWarning,
          style: TextStyle(
            fontSize: 12.5,
            color: PatientProfileScreen.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ...PatientProfileScreen.profileConditionKeyOrder.map((key) {
          final label = _profileConditionLabel(l10n, key);
          final checked = _model.conditionKeys.contains(key);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => _onConditionToggle(key, !checked),
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
                    color: checked ? p : PatientProfileScreen.border,
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
                        onChanged: (v) => _onConditionToggle(key, v ?? false),
                        activeColor: p,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: PatientProfileScreen.text,
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
          l10n.profileOtherConditionOptional,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _otherCondCtrl,
          decoration: patientOnboardingOutlineDecoration(
            p,
            hint: l10n.profileConditionHint,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.profileAllergies,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PatientProfileScreen.allergyChips.map((label) {
            final sel = _model.selectedAllergyChips.contains(label);
            return FilterChip(
              label: Text(_profileAllergyChipLabel(l10n, label)),
              selected: sel,
              onSelected: (v) => _onAllergyToggle(label, v),
              selectedColor: p.withOpacity(0.18),
              checkmarkColor: p,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                color: sel ? p : PatientProfileScreen.text,
              ),
              side: BorderSide(
                color: sel ? p : PatientProfileScreen.border,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.profileOtherAllergiesOptional,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _otherAllergiesCtrl,
          decoration: patientOnboardingOutlineDecoration(
            p,
            hint: l10n.profileAllergiesHint,
          ),
        ),
        const SizedBox(height: 16),
        _textField(
          p,
          label: l10n.profileNotes,
          controller: _notesCtrl,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _viewRow(String label, String value) {
    final safe = value.trim().isEmpty ? '—' : value.trim();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: PatientProfileScreen.muted,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            safe,
            style: const TextStyle(
              color: PatientProfileScreen.text,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(
    Color primary, {
    required String label,
    required TextEditingController controller,
    TextInputType? keyboard,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            readOnly: readOnly,
            decoration: patientOnboardingOutlineDecoration(primary),
          ),
        ],
      ),
    );
  }

  Widget _dropdown<T extends Object>(
    Color primary, {
    required String label,
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T item)? itemLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 8),
          PatientOnboardingStyledDropdown<T>(
            primary: primary,
            value: value,
            hint: hint,
            items: items,
            onChanged: onChanged,
            itemLabel: itemLabel,
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: PatientProfileScreen.text,
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  final Widget child;

  const _ProfileSectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PatientProfileScreen.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

