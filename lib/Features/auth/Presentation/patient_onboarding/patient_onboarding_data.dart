/// Local-only profile data collected during patient onboarding (not sent to API here).
class PatientOnboardingData {
  PatientOnboardingData({
    required this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.bloodType,
    this.governorate,
    this.area,
    this.addressLine,
    this.conditionKeys = const {},
    this.allMedicalConditions = const [],
    this.allergies = const [],
    this.notes,
  });

  /// From signup step 1; stored locally only if backend does not accept it yet.
  final String phoneNumber;

  String? gender;
  DateTime? dateOfBirth;
  String? bloodType;
  String? governorate;
  String? area;
  String? addressLine;

  /// Keys e.g. diabetes, hypertension, asthma, heart_disease, arthritis, none
  Set<String> conditionKeys;

  /// Combined display list: selected condition labels + custom segments (synced locally).
  List<String> allMedicalConditions;

  List<String> allergies;
  String? notes;
}
