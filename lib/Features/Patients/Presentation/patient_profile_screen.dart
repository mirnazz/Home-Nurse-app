import 'package:flutter/material.dart';
import 'package:nurse_app/Features/auth/Presentation/patient_onboarding/patient_onboarding_constants.dart';
import 'package:nurse_app/Features/auth/Presentation/patient_onboarding/patient_onboarding_styled_dropdown.dart';

/// Local profile state only — wire to GET/PUT when backend is ready.
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

  static const List<(String, String)> conditionEntries = [
    ('diabetes', 'Diabetes'),
    ('hypertension', 'Hypertension'),
    ('asthma', 'Asthma'),
    ('heart_disease', 'Heart Disease'),
    ('arthritis', 'Arthritis'),
    ('none', 'None'),
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
    _model.otherConditionsText = _otherCondCtrl.text;
    _model.otherAllergiesText = _otherAllergiesCtrl.text;
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

  void _save() {
    setState(() {
      _pullControllersIntoModel();
      _isEditing = false;
      _editBaseline = null;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved locally.')),
    );
    // TODO(backend): PUT patient profile
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
            colorScheme: ColorScheme.light(
              primary: PatientProfileScreen.primary,
              onPrimary: Colors.white,
              onSurface: PatientProfileScreen.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dob = picked);
  }

  String _formatDob(DateTime? d) {
    if (d == null) return '';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  List<String> _conditionDisplayLines() {
    final custom = _model.otherConditionsText
        .split(RegExp(r'[,;\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (_model.conditionKeys.contains('none')) {
      return ['None', ...custom];
    }
    final labels = <String>[
      for (final k in _model.conditionKeys)
        if (PatientProfileScreen.conditionKeyLabels.containsKey(k))
          PatientProfileScreen.conditionKeyLabels[k]!,
      ...custom,
    ];
    return labels;
  }

  List<String> _allergyDisplayLines() {
    final custom = _model.otherAllergiesText
        .split(RegExp(r'[,;\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return [..._model.selectedAllergyChips, ...custom];
  }

  @override
  Widget build(BuildContext context) {
    const p = PatientProfileScreen.primary;

    return Scaffold(
      backgroundColor: PatientProfileScreen.pageBg,
      appBar: AppBar(
        backgroundColor: p,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
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
                        _buildSectionTitle('Personal info'),
                        _isEditing
                            ? _buildPersonalEdit(p)
                            : _buildPersonalView(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProfileSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Address'),
                        _isEditing
                            ? _buildAddressEdit(p)
                            : _buildAddressView(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProfileSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Medical info'),
                        _isEditing
                            ? _buildMedicalEdit(p)
                            : _buildMedicalView(),
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
                        child: const Text(
                          'Edit profile',
                          style: TextStyle(
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
                            onPressed: _cancel,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: PatientProfileScreen.muted,
                              side: const BorderSide(color: PatientProfileScreen.border),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: p,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
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

  Widget _buildPersonalView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _viewRow('Full name', _model.fullName),
        _viewRow('Email', _model.email),
        _viewRow('Phone number', _model.phone),
        _viewRow('Gender', _model.gender ?? ''),
        _viewRow('Date of birth', _formatDob(_model.dateOfBirth)),
        _viewRow('Blood type', _model.bloodType ?? ''),
      ],
    );
  }

  Widget _buildPersonalEdit(Color p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textField(
          p,
          label: 'Full name',
          controller: _fullNameCtrl,
        ),
        _textField(
          p,
          label: 'Email',
          controller: _emailCtrl,
          keyboard: TextInputType.emailAddress,
        ),
        _textField(
          p,
          label: 'Phone number',
          controller: _phoneCtrl,
          keyboard: TextInputType.phone,
        ),
        _dropdown<String>(
          p,
          label: 'Gender',
          value: _gender,
          hint: 'Select gender',
          items: PatientProfileScreen.genders,
          onChanged: (v) => setState(() => _gender = v),
        ),
        _label('Date of birth'),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDob,
          borderRadius: BorderRadius.circular(16),
          child: InputDecorator(
            decoration: patientOnboardingOutlineDecoration(p),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 20, color: PatientProfileScreen.muted),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _dob == null ? 'Select date' : _formatDob(_dob),
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
          label: 'Blood type',
          value: _bloodType,
          hint: 'Select blood type',
          items: PatientProfileScreen.bloodTypes,
          onChanged: (v) => setState(() => _bloodType = v),
        ),
      ],
    );
  }

  Widget _buildAddressView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _viewRow('Governorate', _model.governorate ?? ''),
        _viewRow('Area', _model.area),
        _viewRow('Address', _model.addressLine),
      ],
    );
  }

  Widget _buildAddressEdit(Color p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdown<String>(
          p,
          label: 'Governorate',
          value: _governorate,
          hint: 'Select governorate',
          items: PatientProfileScreen.governorates,
          onChanged: (v) => setState(() => _governorate = v),
        ),
        _textField(p, label: 'Area', controller: _areaCtrl),
        _textField(
          p,
          label: 'Address',
          controller: _addressCtrl,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildMedicalView() {
    final condLines = _conditionDisplayLines();
    final allergyLines = _allergyDisplayLines();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conditions',
          style: TextStyle(
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
        const Text(
          'Allergies',
          style: TextStyle(
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
        const Text(
          'Notes',
          style: TextStyle(
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

  Widget _buildMedicalEdit(Color p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conditions',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'None cannot be combined with other conditions.',
          style: TextStyle(
            fontSize: 12.5,
            color: PatientProfileScreen.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ...PatientProfileScreen.conditionEntries.map((e) {
          final key = e.$1;
          final label = e.$2;
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
        const Text(
          'Other condition (optional)',
          style: TextStyle(
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
            hint: 'e.g. Cancer, Kidney disease',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Allergies',
          style: TextStyle(
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
              label: Text(label),
              selected: sel,
              onSelected: (v) => _onAllergyToggle(label, v),
              selectedColor: p.withValues(alpha: 0.18),
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
        const Text(
          'Other allergies (optional)',
          style: TextStyle(
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
            hint: 'e.g. Sulfa, nuts, seafood',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Notes',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: PatientProfileScreen.text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesCtrl,
          maxLines: 4,
          minLines: 3,
          decoration: patientOnboardingOutlineDecoration(
            p,
            hint: 'Anything else your care team should know...',
          ),
        ),
      ],
    );
  }

  static Widget _viewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: PatientProfileScreen.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '—' : value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: value.isEmpty
                  ? PatientProfileScreen.muted
                  : PatientProfileScreen.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(
    Color p, {
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: PatientProfileScreen.text,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            decoration: patientOnboardingOutlineDecoration(p),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: PatientProfileScreen.text,
      ),
    );
  }

  Widget _dropdown<T extends Object>(
    Color p, {
    required String label,
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: PatientProfileScreen.text,
            ),
          ),
          const SizedBox(height: 8),
          PatientOnboardingStyledDropdown<T>(
            value: value,
            hint: hint,
            items: items,
            onChanged: onChanged,
            primary: p,
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PatientProfileScreen.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
